`include "Math/svreal.sv"
`include "MAC.sv"

module MAC_tb;

reg clk;
reg rst_n;
`MAKE_REAL(a, 5.0);
`MAKE_REAL(b, 5.0);
`MAKE_REAL(out, 5.0);


MAC u_dut(
    .clk(clk),
    .rst_n(rst_n),
    .a(a),
    .b(b),
    .out(out)
);

initial begin
    clk = 0;
    rst_n = 1;
    #20;
    rst_n = 0;

    @(posedge clk); `PRINT_REAL(out);
    @(posedge clk); `PRINT_REAL(out);
    @(posedge clk); `PRINT_REAL(out);
end

forever begin
    #5 clk = ~clk;
end

endmodule