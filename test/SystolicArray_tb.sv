module SystolicArray_tb;

reg clk;
reg rst_n;
real a;
real b;
real out;

SystolicArray u_dut(
    .clk(clk),
    .rst_n(rst_n),
    .a(a),
    .b(b),
    .out(out)
);


initial begin
    a = 5.0;
    b = 5.0;

    rst_n = 1;
    #20;
    rst_n = 0;

    $finish;
end


initial begin
    clk = 0;

    forever begin
        #5 clk = ~clk;
        $display("out = %f", out);
    end
end

endmodule