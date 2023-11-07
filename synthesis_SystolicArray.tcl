set foundary_lib "/opt/Foundary_Library/SMIC180"
set target_library "$foundary_lib/std/synopsys/slow.db"
# slow fast fasta typical
# set link_library "* $target_library"
set link_library "$target_library"
set symbol_library "$foundary_lib/std/symbols/smic18.sdb"

set search_path {
    "."
    "libs/Floating-Point-ALU-in-Verilog/Addition-and-Subtraction"
    "libs/Floating-Point-ALU-in-Verilog/Multiplication"
    }

read_file -format sverilog "MM/MAC.sv"
read_file -format sverilog "MM/SystolicArray.sv"
current_design SystolicArray
link
uniquify