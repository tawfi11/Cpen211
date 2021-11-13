module cpu_tb;
reg clk,reset,s,load;
reg [15:0] in;
wire N,V,Z,w;
wire [15:0] out;
reg err;

cpu DUT(clk,reset,s,load,in,out,N,V,Z,w);

	//define my_checker task
	task my_checker;    
		//checker inputs
		input [15:0] expected_out; //the expected output of CPU
		input [2:0] expected_Z; //the expected status of CPU
	begin
		//test dut output
		if( cpu_tb.DUT.out !== expected_out ) begin
			$display("ERROR ** output is %b, expected %b", cpu_tb.DUT.out, expected_out  );
			err = 1'b1;
		end
		//test dut Status output
		if( cpu_tb.DUT.Z !== expected_Z ) begin
			$display("ERROR ** status is %b, expected %b", cpu_tb.DUT.Z, expected_Z );
			err = 1'b1;
		end
	end
	endtask


  initial begin
    clk = 0; #5;
    forever begin
      clk = 1; #5;
      clk = 0; #5;
    end
  end

initial begin
	//Add
	reset = 0;
	in = 16'b101_00_000_100_00_001;
	load = 1;
	#40;
	
	//Moving the number 1 to register 0 (R0)
	in = 16'b110_10_000_00000001;
	load = 1;
	#10;
	load = 0;
	s = 1;
	#10;
	s = 0;
	#40;
	
	//Moving number -7 to register 1 (R1)
	in = 16'b110_10_001_11111001;
	load = 1;
	#10;
	load = 0;
	s = 1;
	#10;
	s = 0;
	#40;

	//Moving the number 5 to register 2 (R2)
	in = 16'b110_10_010_00000101;
	load = 1;
	#10;
	load = 0;
	s = 1;
	#10;
	s = 0;
	#40;
	
	//Adding both R0 and R1 (Should be -6) and storing it in R3
	in = 16'b101_00_000_011_00_001;
	load = 1;
	#10;
	load = 0;
	s = 1;
	#10;
	s = 0;
	#40;

	//Adding both R0 and R2 (Should be 6) and storing it in R4
	in = 16'b101_00_000_100_00_010;
	load = 1;
	#10;
	load = 0;
	s = 1;
	#10;
	s = 0;
	#40;

	//Adding both R1 (-7) and R2 (10) (Should be 3) and storing it in R5 use shifter
	in = 16'b101_00_001_101_01_010; //shifted left 1 bit 101 (5) becomes 1010 (10)
	load = 1;
	#10;
	load = 0;
	s = 1;
	#10;
	s = 0;
	#40;
	
	//Moving number (3 becomes 1 after shifting) (R5) to register R1(-7) (with right shifting)
	in = 16'b110_00_000_001_10_101;
	load = 1;
	#10;
	load = 0;
	s = 1;
	#10;
	s = 0;
	#40;

	//Moving number 3 (R5) to register R0(1) (without shifting)
	in = 16'b110_00_000_000_00_101;
	load = 1;
	#10;
	load = 0;
	s = 1;
	#10;
	s = 0;
	#40;

	//Moving number -6 (R3) to register R6(empty) (without shifting)
	in = 16'b110_00_000_110_00_011;
	load = 1;
	#10;
	load = 0;
	s = 1;
	#10;
	s = 0;
	#40;
	
	//At this point R0 (3), R1 (1), R2 (5), R3 (-6), R4 (6), R5 (3), R6 (-6), R7()

	//Anding registers R0 (3) and R1 (1) into R7 (1)
	in = 16'b101_10_001_111_00_000;
	load = 1;
	#10;
	load = 0;
	s = 1;
	#10;
	s = 0;
	#40;

	//At this point R0 (3), R1 (1), R2 (5), R3 (-6), R4 (6), R5 (3), R6 (-6), R7(1)

	//Anding registers R3 (-6) and R4 (6) into R6 (4) with shift to the left
	in = 16'b101_10_100_110_01_011;
	load = 1;
	#10;
	load = 0;
	s = 1;
	#10;
	s = 0;
	#40;

	//At this point R0 (3), R1 (1), R2 (5), R3 (-6), R4 (6), R5 (3), R6 (4), R7(1)

	//Anding registers R6 (4) and R7 (1) into R6 (4)
	in = 16'b101_10_110_110_00_111;
	load = 1;
	#10;
	load = 0;
	s = 1;
	#10;
	s = 0;
	#40;
	
	//At this point R0 (3), R1 (1), R2 (5), R3 (-6), R4 (6), R5 (3), R6 (0), R7(1)
	
	//test zero variable
	in = 16'b101_01_000_000_00_101;
	load = 1;
	#10;
	load = 0;
	s = 1;
	#10;
	s = 0;
	#40;

	//test negative variable
	in = 16'b101_01_011_000_00_100;
	load = 1;
	#10;
	load = 0;
	s = 1;
	#10;
	s = 0;
	#40;
	
	

	//test overflow
	in = 16'b101_01_000_000_00_001;
	load = 1;
	#10;
	load = 0;
	s = 1;
	#10;
	s = 0;
	#40;
	
	//test negative variable
	in = 16'b101_11_000_111_00_110;
	load = 1;
	#10;
	load = 0;
	s = 1;
	#10;
	s = 0;
	#40;

	//test negative variable
	in = 16'b101_11_000_110_00_101;
	load = 1;
	#10;
	load = 0;
	s = 1;
	#10;
	s = 0;
	#40;

	//test negative variable
	in = 16'b101_11_000_100_00_011;
	load = 1;
	#10;
	load = 0;
	s = 1;
	#10;
	s = 0;
	#40;

$stop;
end
endmodule
