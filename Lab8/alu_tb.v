module ALU_tb;

	reg[15:0] A, B;
	reg[1:0] operation;
	reg err;
	
	wire[15:0] out;
	wire [2:0]Z;
	
	ALU DUT(A,B,operation,out,Z);
	
	//define my_checker task
	task my_checker;    
		//checker inputs
		input [15:0] expected_out; //the expected output of ALU
		input [2:0] expected_Z; //the expected Z of ALU
	begin
		//test dut output
		if( ALU_tb.DUT.out !== expected_out ) begin
			$display("ERROR ** output is %b, expected %b", ALU_tb.DUT.out, expected_out  );
			err = 1'b1;
		end
		//test dut Status output
		if( ALU_tb.DUT.Z !== expected_Z ) begin
			$display("ERROR ** status is %b, expected %b", ALU_tb.DUT.Z, expected_Z );
			err = 1'b1;
		end
	end
	endtask
	
	
	initial begin
		err = 0; 
		
		//check 1+1
		$display("1+1");
		A = 1; B = 1; operation = 2'b00; #5;
		my_checker(2,0); #5;
		
		//check 45+50
		$display("45+50");
		A = 45; B = 50; operation = 0; #5;
		my_checker(95,0); #5;
		
		//check 0+0
		$display("0+0");
		A = 0; B = 0; operation = 0; #5;
		my_checker(0,1);
		
		//check 1-1
		$display("1-1");
		A = 1; B = 1; operation = 1; #5;
		my_checker(0,1);
		
		//check 0 - 1
		$display("0-1");
		A = 0; B = 1; operation = 1; #5;
		my_checker(16'b1111111111111111,3'b100);
		
		//check 2-1
		$display("2-1");
		A = 2; B = 1; operation = 1; #5;
		my_checker(1,0);
		
		//check 1111000000000000 & 0000000000001111
		$display("1111000000000000 & 0000000000001111");
		A = 16'b1111000000000000; B = 16'b0000000000001111; operation = 2; #5;
		my_checker(0,1);
		
		//check 0000111100001111 & 0011110000111100
		$display("0000111100001111 & 0011110000111100");
		A = 16'b0000111100001111; B = 16'b0011110000111100; operation = 2; #5;
		my_checker(16'b0000110000001100,0);
		
		//check ~0000000000000000
		$display("~0000000000000000");
		A = 255; B = 0; operation = 3; #5;
		my_checker(16'b1111111111111111,3'b100);
		
		//check 1110001110001110
		$display("~1110001110001110");
		A = 342; B = 16'b1110001110001110; operation = 3; #5;
		my_checker(16'b0001110001110001,0);
		
		//check overflow
		$display("1111111111111111 + 1");
		A = {16'b0111111111111111}; B = 16'b0000000000000001; operation = 0; #5;
		my_checker(0,3'b110);
		
		
		
		
		if(~err) $display("PASSED");
		else $display("FAILED");
	end
endmodule
