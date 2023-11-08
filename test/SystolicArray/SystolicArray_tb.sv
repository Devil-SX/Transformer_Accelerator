`include "Types.sv"

module SystolicArray_tb;

    reg clk;
    reg rst_n;
    Scalar column[`SYS_ARRAY_LEN];
    Scalar row[`SYS_ARRAY_LEN];
    `NUMBER out[`SYS_ARRAY_LEN][`SYS_ARRAY_LEN];
    logic ready;
    logic clear;

    SystolicArray u_dut(
        .clk(clk),
        .rst_n(rst_n),
        .column(column),
        .row(row),
        .ready(ready),
        .clear(clear),
        .out(out)
    );

    initial begin
        clear = 0;
        for(int i=0; i<`SYS_ARRAY_LEN; i++) begin
            column[i] = '{$shortrealtobits(shortreal'(5.0)), 1'b1};
            row[i] = '{$shortrealtobits(shortreal'(3.0)), 1'b1};
        end

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

        forever begin
            #5 clk = ~clk;
        end
    end

    always @(posedge clk) begin
        $write("\n");
        $write("ready: %d\n", ready);
        for(int i=0; i<`SYS_ARRAY_LEN; i++) begin
            for(int j=0; j<`SYS_ARRAY_LEN; j++) begin
                $write("%0.2f\t",$bitstoshortreal(out[i][j]));
            end
            $write("\n");
        end
    end


    initial begin
        // $fsdbDumpfile("wave.fsdb");
        // $fsdbDumpvars(0, SystolicArray_tb);
        $dumpfile("wave.vcd");
        $dumpvars(0, SystolicArray_tb);
    end

endmodule