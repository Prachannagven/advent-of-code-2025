TOP ?= sol_tb

TOP_MODULE      = $(TOP).v
EXECUTABLE      = $(TOP)
VCD_OUTPUT      = $(TOP).vcd

VERILOG_SOURCES = $(TOP_MODULE) ../../sol.v ../../mod100_pipelined.v

all: simulate

compile: $(VERILOG_SOURCES)
	iverilog -o $(EXECUTABLE) $(VERILOG_SOURCES)

simulate: compile
	vvp $(EXECUTABLE) +vcd=$(VCD_OUTPUT)

clean:
	rm -f $(EXECUTABLE) $(VCD_OUTPUT)

view:
	gtkwave $(VCD_OUTPUT) &

.PHONY: all compile simulate clean view

