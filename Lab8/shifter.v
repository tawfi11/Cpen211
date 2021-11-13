module shifter(in,shift,sout);
	input [15:0] in;
	input [1:0] shift;
	output [15:0] sout;
	// fill out the rest
	
	reg [15:0] sout;	//sout is used in always block
	
	always @(*) begin
		case (shift)
			2'b00 : sout = in;			//case 1 : output in
			2'b01 : sout = in << 1;		//case 2 : shift left by 1 bit
			2'b10 : sout = in >> 1;		//case 3 : shift right by 1 bit
			2'b11 : sout = {in[15],in[15:1]};	//case 4 : shift right by 1 bit, replace MSB with in[15]
			default : sout = 16'bxxxxxxxxxxxxxxxx;		//default : weirdness
		endcase
	end
	
endmodule
