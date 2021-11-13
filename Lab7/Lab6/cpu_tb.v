//This is the final one!


module cpu_tb();
  reg clk, reset, s, load;
  reg [15:0] in;
  wire [15:0] out;
  wire N, V, Z, w;  

  cpu DUT (clk,reset,s,load,in,out,N,V,Z,w);

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
  reg err;

  initial begin
  //Initial values
    load = 1;
	 err = 0;
    $display("Storing 39 into R5");
    in = 16'b110_10_101_00100111; //stores 39 in R5
    reset = 1;
    s = 1;
	 
	 #20;
	 
	 reset = 0;

    #100;
    $display("Storing 39 into R7 from R5");
    in = 16'b110_00_000_111_00_101; //copies 39 from R5 into R7
    
    #100;

    $display("Taking 39 from R5 and 39 from R7 and storing the sum 78 into R4");
    in = 16'b101_00_101_100_01_111; //Add 39 in R5 with 39 in R7 and store the sum 78 in R4
		
    #100;

    $display("Taking 39 from R5 and 39 from R7");
    in = 16'b101_01_101_000_00_111; //Subtract R5 and R7, should equal 0
	
    #100;
	if(Z != 1) begin
		$display("Zero does not work");
		err = 1;
		$stop;
	end
    $display("Taking 39 from R5 and subtracting 78 from R4");
    in = 16'b101_01_101_000_00_100; //Subtract R5 and R4, should get a negative number

   #100;
	if(N != 1) begin
		$display("Negative does not work");
		err = 1;
		$stop;
	end
   $display("Taking 78 from R4 and subtracting 39 from R7");
   in = 16'b101_01_100_000_00_111;
	
   #100;
	if(N == 1 || Z == 1 || V == 1) begin
		$display("Z = %b, N = %b, V = %b", Z, N, V);
		err = 1;
		$stop;
	end
  $display("AND R5 and R7 and store in R6");
  in = 16'b101_10_101_110_00_111;//AND R5 and R7, should get the same number

  #100
  
   //MOV R4, R5 <NO SHIFT>
    $display("Moving R5 to R4 without a shift");
    in = 16'b110_00_000_100_00_101;
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    #100;
    if (cpu_tb.DUT.DP.REGFILE.R4 != 16'd39) begin
      err = 1;
      $display("FAILED: MOV R4, R5 <NO SHIFT>");
      $stop;
    end

    //MOV R4, R5 <LS>
    $display("Moving R5 to R4 with a left shift");
    in = 16'b110_00_000_100_01_101;
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    #100;
    if (cpu_tb.DUT.DP.REGFILE.R4 != 16'b0000000001001110) begin
      err = 1;
      $display("FAILED: MOV R4, R5 <LS>");
      $stop;
    end

    //MOV R4, R5 <RS>
    $display("Moving R5 to R4 with a right shift");
    in = 16'b110_00_000_100_10_101;
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    #100;
    if (cpu_tb.DUT.DP.REGFILE.R4 != 16'b000000000010011) begin
      err = 1;
      $display("FAILED: MOV R4, R5 <RS>");
      $stop;
    end

    //ADD R3,R5, R4 <NO SHIFT>
    $display("Adding R4 and R5 with no shift and storing in R3");
    in = 16'b101_00_101_011_00_100;
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    #100;
    if (cpu_tb.DUT.DP.REGFILE.R3 != 16'b000000000010011 + 16'b0000000000100111) begin
      err = 1;
      $display("FAILED: ADD R3, R5, R4 <NO SHIFT>");
      $stop;
    end

    //ADD R3,R5, R4 <LS>
    $display("Adding R4 and R5 with left shift and storing in R3");
    in = 16'b101_00_101_011_01_100;
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    #100;
    if (cpu_tb.DUT.DP.REGFILE.R3 != 16'b000000000100110 + 16'b0000000000100111) begin
      err = 1;
      $display("FAILED: ADD R3, R5, R4 <LS>");
      $stop;
    end

    //ADD R3,R5, R4 <RS>
    $display("Adding R4 and R5 with right shift and storing in R3");
    in = 16'b101_00_101_011_10_100;
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    #100;
    if (cpu_tb.DUT.DP.REGFILE.R3 != 16'b000000000001001 + 16'b0000000000100111) begin
      err = 1;
      $display("FAILED: ADD R3, R5, R4 <RS>");
      $stop;
    end
	 
	 //AND R5, R7, store into R2
    $display("AND R5 and R7 and store into R2");
    in = 16'b101_10_101_010_00_111;
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10;
    s = 0;
	 #100;
    if (cpu_tb.DUT.DP.REGFILE.R2 != cpu_tb.DUT.DP.REGFILE.R5 & cpu_tb.DUT.DP.REGFILE.R7) begin
      err = 1;
      $display("FAILED: AND R0,R1");
      $stop;
    end

    

    //NOT R5 and store in R3
    $display("NOT R5 and store in R3");
    in = 16'b101_11_000_011_00_101;
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10;
    s = 0;
	 #100;
    if (cpu_tb.DUT.DP.REGFILE.R3 != ~cpu_tb.DUT.DP.REGFILE.R5) begin
      err = 1;
      $display("FAILED: NOT R3, R5");
      $stop;
    end

    //NOT R7 and store in R3
    $display("NOT R7 and store in R3");
    in = 16'b101_11_000_011_00_111;
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10;
    s = 0;
	 #100;
    if (cpu_tb.DUT.DP.REGFILE.R3 != ~cpu_tb.DUT.DP.REGFILE.R7) begin
      err = 1;
      $display("FAILED: NOT R3, R0");
      $stop;
    end

    //NOT R2 and store in R3
    $display("NOT R2 and store in R3");
    in = 16'b101_11_000_011_00_010;
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10;
    s = 0;
	 #100;
    if (cpu_tb.DUT.DP.REGFILE.R3 != ~cpu_tb.DUT.DP.REGFILE.R2) begin
      err = 1;
      $display("FAILED: NOT R3, R0");
      $stop;
    end

    #10;

	if(err == 0) begin
    $display("All tests passed!");
	 end else begin
		$display("you fucked up somewhere");
	end

    $stop;
  end

endmodule