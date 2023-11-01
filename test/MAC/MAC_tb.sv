`include "Types.sv"
`include "Addition-Subtraction.v"
`include "Multiplication.v"

module MAC_tb;

reg clk;
reg rst_n;
// real a;
// real b;
// real out;
logic `SINGLE a;
logic `SINGLE b;
logic `SINGLE out;

shortreal con;

MAC u_dut(
    .clk(clk),
    .rst_n(rst_n),
    .a(a),
    .b(b),
    .out(out)
);


initial begin
    a = $shortrealtobits(shortreal'(5.0));
    b = $shortrealtobits(shortreal'(5.0));
    $display("a = %f", a);
    $display("b = %f", b);

    rst_n = 1;
    #20 rst_n = 0;
    $display("set zero now!");
    #20 rst_n = 1;
    $display("set one now!");
    #100;

    $finish;
end


initial begin
    clk = 0;

    forever #5 clk = ~clk;
end

initial forever @(posedge clk) $display("out = %f", $bitstoshortreal(out));

endmodule