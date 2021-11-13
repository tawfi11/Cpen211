module q1_tb();
    reg clk, reset;
    wire done;
 
    top_module DUT(clk,reset,done);
  
    initial forever begin
      clk = 0; #5;
      clk = 1; #5;
    end

    initial begin
        reset = 1;
        #10;
        reset = 0;
        #100;
        $stop;
    end
endmodule