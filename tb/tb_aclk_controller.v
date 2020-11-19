module tb_aclk_controller ();
reg clock,reset,one_second,time_button,alarm_button;
reg [3:0] key;

wire load_new_a,show_a,show_new_time,load_new_c,shift,reset_count;

parameter CYCLE = 2;

aclk_controller DUT(clock,
            reset,
            one_second,
            time_button,
            alarm_button,
            key,
            reset_count,
            load_new_a,
            show_a,
            show_new_time,
            load_new_c,
            shift);

  initial begin
    clock = 1'b0;
    forever #(CYCLE/2) clock = ~clock;
  end

  task initialize();
    begin
      reset = 1'b1;
      #5 reset = 1'b0;
      one_second = 1'b0;
      time_button = 1'b0;
      alarm_button = 1'b0;
      key = 10;
    end
  endtask

  initial begin
    initialize;
    @(posedge clock)
    key = 8;
    @(negedge clock)
    time_button = 1'b1;
    @(negedge clock)
    time_button = 1'b0;
    #20;
    @(negedge clock)
    key = 10;
    @(negedge clock)
    #2;
    @(negedge clock)
    time_button = 1'b1;
    time_button = 1'b0;
    @(posedge clock)
    key = 7;
    key = 8;
    key = 6;
    @(negedge clock);
    @(negedge clock);
    @(negedge clock);
    @(negedge clock);
    @(negedge clock);
    @(negedge clock);
    @(negedge clock);
    @(negedge clock);
    @(negedge clock);
    @(negedge clock);
    alarm_button = 1'b1;
    @(negedge clock)
    #2 alarm_button = 1'b0;
    @(negedge clock)
    #10 key = 2;
    @(negedge clock)
    alarm_button = 1'b1;
    @(negedge clock)
    #2 alarm_button = 1'b0;
    #100 $finish;
  end

  initial begin
  $monitor($time,"present_state-%d, next_state%d, load_alarm-%b, show_a-%b, load_new_c-%b,show_new_time-%d,count1-%d",
            DUT.pre_state,DUT.next_state,load_new_a,show_a,load_new_c,show_new_time,DUT.count1);
  end
endmodule //tb_aclk_controller
