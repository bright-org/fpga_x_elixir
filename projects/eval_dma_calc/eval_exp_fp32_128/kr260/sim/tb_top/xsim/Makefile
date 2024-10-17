
# get vivado version
empty:=
space:= $(empty) $(empty)
VIVADO_VERSIONS := $(subst .,$(space),$(subst v,,$(word 2,$(shell vivado -version))))
VIVADO_VERSION  := $(word 1,$(VIVADO_VERSIONS)).$(word 2,$(VIVADO_VERSIONS))
XILINX_VIVADO ?= /tools/Xilinx/Vivado/$(VIVADO_VERSION)

# setting
TOP_MODULE = tb_sim

JELLY_TOP_DIR = ../../../../../../../packages/jelly

-include $(JELLY_TOP_DIR)/include/make/def_simulation.inc

EXP_IP_DIR = ../../../ip/vivado$(VIVADO_VERSION)/exponential_fp32/exponential_fp32

SIM_LIB_DIRS += ../../stub
SIM_LIB_DIRS += ../../../rtl
SIM_LIB_DIRS += ../../../../rtl

VLOGFLAGS  = -sv
VLOGFLAGS += --sourcelibext .v
VLOGFLAGS += --sourcelibext .sv
VLOGFLAGS += $(addprefix --sourcelibdir ,$(SIM_LIB_DIRS))

ELABFLAGS  = -debug wave

SRCS  = ../$(TOP_MODULE).sv
SRCS += ../tb_main.sv
SRCS += ../../stub/design_1.v
SRCS += $(EXP_IP_DIR)/sim/exponential_fp32.v 
SRCS += $(XILINX_VIVADO)/data/verilog/src/glbl.v


# rulres
.PHONY: all
all: clean build run

.PHONY: build
build:
	xvlog $(EXP_IP_DIR)/hdl/*.v
	xvhdl $(EXP_IP_DIR)/hdl/*.vhd
	xvlog $(VLOGFLAGS) $(SRCS)
	xelab $(ELABFLAGS) $(TOP_MODULE) glbl -s $(TOP_MODULE) -L unisims_ver -L unimacro_ver -L secureip -L xil_defaultlib

.PHONY: run
run:
	xsim $(TOP_MODULE) --R

.PHONY: clean
clean:
	-rm -fr xsim.dir
	-rm -fr .Xil
	-rm -f webtalk*.jou
	-rm -f webtalk*.log
	-rm -f xvlog*.log
	-rm -f xvlog*.pb
	-rm -f xelab*.log
	-rm -f xelab*.pb
	-rm -f xsim*.jou
	-rm -f xsim*.log

.PHONY: distclean
distclean: clean
	-rm -f *.pgm
	-rm -f *.ppm
	-rm -f $(TOP_MODULE).vcd
	-rm -f $(TOP_MODULE).wdb
