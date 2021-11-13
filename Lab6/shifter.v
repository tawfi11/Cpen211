module shifter(in,shift,sout);
	input [15:0] in;
	input [1:0] shift;
	output reg [15:0] sout;
	
	wire[15:0] shift_l;
	wire[15:0] shift_r0;
	wire[15:0] shift_r1;
	
	assign shift_l = in << 1;
	assign shift_r0 = in >> 1;
	assign shift_r0[15] = 0;
	assign shift_r1 = {in[15], in[15:1]};
	
	
	always @(*) begin
		case (shift) 
			2'b00: sout = in;
			2'b01: sout = shift_l;
			2'b10: sout = shift_r0;
			2'b11: sout = shift_r1;
		endcase
	end
	
endmodule
