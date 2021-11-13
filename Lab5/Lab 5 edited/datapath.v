module datapath(clk, readnum, vsel, loada, loadb, shift, asel, bsel, ALUop, loadc, loads, writenum, write, datapath_in, Z_out, datapath_out);
	input clk; 
	input [2:0] readnum; 
	input vsel; 
	input loada;
	input loadb; 
	input [1:0]shift; 
	input asel, bsel; 
	input [1:0] ALUop; 
	input loadc, loads; 
	input [2:0] writenum; 
	input write; 
	input [15:0] datapath_in;
	input Z_out;
	output [15:0] datapath_out;
	
	
	wire [15:0] data_in;
	wire [15:0] loada_out, loadb_out;
	wire [15:0] sout;
	wire [15:0] Ain, Bin;
	wire Zin;
	wire [15:0] ALUout;
	wire [15:0] data_out;
	
	mux2 #(16) vmux (datapath_in, datapath_out, vsel, data_in);
	
	regfile REGFILE (data_in,writenum,write,readnum,clk,data_out);
	
	vDFFE #(16) Aff (clk, loada, data_out, loada_out);
	vDFFE #(16) Bff (clk, loadb, data_out, loadb_out);
	
	shifter move (loadb_out, shift, sout);
	
	mux2 #(16) amux (16'b0, loada_out, asel, Ain);
	mux2 #(16) bmux ({11'b0, datapath_in [4:0]}, sout, bsel, Bin);
	
	ALU arith (Ain, Bin, ALUop, ALUout, Zin);
	
	vDFFE #(16) Cff (clk, loadc, ALUout, datapath_out);
	vDFFE #(1) stat (clk, loads, Zin, Z_out);

endmodule 

module mux2(a1, a0, s, b);
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
