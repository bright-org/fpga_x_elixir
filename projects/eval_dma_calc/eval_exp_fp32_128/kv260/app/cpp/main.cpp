#include <iostream>
#include <iomanip>
#include <fstream>
#include <cstdint>
#include <random>
#include <chrono>
#include <unistd.h>
#include <fcntl.h>
#include <sys/ioctl.h>

#include "dmacalc.h"


const int MAX_N = 1*1024*1024;


int main(int argc, char *argv[])
{
    std::cout << "--- start ---" << std::endl;

    // ドライバオープン
    int fd = open("/dev/fpga-dmacalc0", O_RDWR);
    if (fd < 0) {
        std::cout << "open error" << std::endl;
        return 1;
    }

    // ユーザー空間にデータを置いておく
    static float src[MAX_N];
    static float dst_cpu[MAX_N];
    static float dst_fpga[MAX_N];

    // 0.5～1.5 の範囲の乱数で src を初期化
    std::mt19937 engine(123);
    std::uniform_real_distribution<float> dist(0.5, 1.5);

    // テキストファイルを開く
    std::ofstream ofs("result.csv");
    ofs << "size,CPU[usec],FPGA[usec]" << std::endl;

    for ( int N = 4; N <= MAX_N; N *= 2 ) {
        // 0.5～1.5 の範囲の乱数で src を初期化
        for (int i = 0; i < N; i++) {
            src[i] = dist(engine);
        }

        // CPUで計算
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
            std::cout << "size : " << std::setw(8) << N << "  CPU  : " << std::setw(8) << usec << " us";
            ofs << N << "," << usec;
        }

        // FPGAで計算
        {
            // 時間計測開始
            auto start = std::chrono::system_clock::now();

            // FPGAで計算
            struct dmacalc_calc calc;
            calc.src = src;
            calc.dst = (float *)dst_fpga;
            calc.size = N * sizeof(src[0]);
            if ( ioctl(fd, DMACALC_CALC, &calc) < 0 ) {
                std::cout << "ioctl error" << std::endl;
                close(fd);
                return 1;
            }

            // 時間計測終了 (マイクロ秒単位で表示)
            auto end = std::chrono::system_clock::now();
            auto dur = end - start;
            auto usec = std::chrono::duration_cast<std::chrono::microseconds>(dur).count();
            // 表示
            std::cout << "  FPGA : " << std::setw(8) << usec << " us" << std::endl;
            ofs << "," << usec << std::endl;
        }

        usleep(100);

        // CPUの結果と比較
        for (int i = 0; i < N; i++) {
            if ( fabs(dst_fpga[i] - dst_cpu[i]) > 1.0e-5 ) {
                std::cout << "mismatch i = " << i << "  dst = " << dst_fpga[i] << "  dst_cpu = " << dst_cpu[i] << std::endl;
                break;
            }
        }
    }

    /*
    std::cout << "dst[0] = " << dst[0] << "  exp : " << std::exp(src[0]) << std::endl;
    std::cout << "dst[1] = " << dst[1] << "  exp : " << std::exp(src[1]) << std::endl;
    std::cout << "dst[2] = " << dst[2] << "  exp : " << std::exp(src[2]) << std::endl;
    std::cout << "dst[3] = " << dst[3] << "  exp : " << std::exp(src[3]) << std::endl;
    std::cout << "dst[4] = " << dst[4] << "  exp : " << std::exp(src[4]) << std::endl;
    std::cout << "dst[5] = " << dst[5] << "  exp : " << std::exp(src[5]) << std::endl;
    std::cout << "dst[6] = " << dst[6] << "  exp : " << std::exp(src[6]) << std::endl;
    std::cout << "dst[7] = " << dst[7] << "  exp : " << std::exp(src[7]) << std::endl;
    std::cout << "dst[8] = " << dst[8] << "  exp : " << std::exp(src[8]) << std::endl;
    */

    // ドライバクローズ
    close(fd);

    std::cout << "--- end ---" << std::endl;

    return 0;
}


// end of file
