`ifndef BASIC_SV
`define BASIC_SV


function automatic int log2_floor(real x);
int i;
begin
    i = 0;
    while(x >= 2.0) begin
    x = x / 2.0;
    i = i + 1;
    end
end
return i;
endfunction


`enfif