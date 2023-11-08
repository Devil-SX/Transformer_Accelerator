`include "Types.sv"

module ShiftedReg #(
    parameter LENGTH = 1
)(
    input clk,
    input rst_n,

    input Scalar align_input,
    output Scalar skew_output
);

Scalar shift_reg[LENGTH];
// LSB is the olddest data

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        // shift_reg <= '{`LENGTH{_ScalarZero()}};
        shift_reg <= '{default:'0};
    end
    else begin
        begin
            shift_reg[0] <= align_input;
            for(int i = 0; i<LENGTH-1; i++) begin
                shift_reg[i+1] <= shift_reg[i];
            end
        end
    end
end

assign skew_output = shift_reg[LENGTH-1];

endmodule