module datapath(/*datapath_in, */mdata, sximm8, sximm5, PC, writenum, write, readnum, clk, asel, bsel, vsel, loadb, loada, loadc, loads, shift, ALUop, datapath_out, Z_out, N, V, Z);
	input clk, write, asel, bsel, loadc,loads,loada,loadb; //define one bit inputs
	input [2:0] writenum, readnum;	//define 3 bit inputs
	input [1:0] shift, ALUop, vsel;	//define 2 bit inputs
	input [15:0] mdata, sximm8, sximm5/* datapath_in*/;	//define 16 bit input
	input [7:0] PC;
	
	//declare intermediate wires
	wire[15:0] data_in, data_out, in, sout, Ain, Bin, out, A2MUX;
	wire [1:0] shift;
	
	wire[2:0] Z_internal; // Wire C is datapath_out
	
	//declare outputs
	output [15:0] datapath_out;
	output N, V, Z;
	output [2:0] Z_out;
	
	//assign mdata = {16{1'b0}};
	//assign PC = {8{1'b0}};
	
	Four_IN_Mux inMuxNew(.mdata(mdata), .sximm8(sximm8), .PC16({8'b0,PC}), .C(datapath_out), .vsel(vsel), .out(data_in));

	regfile REGFILE(data_in, writenum, write, readnum, clk, data_out);		//instantiate REGFILE
	
	ALU U2 (.Ain(Ain), .Bin(Bin), .ALUop(ALUop), .out(out), .Z(Z_internal));			//instantiate ALU U2
	
	vDFFE #(16) A (clk, loada, data_out, A2MUX);							//instantiate register A
	
	vDFFE #(16) B (clk, loadb, data_out, in);								//instantiate register B
	
	vDFFE #(16) C (clk, loadc, out, datapath_out);							//instantiate register C (final register)
	
	MUX muxA (16'b0, A2MUX, asel, Ain);										//instantiate muxA
	
	MUX muxB (sximm5, sout, bsel, Bin);		//sximm5 not initialized			//instantiate muxB
	
	shifter U1 (in, shift, sout);											//instantiate shifter U1
	
	//MUX inMUX(datapath_in, datapath_out, vsel, data_in);					//instantiate input MUX (switch between datapath_in and datapath_out)
	
	vDFFE #(3) status(clk, loads, Z_internal, Z_out);	//Z and Z_Out are 3 bits									//instantiate status register
	
	assign {N,V,Z} = Z_out;
	
	
endmodule

//MUX module
module MUX(a,b,sel,out);
	parameter m = 16;		//length of bus
	input [m-1:0] a, b;		//inputs
	input sel;				//selector
	output [m-1:0] out;		//output
	
	assign out = (sel ? a : b);	//logic
	
endmodule

module Four_IN_Mux(mdata, sximm8, PC16, C, vsel, out);
	input [15:0] mdata, sximm8, PC16, C;
	input [1:0] vsel;
	output [15:0] out;
	
	reg [15:0] out;

	always@(*) begin  //see if the wild card works here
	case(vsel)
	2'b00: out = C;
	2'b01: out = PC16;
	2'b10: out = sximm8;
	2'b11: out = mdata;
	default out = {16{1'bx}};
	endcase
	end //for always
endmodule
