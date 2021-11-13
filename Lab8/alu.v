module ALU(Ain,Bin,ALUop,out,Z);
	input [15:0] Ain, Bin;
	input [1:0] ALUop;
	output [15:0] out;
	output [2:0] Z;
	// fill out the rest
	
	//reg [15:0] Ain, Bin;
	//reg [1:0] ALUop;
	reg [15:0] out;
	reg [2:0] Z;
	wire [16:0]carry, Scarry;
	wire [15:0]XoredABCPlus,XoredABCMinus;
	
	xor3 abcXorMinus(Ain,Bin,Scarry[15:0],XoredABCMinus);	//xored abc used for subtraction (used subtract carry)
	xor3 abcXorPlus(Ain,Bin,carry[15:0],XoredABCPlus);  	//xored abc used for addition (used add carrry)
	
	//THE WEIRDNESS IN SUBTRACTION AND ADDITION WAS BECAUSE I DIDNT KNOW THAT VERILOG HAD "+" AND "-" OPERATORS.
	//I AM ACTUALLY KINDA MAD THAT I SPENT SO MUCH TIME DOING THIS, BUT AT LEAST YOU CAN REST EASY KNOWING THAT
	//I DIDNT COPY ANYONE BECAUSE NO ONE IN THEIR RIGHT MIND WOULD EVER ACTUALLY SPEND 4 HOURS DOING BOOLEAN
	//ALGEBRA WHEN THEY COULD HAVE JUST USED THE "+" OR "-" OPERATORS.
	//IT DOES WORK THOUGH... AND THE LAB DIDNT SAY WE COULDN'T BE DUMB IN OUR IMPLEMENTATION.
	
	assign carry = {(~(XoredABCPlus[15:0]))&(Ain[15:0]|Bin[15:0]|carry[15:0]),1'b0};	//declare carrying places for addition
	assign Scarry = {(~ Ain[15:0] & ( Bin[15:0]| Scarry[15:0] ))|( Bin[15:0] & Scarry[15:0] ),1'b0};	//declare carrying places for subtraction
	always @(*) begin
		case (ALUop)
			2'b00 :  begin
				out = (XoredABCPlus | (Ain & Bin & carry[15:0]));	//implement adding each place, (and carry bits)
				Z[1] = carry[15]^carry[16];
			end
			
			2'b01 : begin
				out = (XoredABCMinus | (Ain & Bin & Scarry[15:0]));	//implement subtracting each place and carry bits
				Z[1] = Scarry[15]^Scarry[16];
			end
			
			2'b10 : begin
				out = Ain & Bin;	//implements the and function
				Z[1] = 0;
			end
			
			2'b11 : begin
				out = ~Bin;	//implements the not function
				Z[1] = 0;
			end
			
			default : begin
			out = (16'bxxxxxxxxxxxxxxxx);
			Z[1] = 1'bx;
			end
		endcase
		
		if(out == 0) Z[0] = 1;
		else Z[0] = 0;
		
		if(out[15] == 1) Z[2] = 1;
		else Z[2] = 0;

		
	end
endmodule

//THIS MODULE WOULD NOT HAVE BEEN USED IF I WAS SMART AND USED THE "+" AND "-" OPERATORS.
//INSTEAD, I, BEING DUMB, MADE THIS MODULE TO AID IN THE CALCULATIONS OF MY ADDING AND SUBTRACTING.

//outputs 1 IFF one of a, b, c is 1
module xor3(a,b,c,out);
	parameter n = 16;
	input[n-1:0] a,b,c;
	output[n-1:0] out;
	
	assign out = {(a & ~b & ~c) | (~a & b & ~c) | (~a & ~b & c)};
endmodule
