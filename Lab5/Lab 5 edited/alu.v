module ALU(Ain,Bin,ALUop,out,Z);
	input [15:0] Ain, Bin;
	input [1:0] ALUop;
	output reg [15:0] out;
	output Z;
	wire [15:0] added;
	wire [15:0] subtracted;
	wire [15:0] anded;
	wire [15:0] notb;
	
	assign added = Ain + Bin;
	assign subtracted = Ain - Bin;
	assign anded = Ain & Bin;
	assign notb = ~Bin;
	
	always @(*) begin
		case(ALUop)
			2'b00: out = added;
			2'b01: out = subtracted;
			2'b10: out = anded;
			2'b11: out = notb;
		endcase 
	end
	
	assign Z = ~(|out);
endmodule
