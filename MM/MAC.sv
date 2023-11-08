// `include "Math/BFloat.sv"
`include "Types.sv"

// `include "Math/svreal.sv"
`include "Addition-Subtraction.v"
`include "Multiplication.v"

module MAC(
    input clk,
    input rst_n,

    input clear,
    input Scalar data,
    input Scalar weight,

    output `NUMBER out
);

`NUMBER a_mul_b;
`NUMBER out_sum;

Multiplication u_mul(
    .a_operand(data.value),
    .b_operand(weight.value),
    .result(a_mul_b)
);

Addition_Subtraction u_add(
    .AddBar_Sub(1'b0),
    .a_operand(out),
    .b_operand(a_mul_b),
    .result(out_sum)
);

always_ff @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        out <= 0;
    end
    else begin
        if (clear) out <= 0;
        else if(data.valid && weight.valid) out <= out_sum;
        else out <= out;

        `ifdef DEBUG
            $display("MAC: %f * %f = %f", data_in.value, weight_in.value, out);
        `endif
    end
end


endmodule