module tb_aclk_keyreg ();
reg reset,clock,shift;
reg [3:0] key;
wire [3:0] key_buffer_ls_min,key_buffer_ms_min,key_buffer_ls_hr
                  ,key_buffer_ms_hr;

parameter CYCLE = 2;

aclk_keyreg DUT (reset,
              clock,
              shift,
              key,
              key_buffer_ls_min,
              key_buffer_ms_min,
              key_buffer_ls_hr,
              key_buffer_ms_hr);

  always begin
    #(CYCLE/2);
    clock = 1'b1;
    #(CYCLE/2);
    clock = ~clock;
  end

  task initialize();
    begin
      reset=1;
      shift=0;
      key=4'd0;
      #2;
      reset=0;
    end
  endtask

  task shift_new_key(input [3:0] ls_min);
    begin
      shift = 1'b1;
      key = ls_min;
      #2 shift=1'b0;
    end
  endtask

  initial begin
    initialize;
    shift_new_key(4'd1);
    #20 shift_new_key(4'd6);
    #10 shift_new_key(4'd2);
    shift_new_key(4'd1);
    #200 $finish;
  end

  initial begin
    $monitor($time,"reset-%b, shift-%b, time-%d%d:%d%d",
              reset,shift,key_buffer_ms_hr,key_buffer_ls_hr,
              key_buffer_ms_min,key_buffer_ls_min);
  end
endmodule //tb_aclk_keyreg
