TOP ?= tb_sol_streaming

TOP_MODULE      = $(TOP).sv
EXECUTABLE      = $(TOP)
VCD_OUTPUT      = $(TOP).vcd

VERILOG_SOURCES = $(TOP_MODULE) sol2.sv

all: simulate

compile: $(VERILOG_SOURCES)
	iverilog -g2012  $(VERILOG_SOURCES) -o $(EXECUTABLE)

simulate: compile
	vvp $(EXECUTABLE) +vcd=$(VCD_OUTPUT)

# Target for streaming testbench
streaming: 
	$(MAKE) TOP=tb_sol_streaming all

clean:
	rm -f $(EXECUTABLE) $(VCD_OUTPUT) tb_sol tb_sol_streaming wave.vcd wave_streaming.vcd

view:
	gtkwave $(VCD_OUTPUT) &

.PHONY: all compile simulate streaming clean view

