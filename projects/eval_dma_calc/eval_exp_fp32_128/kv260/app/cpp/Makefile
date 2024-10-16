
TARGET    = eval_exp_fp32_128_kv260.out

CFLAGS  += -Wall -g -O3 -I../../../../../../packages/jelly/include -I../../../../../../packages/fpga_driver/projects/eval_dma_calc
LDFLAGS += -g

RUN_OPT ?=

OBJS = main.o


.PHONY: all
all: $(TARGET)

.PHONY: clean
clean:
	rm -rf $(TARGET) $(OBJS)

.PHONY: run
run: $(TARGET)
	./$(TARGET) $(RUN_OPT)
#	sudo dmesg | tail -n 20


$(TARGET): $(OBJS)
	g++ -o $(TARGET) $(OBJS) $(LDFLAGS)

%.o : %.cpp
	g++ $(CFLAGS) -c $< -o $@

