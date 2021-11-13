module shifter_tb();
	reg [15:0] in;
	reg [1:0] shift;
	wire [15:0] sout;
	reg err;
	
	shifter DUT (.in(in),.shift(shift),.sout(sout));
	
	initial begin
		in = 16'b1111000011001111;
		shift = 2'b00;
		err = 1'b0;
		
		#5;
		
		if(sout != 16'b1111000011001111) begin
			err= 1'b1;
			$display("INCORRECT expected value is %b, your value is %b", 16'b1111000011001111, sout);
		end
		
		#5;
		
		shift = 2'b01;
		
		#5;
		
		if(sout != 16'b1110000110011110) begin
			err = 1'b1;
			$display("INCORRECT expected value is %b, your value is %b", 16'b1110000110011110, sout);
		end
		
		#5;
		
		shift = 2'b10;
		
		#5;
		
		if(sout != 16'b0111100001100111) begin
			err= 1'b1;
			$display("INCORRECT expected value is %b, your value is %b", 16'b0111100001100111, sout);
		end
		
		#5;
		
		shift = 2'b11;
		
		#5;
		
		if(sout != 16'b1111100001100111) begin
			err= 1'b1;
			$display("INCORRECT expected value is %b, your value is %b", 16'b1111100001100111, sout);
		end
		
		#5;
		
		if(err == 1'b1) begin
			$display("ERROR, TESTS FAILED");
		end else begin
			$display("CONGRATS, TESTS PASSED FLAWLESSLY");
		end
		
		$stop;
	end
endmodule
