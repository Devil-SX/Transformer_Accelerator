`include "Types.sv"

module MM_tb;

    // Global Inputs
    reg clk;
    reg rst_n;

    // Data Generation
    `SINGLE column[`SYS_ARRAY_LEN];
    logic column_valid;
    `SINGLE row[`SYS_ARRAY_LEN];
    logic row_valid;
    logic clear;

    // Outputs
    `SINGLE out[`SYS_ARRAY_LEN][`SYS_ARRAY_LEN];
    logic ready;

    // Hidden Variables
    Scalar column_skew[`SYS_ARRAY_LEN];
    Scalar row_skew[`SYS_ARRAY_LEN];


    Skew u_skew_column(
        .clk(clk),
        .rst_n(rst_n),
        .data_in(column),
        .data_valid(column_valid),
        .scalar_out(column_skew)
    );

    Skew u_skew_row(
        .clk(clk),
        .rst_n(rst_n),
        .data_in(row),
        .data_valid(row_valid),
        .scalar_out(row_skew)
    );

    SystolicArray u_dut(
        .clk(clk),
        .rst_n(rst_n),
        .clear(clear),
        .column(column_skew),
        .row(row_skew),
        .ready(ready),
        .out(out)
    );

    int counter = 0;
    initial begin
        column_valid = 1'b1;
        row_valid = 1'b1;
        for(int i=0; i<`SYS_ARRAY_LEN; i++) begin
            column[i] = $shortrealtobits(shortreal'(5.0));
            row[i] = $shortrealtobits(shortreal'(3.0));
        end
        
        clear = 0;
        rst_n = 1;
        #20 rst_n = 0;
        $display("set zero now!");
        #20 rst_n = 1;
        $display("set one now!");

        // Generate Data
        for(int i=0;i<`SYS_ARRAY_LEN; i++) begin
            @(posedge clk) $write("Generate Data %d", i);
        end
        // End Generate
        @(posedge clk) begin
            column_valid = 1'b0;
            row_valid = 1'b0;
        end

        forever begin
            @(posedge clk) begin
                if(ready == 1'b1) $finish;
                counter = counter + 1;
                if(counter >= 500) begin
                    $write("Simulation Failed!\n");
                    $finish;
                end
            end
        end

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
        $dumpvars(0, MM_tb);
    end

endmodule