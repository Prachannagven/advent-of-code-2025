TOP_MODULE = sol_tb_test.v
VERILOG_SOURCES = $(TOP_MODULE) ../../sol.v ../../mod100_pipelined.v
EXECUTABLE = sol_tb_test
VCD_OUTPUT = aoc_day1_part1_test.vcd

all: simulate

compile: $(VERILOG_SOURCES)
	iverilog -o $(EXECUTABLE) $(VERILOG_SOURCES)

simulate: compile
	vvp $(EXECUTABLE) +vcd=$(VCD_OUTPUT)

clean:
	rm -f $(VCD_OUTPUT)

view_vcd: 
	gtkwave $(VCD_OUTPUT) &

.PHONY: all compile simulate clean view_vcd


