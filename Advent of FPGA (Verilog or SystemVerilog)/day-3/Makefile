TOP ?= tb_sol_streaming

TOP_MODULE      = $(TOP).sv
EXECUTABLE      = $(TOP)
VCD_OUTPUT      = $(TOP).vcd

SIM_FOLDER      = ./sim
SRC_FOLDER      = ./src

VERILOG_SOURCES = $(SIM_FOLDER)/$(TOP_MODULE) $(SRC_FOLDER)/sol.sv

all: simulate

compile: $(VERILOG_SOURCES)
	iverilog -g2012 $(VERILOG_SOURCES) -o $(SIM_FOLDER)/$(EXECUTABLE)

simulate: compile
	cd $(SIM_FOLDER) && vvp $(EXECUTABLE)

clean:
	rm -f $(SIM_FOLDER)/$(EXECUTABLE) $(SIM_FOLDER)/*.vcd

view:
	gtkwave $(SIM_FOLDER)/$(VCD_OUTPUT) &

.PHONY: all compile simulate clean view

