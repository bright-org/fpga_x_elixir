#include <iostream>
#include <cstdint>
#include <random>
#include <chrono>
#include <unistd.h>
//#include <stdlib.h>
#include <fcntl.h>
//#include <errno.h>
#include <sys/ioctl.h>

#include "_calcdma/calcdma.h"


const int N = 1024*1024;


int main(int argc, char *argv[])
{
    std::cout << "--- test start ---" << std::endl;

    // ドライバオープン
    int fd = open("/dev/elixirchip-calcdma0", O_RDWR);
    if (fd < 0) {
        std::cout << "open error" << std::endl;
        return 1;
    }

    // ユーザー空間にデータを置いておく
    static float src[N];

    // 0.5～1.5 の範囲の乱数で src を初期化
    std::mt19937 engine(123);
    std::uniform_real_distribution<float> dist(0.5, 1.5);
    for (int i = 0; i < N; i++) {
        src[i] = dist(engine);
    }

    // CPUで計算
    static float dst_cpu[N];
    {
        // 時間計測開始
        auto start = std::chrono::system_clock::now();

        // CPUで計算
        for (int i = 0; i < N; i++) {
            dst_cpu[i] = std::exp(src[i]);
        }

        // 時間計測終了 (マイクロ秒単位で表示)
        auto end = std::chrono::system_clock::now();
        auto dur = end - start;
        auto usec = std::chrono::duration_cast<std::chrono::microseconds>(dur).count();
        // 表示
        std::cout << "CPU  : " << usec << " us" << std::endl;
    }


    // FPGAで計算
    static volatile float dst[N];
    {
        // 時間計測開始
        auto start = std::chrono::system_clock::now();

        // FPGAで計算
        struct calcdma_calc calc;
        calc.src = src;
        calc.dst = (float *)dst;
        calc.size = sizeof(src);
        if ( ioctl(fd, CALCDMA_CALC, &calc) < 0) {
            std::cout << "ioctl error" << std::endl;
            close(fd);
            return 1;
        }

        // 時間計測終了 (マイクロ秒単位で表示)
        auto end = std::chrono::system_clock::now();
        auto dur = end - start;
        auto usec = std::chrono::duration_cast<std::chrono::microseconds>(dur).count();
        // 表示
        std::cout << "FPGA : " << usec << " us" << std::endl;
    }

    // CPUの結果と比較
    for (int i = 0; i < N; i++) {
        if ( fabs(dst[i] - dst_cpu[i]) > 1.0e-5 ) {
            std::cout << "mismatch i = " << i << "  dst = " << dst[i] << "  dst_cpu = " << dst_cpu[i] << std::endl;
            break;
        }
    }

    std::cout << "dst[0] = " << dst[0] << "  exp : " << std::exp(src[0]) << std::endl;
    std::cout << "dst[1] = " << dst[1] << "  exp : " << std::exp(src[1]) << std::endl;
    std::cout << "dst[2] = " << dst[2] << "  exp : " << std::exp(src[2]) << std::endl;
    std::cout << "dst[3] = " << dst[3] << "  exp : " << std::exp(src[3]) << std::endl;
    std::cout << "dst[4] = " << dst[4] << "  exp : " << std::exp(src[4]) << std::endl;
    std::cout << "dst[4] = " << dst[5] << "  exp : " << std::exp(src[5]) << std::endl;
    std::cout << "dst[4] = " << dst[6] << "  exp : " << std::exp(src[6]) << std::endl;
    std::cout << "dst[4] = " << dst[7] << "  exp : " << std::exp(src[7]) << std::endl;
    std::cout << "dst[4] = " << dst[8] << "  exp : " << std::exp(src[8]) << std::endl;
    
    printf("dst[0] = %08x\n", *(unsigned int *)&dst[0]);
    printf("dst[1] = %08x\n", *(unsigned int *)&dst[1]);
    printf("dst[2] = %08x\n", *(unsigned int *)&dst[2]);
    printf("dst[3] = %08x\n", *(unsigned int *)&dst[3]);

    // ドライバクローズ
    close(fd);

    std::cout << "--- devdrv test end ---" << std::endl;

    return 0;
}


// end of file
