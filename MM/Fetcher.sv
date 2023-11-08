`include "Types.sv"

/*
Two Modes:
Read Mode: Bus -> Fetcher
while wready = 1
wavlid set high start inputing

Feed Mode: Fetcher -> Skew
while 
set wready = 0
*/

typedef enum logic{
    Fetcher_Read = 0,
    Fetcher_Feed = 1
} FetcherState;


module Fetcher (
    input clk,
    input rst_n,

    // Bus ->
    input cs,
    WritePort.slave wport, // Busy state as wready
    input logic [`SLAVE_ADDR] waddr,

    // -> Skew
    input logic feed,
    output `NUMBER data_out[`SYS_ARRAY_LEN],
    output logic data_valid
);


`NUMBER matrix_buf [`SYS_ARRAY_LEN][`SYS_ARRAY_LEN];
FetcherState State, Next_State = Fetcher_Init;
logic [$clog2(`SYS_ARRAY_LEN)-1:0] point;


// State Transfer
always_comb begin
    case (State)
        Fetcher_Read: begin
            if(feed) Next_State = Fetcher_Feed;
            else Next_State = Fetcher_Read; 
        end
        Fetcher_Feed: begin
            if(point==`SYS_ARRAY_LEN-1) Next_State = Fetcher_Read;
            else Next_State = Fetcher_Feed;
        end
        default: begin
            Next_State = Fetcher_Read;
        end
    endcase
end


// Combine Output
always_comb begin
    case (State)
        Fetcher_Read: begin
            data_valid = 1'b0;
            wport.wready = 1'b1;
            if(wport.wvalid && cs) matrix_buf[waddr] = wport.data;
            else matrix_buf[waddr] = matrix_buf[waddr];
        end
        Fetcher_Feed: begin
            data_valid = 1'b1;
            wport.wready = 1'b0;
            data_out = matrix_buf[point];
        end
        default: begin
            data_valid = 1'b0;
            wport.wready = 1'b0;
        end
    endcase
end


task reset()
    State <= Fetcher_Read;
    point <= 0;
endtask

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        reset();
    end
    else begin
        State <= Next_State;
        case(State)
            Fetcher_Feed: begin
                point <= point + 1'b1;
            end
            default: begin
                point <= 0;
            end
        endcase
    end
end


endmodule