module ALU(Ain,Bin,ALUop,out,Z);
	input [15:0] Ain, Bin;
	input [1:0] ALUop;
	output reg [15:0] out;
	output [2:0]Z;
	wire [15:0] added;
	wire [15:0] subtracted;
	wire [15:0] anded;
	wire [15:0] notb;
	reg neg;
	wire ovfa,ovfs;
	reg ovf;
	
	AddSub #(16) adder(Ain,Bin,1'b0,added,ovfa) ;
	AddSub #(16) suber(Ain,Bin,1'b1,subtracted,ovfs) ;
	assign anded = Ain & Bin;
	assign notb = ~Bin;
	
	always @(*) begin
		case(ALUop)
			2'b00: {out,ovf} = {added,ovfa};
			2'b01: {out,ovf} = {subtracted,ovfs};
			2'b10: {out,ovf} = {anded,1'b0};
			2'b11: {out,ovf} = {notb,1'b0};
		endcase 
			
		
	end
	
	assign Z[0] = ~(|out);
	assign Z[1] = out[15];
	assign Z[2] = ovf;
	
		
			
endmodule

module Adder1(a,b,cin,cout,s) ;
  parameter n = 8 ;
  input [n-1:0] a, b ;
  input cin ;
  output [n-1:0] s ;
  output cout ;
  wire [n-1:0] s;
  wire cout ;

  assign {cout, s} = a + b + cin ;
endmodule 

module AddSub(a,b,sub,s,ovf) ;
  parameter n = 8 ;
  input [n-1:0] a, b ;
  input sub ;           // subtract if sub=1, otherwise add
  output [n-1:0] s ;
  output ovf ;          // 1 if overflow
  wire c1, c2 ;         // carry out of last two bits
  wire ovf = c1 ^ c2 ;  // overflow if signs don't match

  // add non sign bits
  Adder1 #(n-1) ai(a[n-2:0],b[n-2:0]^{n-1{sub}},sub,c1,s[n-2:0]) ;
  // add sign bits
  Adder1 #(1)   as(a[n-1],b[n-1]^sub,c1,c2,s[n-1]) ;
endmodule




