`include "Types.sv"

module Skew(
    input clk,
    input rst_n,

    // Fetcher ->
    input `NUMBER data_in[`SYS_ARRAY_LEN],
    input logic data_valid,

    // -> Systolic Array
    output Scalar scalar_out[`SYS_ARRAY_LEN]
);

Scalar data_scalar[`SYS_ARRAY_LEN];
always_comb begin 
    for(int i = 0; i < `SYS_ARRAY_LEN; i++) begin 
        if (data_valid) data_scalar[i].value = data_in[i];
        else data_scalar[i].value = _ScalarZero();
        data_scalar[i].valid = data_valid;
    end
end

genvar g;
generate
    for (g = 0; g < `SYS_ARRAY_LEN; g++) begin
        ShiftedReg#(.LENGTH(g+1)) shift_reg(
            .clk(clk),
            .rst_n(rst_n),
            .align_input(data_scalar[g]),
            // .align_input('{data_in[g],data_valid}),
            .skew_output(scalar_out[g])
        );
    end
endgenerate


endmodule