rm ./out
iverilog -g2012 -s SystolicArray  -I ..   -o  out ../MAC.sv  ../SystolicArray.sv 
# iverilog -g2012 -s MAC_tb -o out -D DEBUG ../MAC.sv  MAC_tb.sv 
vvp ./out