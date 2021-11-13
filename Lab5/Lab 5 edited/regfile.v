module regfile(data_in,writenum,write,readnum,clk,data_out);
	input [15:0] data_in;
	input [2:0] writenum, readnum;
	input write, clk;
	output [15:0] data_out;
	wire [7:0] t1, t2; //temp  1 and 2 (outputs from decoder)
	wire [7:0] tr; //temp register (temp going into register)
	wire [15:0] R0, R1, R2, R3, R4, R5, R6, R7;
	
	Dec #(3,8) dec1 (writenum, t1);
	Dec #(3,8) dec2 (readnum, t2);
	
	vDFFE #(16) REG0 (clk, tr[0], data_in, R0);
	vDFFE #(16) REG1 (clk, tr[1], data_in, R1);
	vDFFE #(16) REG2 (clk, tr[2], data_in, R2);
	vDFFE #(16) REG3 (clk, tr[3], data_in, R3);
	vDFFE #(16) REG4 (clk, tr[4], data_in, R4);
	vDFFE #(16) REG5 (clk, tr[5], data_in, R5);
	vDFFE #(16) REG6 (clk, tr[6], data_in, R6);
	vDFFE #(16) REG7 (clk, tr[7], data_in, R7);
	
	assign tr[7:0] = t1[7:0] & {8{write}};
			
	

	mux8 #(16) reg_mux (R7, R6, R5, R4, R3, R2, R1, R0, t2, data_out); //change name later
	
endmodule

module Dec(a,b);
	parameter n = 2;
	parameter m = 4;
	
	input [n-1:0] a;
	output [m-1:0] b;
	
	wire [m-1:0] b = 1 << a;
endmodule

module mux8(a7, a6, a5, a4, a3, a2,a1,a0, s, b);
	parameter k = 1;
	input [k-1:0] a0, a1, a2, a3, a4, a5, a6, a7;
	input [7:0] s;
	output [k-1:0] b;
	wire [k-1:0] b = ({k{s[0]}} & a0) | ({k{s[1]}} & a1) | ({k{s[2]}} & a2) | ({k{s[3]}} & a3) | ({k{s[4]}} & a4) | ({k{s[5]}} & a5) | ({k{s[6]}} & a6) | ({k{s[7]}} & a7);
	
endmodule

module vDFFE(clk, en, in, out) ; //load-enabled register
  parameter n = 1;  // width
  input clk, en ;
  input  [n-1:0] in ;
  output [n-1:0] out ;
  reg    [n-1:0] out ;
  wire   [n-1:0] next_out ;

  assign next_out = en ? in : out;

  always @(posedge clk)
    out = next_out;  
endmodule

