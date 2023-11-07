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

// Single Float
`define SINGLE_WIDTH 32
`define SINGLE logic[`SINGLE_WIDTH-1:0]

// INT8
`define INT8_WIDTH 8
`define INT8


`define SYS_ARRAY_LEN 6
typedef struct packed {
    `SINGLE value;
    logic valid;
} Scalar;

function automatic Scalar  _ScalarZero;
    _ScalarZero.value = `SINGLE_WIDTH'b0;
    _ScalarZero.valid = 1'b0;
endfunction

typedef Scalar ScalarArray [`SYS_ARRAY_LEN];
function automatic ScalarArray  _ScalarZeroArray;
    for(int i = 0; i < `SYS_ARRAY_LEN; i++) begin
        _ScalarZeroArray[i] = _ScalarZero();
    end
endfunction

typedef ScalarArray Scalar2DArray [`SYS_ARRAY_LEN];
function automatic Scalar2DArray  _ScalarZero2DArray;
    for(int i = 0; i < `SYS_ARRAY_LEN; i++) begin
        _ScalarZero2DArray[i] = _ScalarZeroArray();
    end
endfunction


`endif