#include <unistd.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <math.h>
#include "erl_nif.h"
#include "dmacalc.h"

static ERL_NIF_TERM
fpga_exp_nif(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
    ErlNifBinary src;
    ErlNifBinary dst;

    if ( argc != 1 || !enif_inspect_binary(env, argv[0], &src) ) {
        return enif_make_badarg(env);
    }

    if( !enif_alloc_binary(src.size, &dst) ) {
        return enif_make_atom(env, "enomem");
    }

#if 0
    float *src_data = (float *)src.data;
    float *dst_data = (float *)dst.data;
    for (int i = 0; i < src.size / sizeof(float); i++) {
        dst_data[i] = expf(src_data[i]);
    }
#else
    int fd = open("/dev/fpga-dmacalc0", O_RDWR);
    if ( fd < 0 ) {
        return enif_make_atom(env, "eacces");
    }
    struct dmacalc_calc calc;
    calc.src  = (float *)src.data;
    calc.dst  = (float *)dst.data;
    calc.size = src.size;
    if ( ioctl(fd, DMACALC_CALC, &calc) < 0 ) {
        close(fd);
        return enif_make_atom(env, "eacces");
    }
    close(fd);
#endif

    return enif_make_binary(env, &dst);
}

static ErlNifFunc nif_funcs[] = {
  {"fpga_exp_nif", 1, fpga_exp_nif}
};

ERL_NIF_INIT(Elixir.FpgaExp, nif_funcs, NULL, NULL, NULL, NULL)
