`ifndef BFLOAT_SV
`define BFLOAT_SV

`include "../Types.sv"


function automatic BFloat BFloatZero;
    BFloat result;
    result.sign = 0;
    result.exponent = 0;
    result.fraction = 0;
    return result
endfunction

function automatic BFloat BFloatOne;
    BFloat result;
    result.sign = 0;
    result.exponent = 8'b0111_1111;
    result.fraction = 0;
    return result
endfunction

function automatic BFloat _BFloat(real x);
    BFloat result;
    if (x < 0) begin
        result.sign = 1;
        x = -x;
    end else begin
        result.sign = 0;
    end

    return result
endfunction

function automatic BFloat BFloat_Add(BFloat a, BFloat b);
    BFloat result;
    result.sign = a.sign ^ b.sign;
    if (a.exponent > b.exponent) begin
        result.exponent = a.exponent;
        result.fraction = a.fraction + (b.fraction >> (a.exponent - b.exponent));
    end else begin
        result.exponent = b.exponent;
        result.fraction = b.fraction + (a.fraction >> (b.exponent - a.exponent));
    end
    if (result.fraction >= 128) begin
        result.exponent = result.exponent + 1;
        result.fraction = result.fraction >> 1;
    end
    result.sign = result.fraction[6];
    result.fraction = result.fraction[5:0];
    return result;
endfunction

function automatic BFloat BFloat_Mul(BFloat a, BFloat b);
    BFloat result;
    result.sign = a.sign ^ b.sign;
    result.exponent = a.exponent + b.exponent - 127;
    result.fraction = (a.fraction * b.fraction) >> 7;
    if (result.fraction >= 128) begin
        result.exponent = result.exponent + 1;
        result.fraction = result.fraction >> 1;
    end
    result.sign = result.fraction[6];
    result.fraction = result.fraction[5:0];
    return result;
endfunction

function automatic BFloat BFloat_MulAdd(BFloat a, BFloat b, BFloat c);
    BFloat result;
    result = BFloat_Mul(a, b);
    result = BFloat_Add(result, c);
    return result;
endfunction

`endif