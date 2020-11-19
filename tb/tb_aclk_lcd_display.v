module tb_aclk_lcd_display ();
  reg [3:0] alarm_time_ms_hr,
              alarm_time_ls_hr,
              alarm_time_ms_min,
              alarm_time_ls_min,
              current_time_ms_hr,
              current_time_ls_hr,
              current_time_ms_min,
              current_time_ls_min,
              key_ms_hr,
              key_ls_hr,
              key_ms_min,
              key_ls_min;

  reg show_a,show_current_time;

  wire [7:0]  display_ls_hr,
              display_ms_hr,
              display_ls_min,
              display_ms_min;

  wire sound_a;

  aclk_lcd_display DUT(alarm_time_ms_hr,
                        alarm_time_ls_hr,
                        alarm_time_ms_min,
                        alarm_time_ls_min,
                        current_time_ms_hr,
                        current_time_ls_hr,
                        current_time_ms_min,
                        current_time_ls_min,
                        key_ms_hr,
                        key_ls_hr,
                        key_ms_min,
                        key_ls_min,
                        show_a,
                        show_current_time,
                        display_ms_hr,
                        display_ls_hr,
                        display_ms_min,
                        display_ls_min,
                        sound_a  );
  task initialize();
    begin
      show_a=0;
      show_current_time=1;
      #2;
    end
  endtask

  task enable_alarm_current_time(input en_a,input current_time);
    begin
      show_a=en_a;
      show_current_time=current_time;
      #2;
    end
  endtask

  task stimulus_alarm(input [3:0] alarm_ms_hr,
                      input [3:0] alarm_ls_hr,
                      input [3:0] alarm_ms_min,
                      input [3:0] alarm_ls_min);
    begin
      enable_alarm_current_time(1'b1,1'b0);
      alarm_time_ms_hr = alarm_ms_hr;
      alarm_time_ls_hr = alarm_ls_hr;
      alarm_time_ms_min = alarm_ms_min;
      alarm_time_ls_min = alarm_ls_min;
      #2;
    end
  endtask

  task stimulus_current_time (input [3:0] current_ms_hr,
                              input [3:0] current_ls_hr,
                              input [3:0] current_ms_min,
                              input [3:0] current_ls_min);
    begin
      enable_alarm_current_time(1'b0,1'b1);
      current_time_ms_hr = current_ms_hr;
      current_time_ls_hr = current_ls_hr;
      current_time_ms_min = current_ms_min;
      current_time_ls_min = current_ls_min;
      #2;
    end
  endtask

  task stimulus_key_time (input [3:0]keyms_hr,
                          input [3:0]keyls_hr,
                          input [3:0]keyms_min,
                          input [3:0]keyls_min);
    begin
      key_ms_hr = keyms_hr;
      key_ls_hr = keyls_hr;
      key_ms_min = keyms_min;
      key_ls_min = keyls_min;
      #2;
    end
  endtask

  initial begin
    initialize;
    stimulus_current_time(4'd0,4'd9,4'd4,4'd5);
    stimulus_key_time(4'd1,4'd0,4'd3,4'd0);
    stimulus_alarm(4'd0,4'd9,4'd4,4'd5);
    stimulus_current_time(4'd0,4'd9,4'd4,4'd5);
    enable_alarm_current_time(1'b0,1'b1);
    stimulus_current_time(4'd1,4'd9,4'd4,4'd5);
    enable_alarm_current_time(1'b0,1'b1);
    stimulus_current_time(4'd1,4'd5,4'd0,4'd0);
    stimulus_alarm(4'd1,4'd5,4'd0,4'd0);
    #5;
    enable_alarm_current_time(1'b0,1'b1);
    #100 $finish;
  end

  endmodule //tb_aclk_lcd_display
