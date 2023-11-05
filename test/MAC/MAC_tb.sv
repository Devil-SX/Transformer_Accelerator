`include "Types.sv"
`include "Addition-Subtraction.v"
`include "Multiplication.v"

module MAC_tb;

reg clk;
reg rst_n;
// real a;
// real b;
// real out;
Scalar a;
Scalar b;
logic `SINGLE out;

shortreal con;

MAC u_dut(
    .clk(clk),
    .rst_n(rst_n),
    .data(a),
    .weight(b),
    .out(out)
);


initial begin
    a.value = $shortrealtobits(shortreal'(5.0));
    b.value = $shortrealtobits(shortreal'(5.0));
    a.valid = 1'b1;
    b.valid = 1'b1;

    $display("a = %f", $bitstoshortreal(a.value));
    $display("b = %f", $bitstoshortreal(b.value));

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