module aclk_timegen(clock,
                reset,
                reset_count,
                fastwatch,one_minute,one_second);
  input clock,reset,reset_count ,fastwatch;

  output one_minute,one_second;

  reg [13:0] count;
  reg one_second;
  reg one_minute_reg;
  reg one_minute;

  //one_minute
  always @ ( posedge clock or posedge reset ) begin
    if (reset) begin
      count<=14'b0;
      one_minute_reg<=0;
    end
    else if (reset_count) begin
      count<=14'b0;
      one_minute_reg<=1'b0;
    end
    else if (count[13:0]==14'd15359) begin
      count<=14'b0;
      one_minute_reg<=1'b1;
    end
    else begin
      count<=count+14'b1;
      one_minute_reg<=1'b0;
    end
  end

  //one second pulse generation
  always @ ( posedge clock or posedge reset ) begin
    if (reset) begin
      one_second<=1'b0;
    end
    else if (reset_count) begin
      one_second<=1'b0;
    end
    else if (count[7:0]==8'd255) begin
      one_second<=1'b1;
    end
    else begin
      one_second <= 1'b0;
    end
  end

  always @ ( * ) begin
    if (fastwatch) begin
      one_minute = one_second;
    end
    else begin
      one_minute = one_minute_reg;
    end
  end

endmodule //timegen
