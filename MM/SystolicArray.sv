`include "Types.sv"
// `include "Math/BFloat.sv"

module SystolicArray (
    input clk,
    input rst_n,

    input clear,
    input  Scalar column[`SYS_ARRAY_LEN],
    input  Scalar row[`SYS_ARRAY_LEN],

    output `SINGLE out[`SYS_ARRAY_LEN][`SYS_ARRAY_LEN],
    output logic ready
  );
  
  Scalar shift_reg_column[`SYS_ARRAY_LEN][`SYS_ARRAY_LEN];
  Scalar shift_reg_row[`SYS_ARRAY_LEN][`SYS_ARRAY_LEN];

  task  reset();
    for (int i = 0; i < `SYS_ARRAY_LEN; i = i + 1)
    begin
      for (int step = 0; step < `SYS_ARRAY_LEN; step = step + 1)
      begin
        shift_reg_column[i][step] <= '{`SINGLE_WIDTH'b0, 1'b0};
        shift_reg_row[i][step] <= '{`SINGLE_WIDTH'b0, 1'b0};
      end
    end
  endtask

  task shift_reg();
    for (int i = 0; i < `SYS_ARRAY_LEN; i = i + 1) 
      begin
        shift_reg_column[0][i] <= column[i];
        shift_reg_row[i][0] <= row[i];

        for (int step = 1; step < `SYS_ARRAY_LEN; step = step + 1)
        begin
          shift_reg_column[step][i] <= shift_reg_column[step-1][i];
          shift_reg_row[i][step] <= shift_reg_row[i][step-1];
        end
      end
  endtask


  // Array Manipulation not supported by VCS yet
  // assign valid =  (shift_reg_column.and() with (item.valid)) & (shift_reg_row.and() with (item.valid));
  always @(*) begin
    ready = 1'b1;
    for (int i = 0; i < `SYS_ARRAY_LEN; i = i + 1) 
      for (int step = 0; step < `SYS_ARRAY_LEN; step = step + 1)
        begin
          ready = ready & (~shift_reg_column[step][i].valid);
          ready = ready & (~shift_reg_row[i][step].valid);
        end
  end

  // Systolic Data Flow
  always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n) begin
      reset();
    end

    else
    begin
      shift_reg();
    end
  end

  // array pe
  genvar v;
  genvar h;
  generate
    for (v = 0; v < `SYS_ARRAY_LEN; v = v + 1) begin
       for (h = 0; h < `SYS_ARRAY_LEN; h = h + 1) begin
          MAC u_MAC (
            .clk(clk),
            .rst_n(rst_n),
            .clear(clear),
            .data(shift_reg_column[v][h]),
            .weight(shift_reg_row[v][h]),
            .out(out[v][h])
          );
       end 
    end
  endgenerate


endmodule