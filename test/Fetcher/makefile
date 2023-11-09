root_path = ../..
# 设计哲学，关键变量用绝对路径，其他全用相对路径

fp_path = $(root_path)/libs/Floating-Point-ALU-in-Verilog
include_paths := \
	"$(root_path)" \
	"$(fp_path)/Addition-and-Subtraction" \
	"$(fp_path)/Multiplication"

source_files := \
	$(root_path)/MM/Fetcher.sv \
	$(root_path)/MM/ShiftedReg.sv \
	$(root_path)/MM/Skew.sv \
    $(root_path)/MM/MAC.sv \
	$(root_path)/MM/SystolicArray.sv \
    Fetcher_tb.sv

VCS := vcs
VCS_FLAGS := -sverilog -timescale=1ns/1ns 
SIM_EXECUTABLE := simv

all: compile run

compile:
	$(VCS) $(VCS_FLAGS) $(addprefix +incdir+, $(include_paths)) $(source_files) -o $(SIM_EXECUTABLE)

debug:
	$(VCS) $(VCS_FLAGS) -D DEBUG $(addprefix +incdir+, $(include_paths)) $(source_files) -o $(SIM_EXECUTABLE)

run: compile
	./$(SIM_EXECUTABLE)

clean:
	rm -rf $(SIM_EXECUTABLE) csrc simv.daidir ucli.key vc_hdrs.h
	rm -rf out

.PHONY: all compile run clean