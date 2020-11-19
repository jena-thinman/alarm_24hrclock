module tb_aclk_counter ();
reg clk,reset,one_minute,load_new_c;
reg [3:0] new_current_time_ms_hr,
          new_current_time_ms_min,
          new_current_time_ls_hr,
          new_current_time_ls_min;

wire [3:0] current_ms_hr,
					 current_ls_hr,
					 current_ms_min,
					 current_ls_min;

parameter CYCLE = 2;
integer i;

aclk_counter DUT(clk,
	              reset,
          		  one_minute,
          		  load_new_c,
          		  new_current_time_ms_hr,
          		  new_current_time_ms_min,
          		  new_current_time_ls_hr,
          		  new_current_time_ls_min,
                current_ms_hr,
    					  current_ls_hr,
    					  current_ms_min,
    					  current_ls_min);

always begin
  #(CYCLE/2);
  clk = 1'b1;
  #(CYCLE/2);
  clk = ~clk;
end

task initialize();
  begin
    reset=1;
    load_new_c=0;
    one_minute=0;
    #2;
    reset=0;
  end
endtask

task rst();
  begin
    reset=1'b1;
    #2;
    reset=1'b0;
  end
endtask

task one_minute_timeout();
  begin
    one_minute=1'b1;
    #2 one_minute=1'b0;
  end
endtask

task load_new_time(input [3:0] ms_hr,
                   input [3:0] ls_hr,
                   input [3:0] ms_min,
                   input [3:0] ls_min);
  begin
    load_new_c=1'b1;
    new_current_time_ms_hr = ms_hr;
    new_current_time_ls_hr = ls_hr;
    new_current_time_ms_min = ms_min;
    new_current_time_ls_min = ls_min;
    #2 load_new_c=1'b0;
  end
endtask

initial begin
  initialize;
  load_new_time(4'd1,4'd2,4'd5,4'd9);
  one_minute_timeout;
  one_minute_timeout;
  load_new_time(4'd0,4'd9,4'd5,4'd9);
  one_minute_timeout;
  one_minute_timeout;
  load_new_time(4'd0,4'd0,4'd5,4'd9);
  one_minute_timeout;
  one_minute_timeout;
  #5 rst;
  load_new_time(4'd0,4'd0,4'd0,4'd9);

  #100 $finish;
end

initial begin
  $monitor($time,"reset-%b, load_new_time-%b, current_time-%d%d:%d%d",reset,
                          load_new_c,current_ms_hr,
            						  current_ls_hr,
            						  current_ms_min,
            						  current_ls_min);
end

endmodule //tb_aclk_counter
