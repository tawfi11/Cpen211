module regfile(data_in,writenum,write,readnum,clk,data_out);
input [15:0] data_in;
input [2:0] writenum, readnum;
input write, clk;
output [15:0] data_out;

wire [7:0] ewrite = {8{write}};
wire [7:0] writehotcode;
wire [7:0] readhotcode;
wire [7:0] wresult = ewrite & writehotcode;
//wire [7:0] rresult = ewrite & writehotcode;
wire [15:0] R0,R1,R2,R3,R4,R5,R6,R7;





Dec #(3,8) writen(.a(writenum),.b(writehotcode));
//Dec #(3,8) read(.num(readnum),.onehot(readhotcode));

vDFFE #(16) RR0 ( .clk(clk), .en(wresult[0]), .in(data_in), .out(R0) ); //instatiating register 0
vDFFE #(16) RR1 ( .clk(clk), .en(wresult[1]), .in(data_in), .out(R1) );	//instatiating register 1
vDFFE #(16) RR2 ( .clk(clk), .en(wresult[2]), .in(data_in), .out(R2) );	//instatiating register 2
vDFFE #(16) RR3 ( .clk(clk), .en(wresult[3]), .in(data_in), .out(R3) );	//instatiating register 3

vDFFE #(16) RR4 ( .clk(clk), .en(wresult[4]), .in(data_in), .out(R4) );	//instatiating register 4
vDFFE #(16) RR5 ( .clk(clk), .en(wresult[5]), .in(data_in), .out(R5) );	//instatiating register 5
vDFFE #(16) RR6 ( .clk(clk), .en(wresult[6]), .in(data_in), .out(R6) );	//instatiating register 6
vDFFE #(16) RR7 ( .clk(clk), .en(wresult[7]), .in(data_in), .out(R7) );	//instatiating register 7

registerMUX final (.R0(R0),.R1(R1),.R2(R2),.R3(R3),.R4(R4),.R5(R5),.R6(R6),.R7(R7),.readselect(readnum),.out(data_out)); //instantiating MUX for reading registers
//readnum
endmodule

//decoder module to decode binary input 'a' to onehot output 'b'
module Dec(a, b) ;
  parameter n=2 ;	//bus width of a
  parameter m=4 ;	//bus width of b

  input  [n-1:0] a ;
  output [m-1:0] b ;

  wire [m-1:0] b = 1'b1 << a ;	//move '1' but 'a' positions over in b
endmodule

//register modules for implementation in register (also used in datapath.)
module vDFFE(clk, en, in, out) ;
  parameter n = 1;  // width of register
  input clk, en ;
  input  [n-1:0] in ;
  output [n-1:0] out ;
  reg    [n-1:0] out ;
  wire   [n-1:0] next_out ;

  assign next_out = en ? in : out;	//next out = in if en, otherwise out.

  always @(posedge clk)
    out = next_out;  	//update out on clock
endmodule

//8 input mux for use in register
module registerMUX (R0,R1,R2,R3,R4,R5,R6,R7, readselect,out);
//input [2:0] readnum;
input [2:0] readselect;
input [15:0] R0,R1,R2,R3,R4,R5,R6,R7;
output reg [15:0] out;

always@(*)begin
	case(readselect)
	3'b000: out = R0;	//in = 0, out = R0
	3'b001: out = R1;	//in = 1, out = R1
	3'b010: out = R2;	//in = 2, out = R2
	3'b011: out = R3;	//in = 3, out = R3
	3'b100: out = R4;	//in = 4, out = R4
	3'b101: out = R5;	//in = 5, out = R5
	3'b110: out = R6;	//in = 6, out = R6
	3'b111:	out = R7;	//in = 7, out = R7
	default out = {16{1'bx}};	//default to weirdness
endcase
end
endmodule
