module shifter_tb;
	reg [15:0] in;
	reg [1:0] shift;
	reg err;
	
	wire [15:0] sout;
	
	shifter DUT (in, shift, sout);
	
	task my_checker;    
		//checker inputs
		input [15:0] expected_sout; //the expected output of shifter
	begin
		//test dut output
		if( shifter_tb.DUT.sout !== expected_sout ) begin
			$display("ERROR ** output is %b, expected %b", shifter_tb.DUT.sout, expected_sout  );
			err = 1'b1;
		end

	end
	endtask

	initial begin
	err = 0;
	
	//working with 1 in bit 8 of in;
	$display("binary: 0000000100000000");
	
	//no shift
	$display("	no shift");
	in = {16'b0000000100000000}; shift = 0; #5;
	my_checker(16'b0000000100000000);
	
	//shift left
	$display("	shift left");
	shift = 1; #5;
	my_checker(16'b0000001000000000);
	
	//shift right
	$display("	shift right");
	shift = 2; #5;
	my_checker(16'b0000000010000000);
	
	//shift right copy bit15
	$display("	shift right, copy bit 15");
	shift = 3; #5;
	my_checker(16'b0000000010000000);
	
	if(~err) $display("PASSED");
	else $display("FAILED");
	end


endmodule