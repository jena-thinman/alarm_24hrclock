module tb_aclk_timegen();
  reg clock,
      reset,
      reset_count,
      fastwatch;
  wire one_minute,one_second;

  parameter CYCLE = 2;

  aclk_timegen DUT(clock,reset,reset_count,
                  fastwatch,one_minute,one_second);

  always begin
  #(CYCLE/2);
  clock = 1'b1;
  #(CYCLE/2);
  clock = ~clock;
  end

  task rst();
    begin
      reset = 1'b1;
      #CYCLE;
      reset = 1'b0;
    end
  endtask

  task initialize();
    begin
      fastwatch=1'b1;
      rst;
      reset_count=1'b1;
      reset_count=1'b0;
    end
  endtask

  initial begin
    initialize;
    #20 rst;
    #700 $finish;
  end

  initial begin
    $monitor($time,"reset-%b, one minute flg-%b, one second flg-%b, counter-%d",
              reset,one_minute,one_second,DUT.count);
  end

endmodule //aclk_timegen
