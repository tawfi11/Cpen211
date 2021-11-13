module PC_tb ();
    reg clk, load_pc, reset_pc, err;
    wire [8:0] counter_out;
    
    Program_Counter dut (clk,load_pc,reset_pc,counter_out);
    
    initial begin
    clk = 0;
    #5;
    forever begin
      clk = 1;
      #5;
      clk = 0;
      #5;
    end
  end
  
  initial begin 
        load_pc = 1;
        reset_pc = 1;
        err = 0;
        
        #10;
        
        reset_pc = 0;
        
		  #100;
		  
		  reset_pc = 1;
		  
		  #20;
 
        $stop;
    end
endmodule


