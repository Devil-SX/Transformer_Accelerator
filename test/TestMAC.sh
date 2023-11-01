iverilog -g2012 -s MAC_tb -o  out ../MAC.sv  MAC_tb.sv 
# iverilog -g2012 -s MAC_tb -o out -D DEBUG ../MAC.sv  MAC_tb.sv 
vvp ./out