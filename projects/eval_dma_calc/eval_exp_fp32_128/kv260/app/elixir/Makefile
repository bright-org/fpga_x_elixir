
NIF_LIB  = fpga_exp
PRIV_DIR = priv

CFLAGS   = -O3 -fPIC -shared -lm -I../../../../../../packages/fpga_driver/projects/eval_dma_calc

SRC      = c_src/fpga_exp.c

all: compile

compile:
	@mkdir -p $(PRIV_DIR)
	$(CC) $(CFLAGS) $(SRC) -o $(PRIV_DIR)/$(NIF_LIB).so

clean:
	rm -f $(PRIV_DIR)/$(NIF_LIB).so
