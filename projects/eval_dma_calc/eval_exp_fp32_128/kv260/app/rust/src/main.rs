//use nix::sys::stat::Mode;

//use std::fs::OpenOptions;
//use std::os::unix::io::AsRawFd;
//use nix::ioctl_write_ptr;
//use nix::unistd::close;
//use nix;
//use nix::request_code_write;

use nix::fcntl::OFlag;
use nix::sys::stat::Mode;
use std::mem::size_of;

use rand::thread_rng;
use rand::Rng;
use rand_distr::StandardNormal;

#[repr(C)]
struct DmacalcCalc {
    src: *const f32,
    dst: *mut f32,
    size: usize,
}

const DMACALC_IOC_TYPE: u8 = b'E';
const DMACALC_CALC: u64 = nix::request_code_write!(DMACALC_IOC_TYPE, 1, size_of::<DmacalcCalc>());

const N: usize = 64 * 1024;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    // デバドラオープン
    let fd = nix::fcntl::open("/dev/fpga-dmacalc0", OFlag::O_RDWR, Mode::empty())?;

    println!("---- start ----");

    // 正規分布の乱数で初期化
    let mut src = vec![0.0f32; N];
    let mut rng = thread_rng();
    for i in 0..N {
        src[i] = rng.sample(StandardNormal);
    }

    // CPUで計算
    let start = std::time::Instant::now();
    let dst_cpu: Vec<f32> = src.iter().map(|&x| x.exp()).collect();
    let duration = start.elapsed();
    println!("CPU  : {} usec", duration.as_micros());

    // FPGAで計算
    let start = std::time::Instant::now();
    let mut dst_fpga = vec![0.0f32; N];
    let calc = DmacalcCalc {
        src: src.as_ptr(),
        dst: dst_fpga.as_mut_ptr(),
        size: src.len() * size_of::<f32>(),
    };
    unsafe {
        nix::libc::ioctl(fd, DMACALC_CALC, &calc);
    }
    let duration = start.elapsed();
    println!("FPGA : {} usec", duration.as_micros());

    // 結果の比較
    let mut err_max = 0.0;
    for i in 0..N {
        let err = (dst_cpu[i] - dst_fpga[i]).abs();
        if err > err_max {
            err_max = err;
        }
    }
    println!("err_max = {}", err_max);

    // デバドラクローズ
    nix::unistd::close(fd)?;

    println!("---- end ----");

    Ok(())
}
