module tb_aclk_lcd_driver ();
  reg [3:0] key,alarm_time,current_time;
  reg show_alarm,show_new_time;
  reg [3:0] display_value;

  wire [7:0] display_time;
  wire sound_alarm;

  aclk_lcd_driver DUT(alarm_time,
                     current_time,
                     show_alarm,
                     show_new_time,
                     key,display_time,
                     sound_alarm);

  task initialize();
    begin
      key=4'd0;
      alarm_time=4'd0;
      current_time=4'd0;
      show_alarm=1'b0;
      show_new_time=1'b0;
    end
  endtask

  task stimulus(input new_time,input alarm_Show,
                input [3:0] key_in, input [3:0] alarm_in,
                input [3:0] curr_time);
    begin
      show_new_time=new_time;
      show_alarm=alarm_Show;
      key=key_in;
      alarm_time=alarm_in;
      current_time=curr_time;
      #2;
    end
  endtask

initial begin
  initialize;
  #5;
  stimulus(0,0,4'd0,4'd0,4'd8);
  stimulus(0,1,4'd0,4'd4,4'd8);
  stimulus(0,1,4'd0,4'd8,4'd8);
  stimulus(0,0,4'd0,4'd0,4'd8);
  stimulus(1,0,4'd5,4'd0,4'd8);
  stimulus(1,0,4'd6,4'd0,4'd8);
  stimulus(0,0,4'd0,4'd0,4'd8);
  stimulus(0,0,4'd0,4'd0,4'd9);
  stimulus(0,0,4'd0,4'd0,4'd2);
  #100 $finish;
end

initial begin
  $monitor($time,"new_time enable-%b, alarm_en-%b, show_alarm-%b, new_time-%d,
          current_time-%d",show_new_time,show_alarm,alarm_time,
          key,current_time);
end

endmodule //tb_aclk_lcd_drive
