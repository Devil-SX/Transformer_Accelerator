`ifndef TYPES_SV
`define TYPES_SV

// Fixed Float
`define FIXED_WIDTH 32
`define FIXED_POINT 16
`define FIXED [`FIXED_WIDTH-1:0]

// Brain Float
typedef struct packed {
    logic sign;
    logic [7:0] exponent; 
    logic [6:0] fraction;
} BFloat;
/*
Exponent:
Exponent Bias = 127 
00H | 0, -0 | subnormal numbers
01H -> FEH | normalized value
FFH | infinity | NaN

Examples:
0 01111111 0000000 = 1 (Hidden One)
1 10000000 0000000 = -2
*/


`endif TYPES_SV