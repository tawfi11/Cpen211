module datapath(clk, readnum, vsel, loada, loadb, shift, asel, bsel, ALUop, loadc, loads, writenum, write, Z_out, datapath_out, mdata, sximm8, imPC, sximm5);
	input clk; 
	input [2:0] readnum; 
	input [3:0] vsel; 
	input loada;
	input loadb; 
	input [1:0]shift; 
	input asel, bsel; 
	input [1:0] ALUop; 
	input loadc, loads; 
	input [2:0] writenum; 
	input write; 
//	input [15:0] datapath_in;
	input [2:0] Z_out;
	output [15:0] datapath_out;
	
	//
	
	input [15:0] mdata;
	input [15:0] sximm8;
	input [7:0] imPC;
	input [15:0] sximm5;
	
	
	wire [15:0] data_in;
	wire [15:0] loada_out, loadb_out;
	wire [15:0] sout;
	wire [15:0] Ain, Bin;
	wire [2:0] Zin;
	wire [15:0] ALUout;
	wire [15:0] data_out;
	
	mux4h #(16) vmux (mdata, sximm8, {8'b0,imPC} ,datapath_out, vsel, data_in);
	
	regfile REGFILE (data_in,writenum,write,readnum,clk,data_out);
	
	vDFFE #(16) Aff (clk, loada, data_out, loada_out);
	vDFFE #(16) Bff (clk, loadb, data_out, loadb_out);
	
	shifter move (loadb_out, shift, sout);
	
	mux2b #(16) amux (16'b0, loada_out, asel, Ain);
	mux2b #(16) bmux (sximm5, sout, bsel, Bin);
	
	ALU arith (Ain, Bin, ALUop, ALUout, Zin);
	
	vDFFE #(16) Cff (clk, loadc, ALUout, datapath_out);
	vDFFE #(3) stat (clk, loads, Zin, Z_out);

endmodule 

module mux2b(a1, a0, s, b);
	parameter k = 16;
	input [k-1:0] a0, a1;
	input s;
	output reg [k-1:0] b;
	
	always @* begin
	if(s)
	b = a1;
	else
	b = a0;
	end
	
endmodule


module mux4h(a3, a2,a1,a0, s, b);
	parameter k = 1;
	input [k-1:0] a0, a1, a2, a3;
	input [3:0] s;
	output [k-1:0] b;
	wire [k-1:0] b = ({k{s[0]}} & a0) | ({k{s[1]}} & a1) | ({k{s[2]}} & a2) | ({k{s[3]}} & a3);
	
endmodule 