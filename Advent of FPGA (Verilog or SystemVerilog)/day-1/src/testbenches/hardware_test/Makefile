TOP_MODULE = hw_tb.v
VERILOG_SOURCES = $(TOP_MODULE) ../../hardware_wrapper.v ../../sol.v ../../mod100_pipelined.v
EXECUTABLE = hw_test
VCD_OUTPUT = hardware_wrapper_test.vcd

all: simulate

compile: $(VERILOG_SOURCES)
	iverilog -o $(EXECUTABLE) $(VERILOG_SOURCES)

simulate: compile
	vvp $(EXECUTABLE) +vcd=$(VCD_OUTPUT)

clean:
	rm -f $(VCD_OUTPUT)

view: 
	gtkwave $(VCD_OUTPUT) &

.PHONY: all compile simulate clean view


