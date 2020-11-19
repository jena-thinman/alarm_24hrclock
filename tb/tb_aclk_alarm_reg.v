module tb_aclk_alarm_reg ();
  reg [3:0] new_alarm_ms_hr,
            new_alarm_ls_hr,
            new_alarm_ms_min,
            new_alarm_ls_min;

  reg clock,reset,load_new_alarm;

  wire [3:0] alarm_time_ms_hr,
             alarm_time_ls_hr,
             alarm_time_ms_min,
             alarm_time_ls_min;

  parameter CYCLE = 2;

  aclk_alarm_reg DUT(new_alarm_ms_hr,
                new_alarm_ls_hr,
                new_alarm_ms_min,
                new_alarm_ls_min,
                load_new_alarm,
                clock,
                reset,
                alarm_time_ms_hr,
                alarm_time_ls_hr,
                alarm_time_ms_min,
                alarm_time_ls_min );

  always begin
    #(CYCLE/2);
    clock = 1'b1;
    #(CYCLE/2);
    clock = ~clock;
  end

  task initialize();
    begin
      reset = 1'b1;
      #2reset = 1'b0;
    end
  endtask

  task new_alarm(input [3:0] ms_hr,
                     input [3:0] ls_hr,
                     input [3:0] ms_min,
                     input [3:0] ls_min);
    begin
      load_new_alarm=1'b1;
      new_alarm_ms_hr = ms_hr;
      new_alarm_ls_hr = ls_hr;
      new_alarm_ms_min = ms_min;
      new_alarm_ls_min = ls_min;
      #2 load_new_alarm=1'b0;
    end
  endtask

  initial begin
    initialize;
    new_alarm(4'd1,4'd2,4'd3,4'd0);
    #50;
    new_alarm(4'd1,4'd0,4'd4,4'd5);
    #50;
    new_alarm(4'd0,4'd8,4'd4,4'd0);
    #200 $finish;
  end

endmodule //tb_aclk_alarm_regreg
