`include "Types.sv"

module Fetcher_tb;

    // Global Inputs
    reg clk;
    reg rst_n;

    // Data Generation
    `NUMBER data_column[`BUS_ARRAY_WIDTH];
    `NUMBER data_row[`BUS_ARRAY_WIDTH];
    logic clear;
    logic feed;
    // Column Bus Interface
    WritePort column_wport();
    logic [`SLAVE_ADDR-1:0] column_waddr; 
    // Row Bus Interface
    WritePort row_wport();
    logic [`SLAVE_ADDR-1:0] row_waddr; 


    // Outputs
    `NUMBER out[`SYS_ARRAY_LEN][`SYS_ARRAY_LEN];
    logic ready;

    // Hidden Variables
    // Fetcher Outputs
    `NUMBER column[`SYS_ARRAY_LEN];
    logic column_valid;
    `NUMBER row[`SYS_ARRAY_LEN];
    logic row_valid;

    // Skew Outputs
    Scalar column_skew[`SYS_ARRAY_LEN];
    Scalar row_skew[`SYS_ARRAY_LEN];

    Fetcher u_fetcher_column(
        .clk(clk),
        .rst_n(rst_n),
        .cs(1'b1),
        .wport(column_wport),
        .waddr(column_waddr),
        .feed(feed),
        .data_out(column),
        .data_valid(column_valid)
    );

    Fetcher u_fetcher_row(
        .clk(clk),
        .rst_n(rst_n),
        .cs(1'b1),
        .wport(row_wport),
        .waddr(row_waddr),
        .feed(feed),
        .data_out(row),
        .data_valid(row_valid)
    );

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


    task write_buf;
        input [`SLAVE_ADDR-1:0] addr;
        input `NUMBER data [`BUS_ARRAY_WIDTH];
        // ref WritePort wport;     // Cannot Pass Interface as arguments
        ref `NUMBER wdata[`BUS_ARRAY_WIDTH];
        ref logic wvalid;
        ref logic [`SLAVE_ADDR-1:0] waddr;
        begin
            waddr = addr;
            wdata = data;
            wvalid = 1'b1;
            @(posedge clk);
            wvalid = 1'b0;
        end
    endtask

    task print_out;
        $write("\n");
        $write("ready: %d\n", ready);
        for(int i=0; i<`SYS_ARRAY_LEN; i++) begin
            for(int j=0; j<`SYS_ARRAY_LEN; j++) begin
                $write("%0.2f\t",$bitstoshortreal(out[i][j]));
            end
            $write("\n");
        end
    endtask


    int counter = 0;
    initial begin
        // Generate Data
        for(int i=0; i<`BUS_ARRAY_WIDTH; i++) begin
            data_column[i] = $shortrealtobits(shortreal'(5.0));
            data_row[i] = $shortrealtobits(shortreal'(3.0));
        end
        clear = 0;
        feed = 0;

        // Set Reset
        rst_n = 1;
        #20 rst_n = 0;
        $display("set zero now!");
        #20 rst_n = 1;
        $display("set one now!");

        // WriteFetcher
        fork
            for(int i=0; i<2**`SLAVE_ADDR; i++) begin
                write_buf(i, 
                    data_column, 
                    column_wport.wdata, 
                    column_wport.wvalid,
                    column_waddr);
            end
            for(int i=0; i<2**`SLAVE_ADDR; i++) begin
                write_buf(i, 
                    data_row, 
                    row_wport.wdata, 
                    row_wport.wvalid,
                    row_waddr);
            end
        join

        // Feed
        @(posedge clk) feed = 1'b1;
        $write("Feed Now!");
        @(posedge clk) feed = 1'b0;

        @(posedge clk);
        @(posedge clk);
        @(posedge clk);

        forever begin
            @(posedge clk) begin
                print_out();
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


    initial begin
        // $fsdbDumpfile("wave.fsdb");
        // $fsdbDumpvars(0, SystolicArray_tb);
        $dumpfile("wave.vcd");
        $dumpvars(0, Fetcher_tb);
    end

endmodule