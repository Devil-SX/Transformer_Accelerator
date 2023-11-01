// `include "Math/BFloat.sv"
// `include "Types.sv"

`include "Math/svreal.sv"

module MAC(
    input clk,
    input rst_n,

    `INPUT_REAL(a),
    `INPUT_REAL(b),
    `OUTPUT_REAL(out)
);

`MAKE_REAL(mul, 0.0);

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        `FORCE_REAL(0.0, out);
    end
    else begin
        `ADD_REAL(out, `MUL_REAL(a, b, mul), out);
    end
end

endmodule