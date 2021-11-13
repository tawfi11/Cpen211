`define MREAD 2'b01
`define MWRITE 2'b10


module cpu(read_data,clk,reset,write_data,N,V,Z, mem_addr, mem_cmd);

	input clk, reset;
	//input[15:0] in;
	output[15:0] write_data;
	output N, V, Z;
	
	//
	
	wire [15:0] instout;
	
	wire [2:0] opcode;
	wire [1:0] op;
	wire [38:0]decout;
	

	wire [2:0] Z_out;
	
	reg reset1;
	//
	
	reg write;
	reg [3:0]vsel;
	reg bsel ;
	reg asel ;
	reg loads ;
	reg loadc ;
	reg loadb;
	reg loada;
	reg [2:0]nsel;

	wire [2:0]readnum = decout[2:0];
	wire [2:0]writenum = decout[2:0];
	wire [1:0]shift = decout[4:3];
	wire [15:0]sximm8 = decout[20:5];
	wire [15:0]sximm5 = decout [36:21];
	wire [1:0]ALUop = decout[38:37];
	wire [15:0]datapath_out;
	
	//
	//FOR FUTURE LABS
	input [15:0] read_data;
	wire [7:0] imPC;
	wire [15:0] mdata = read_data;
	
	//
	
	 wire [4:0] presentstate ; //state counter
	 
	 //
	 // added for lab 7
	 
	
	
	 reg load_pc,reset_pc,load_addr,addr_sel;
	 wire [8:0] PC;
	 output [8:0] mem_addr;
	 output reg [1:0] mem_cmd;
	 reg stop;
	 reg load_ir;
	 
	 //

	
	vDFFE #(16) INST_REG (clk,load_ir,read_data,instout);	// Instruction Register
	
	Instruction_Decoder Inst_Dec (instout,nsel,opcode,op,decout); // Instruction Decoder
	
	datapath DP(clk, readnum, vsel, loada, loadb, shift, asel, bsel, ALUop, loadc, loads, writenum, write, Z_out, datapath_out, read_data, sximm8, imPC, sximm5);
	
	Program_Counter count (clk,load_pc,reset_pc,PC);
	
	Memory_address Asshole (clk,datapath_out[8:0],load_addr,PC,addr_sel,mem_addr);
	
	
	
	//
	
   Counter5 Statecount(clk,stop,reset,reset1,presentstate);
	
	always @(*) begin
	
		if(presentstate == 5'd0)begin //Resets all values at Wait
			reset1 = 0;
			vsel = 4'b0000;
			write = 0;
			nsel = 3'b000;
			loada = 0;
			loadb = 0;
			loadc = 0;
			loads = 0;
			asel = 0;
			bsel = 0;
			stop = 0;
			mem_cmd = `MREAD;
		
			reset_pc = 1;
			load_pc = 1;
		
		end
			
	
		if(presentstate == 5'd1)begin
		
			reset1 = 0;
			vsel = 4'b0000;
			write = 0;
			nsel = 3'b000;
			loada = 0;
			loadb = 0;
			loadc = 0;
			loads = 0;
			asel = 0;
			bsel = 0;
			stop = 0;
		
			load_pc = 1;
			addr_sel = 1;
			//mem_cmd = `MREAD;
			load_ir = 1;
			write = 0;
			load_pc = 1;
			reset_pc = 0;
			
			
		
		end
		
		if(presentstate == 5'd2) load_pc = 0;
		
		if(presentstate == 5'd3) begin load_ir = 0; reset_pc = 0; end
		
		
		if(presentstate > 5'd3) begin
		//	load_pc = 0;

	
		 if(opcode == 3'b110)begin //For MOV operations
		
			if(op == 2'b10)begin // When data is read from the input and storeed in the REG
			
				vsel = 4'b100;
				write = 1;
				nsel = 3'b100;
				reset1 = 1;
			
			end
			
			if(op == 2'b00)begin // When value is copied from one Register to another
			
				//Since ALUop and op shares the same wires, ALUop is add form
				//So we set asel to 1 ad adding sh_B with zero and getting the samething and storing it in the Register
			
				case(presentstate)
				
				5'd4: begin
						write = 0;
						nsel = 3'b001;
						loadb = 1;
						end
						
				5'd5: begin
						asel = 1;
						bsel = 0;
						loadc = 1;
						end
						
				5'd6: begin
						vsel = 4'b0001;
						nsel = 3'b010;
						write = 1;
						reset1 = 1;
						end
				
				
				default: begin
							write = 0;
							loada = 0;
							loadb = 0;
							end
				
				
				endcase
			
			end
	
		
		end
	
	

	 if (opcode == 3'b101)begin // ALU function
		
			case(presentstate)
			
			
			5'd4: begin
					loada = 1;
					loadb = 0;
					nsel = 3'b100;
					write = 0;
					loadc = 0;
					end
					
			5'd5: begin
					loada = 0;
					loadb = 1;
					nsel = 3'b001;
					end
					
			5'd6: begin
					asel = 0;
					bsel = 0;
					loadc = 1;
					if(ALUop == 2'b01) begin //Subtracts 
									loads = 1;
									write = 0;
									reset1 = 1;
									loadc = 0;
									end
										
		 
					end
					
			5'd7:	begin
					
					vsel = 3'b001;
					write = 1;
					nsel = 3'b010;
					reset1 = 1;
					end
					
		
			
			endcase
			
			
		end
		
		
		
		if(opcode == 3'b011) begin
			
			
			case(presentstate)
			
			5'd4: begin
			
					nsel = 3'b100;
					write = 0;
					loada = 1;
					loadb = 0;
					
					end
					
					
			5'd5: begin
			
					asel = 0;
					bsel = 1;
					loadc = 1;
				
					end
					
			5'd6: begin
			
					load_addr = 1;
					addr_sel = 0;
					
					mem_cmd = `MREAD;
					vsel = 4'b1000;
					end
					
			5'd7: begin
			
					write = 1;
					nsel = 010;
					
			
					end
					
			5'd8: reset1 = 1;
					
					
			endcase
				
		end
		
		if(opcode == 3'b100)begin
		
			case(presentstate)
			
				5'd4: begin
						nsel = 3'b100;
						write = 0;
						loada = 1;
						loadb = 0;
						end
					
					
				5'd5: begin
						asel = 0;
						bsel = 1;
						loadc = 1;
						end
						
				
				5'd6: begin
						load_addr = 1;
						addr_sel = 0;
						end
						
				5'd7: begin
						load_addr = 0;
						nsel = 3'b010;
						loadb = 1;
						loada = 0;
						end
						
				5'd8: begin 
						asel = 1;
						bsel = 0;
						loadc = 1;
						end 
						
				5'd9: begin 
						mem_cmd = `MWRITE;
						reset1 = 1;
						end
		
		
			endcase
		
		
		end
		
		
		if(opcode == 3'b111) stop = 1;
		
		
		
		
	 end
	
	
	
	end
		
	
	
	
	//


	assign Z = Z_out[0];
	assign N = Z_out[1];
	assign V = Z_out[2];
	//assign w = (~s & ~(|presentstate));
	
	/*always @(negedge clk) begin
	
		if(~s & ~(|presentstate))
			w = 1;
		else 
			w = 0;
	end*/
	
	assign write_data = datapath_out;


endmodule 

module Instruction_Decoder (in,nsel,opcode,op,out);

	input [15:0] in;
	output [2:0] opcode;
	output [1:0] op;
	input [2:0] nsel;
	output [38:0] out;
	
	wire [2:0] Rn,Rd,Rm;
	
	wire [1:0] ALUop;
	wire [15:0] sximm5, sximm8;
	wire [1:0] shift;
	wire [2:0] muxout;
	
	//Assign values from in based on the model
	assign opcode = in[15:13];
	assign op = in[12:11];
	
	assign Rm = in[2:0];
	assign Rd = in[7:5];
	assign Rn = in[10:8];
	assign ALUop = in[12:11];
	assign shift = in[4:3];
	assign sximm5 = {{11{in[4]}}, in[4:0]};
	assign sximm8 = {{8{in[7]}}, in[7:0]};
	
	
	mux3h #(3) Inst_mux (Rn,Rd,Rm,nsel,muxout);
	
	assign out = {ALUop,sximm5,sximm8,shift,muxout};
	

endmodule 	

module mux3h(a2,a1,a0, s, b);
	parameter k = 1;
	input [k-1:0] a0, a1, a2;
	input [2:0] s;
	output [k-1:0] b;
	wire [k-1:0] b = ({k{s[0]}} & a0) | ({k{s[1]}} & a1) | ({k{s[2]}} & a2);
	
endmodule 



/*module add2(clk,reset,s,w,out) ;
  input reset, clk ; // reset and clock
  output w ;
  reg    [2:0] next ;
  input s;

  vDFF #(2) count(clk, next, out) ;

  always @(*)
    casex({reset,out})
      {1'b1, 5'bxxxxx}: next = 0 ;
      6'd0: next = 1 ; // 6’d0 == {1’b0, 5’b00000}
      6'd1: next = 2 ;
      6'd2: next = 3 ;
      6'd3: next = 4 ;
      6'd4: next = 5 ;
		6'd5: next = 0 ;
      default: next = 5'bxxxxx ;
    endcase

endmodule 
*/


module Counter5(clk,stop,rst,reset1,out) ;
  input rst, clk, reset1, stop ; // reset and clock
  output [4:0] out ;
  reg    [4:0] next ;

  vDFF #(5) count(clk, next, out) ;
 
  
//State counter, this module gets called to keep track of our states
  always @(*)begin
  
		if(rst) next = 0;
		else if(stop);
		else if(reset1 | out == 5'd31) next = 1;
		else next = out + 5'b00001;
		
	 end
endmodule
/*

module SM(clk,reset,w,opcode,op,out,s);

	input clk, reset,s;
	input [2:0] opcode;
	input [1:0] op;
	output w;
	output [13:0]out;
	
	 reg loada ;
	 reg loadb ;
	 reg loadc ;
	 reg [2:0]nsel ;
	 reg asel ;
	 reg bsel ;
	 reg [3:0]vsel ;
	 reg write ;
	 reg loads;
	
	reg [2:0] present_state; 
	
	Counter5 TBD(clk,s,reset,present_state);
	
	always @(*) begin
	
		case(present_state)
			3'd2: begin 
					loada = 1;
					loadb = 0;
					nsel = 3'b001;
					
					end
					
			3'd3: begin
				
					loada = 0;
					loadb = 1;
					nsel = 3'b100;
					end
					
			3'd4: begin
					loada = 0;
					loadb = 0;
					asel = 0;
					bsel = 0;
			//		shift = 0;
			//		ALUop = 0;
					loadc = 1;
					end
					
			3'd5: begin
					nsel = 3'b010;
					vsel = 0;
					write = 1;
					loadc = 0;
					end
					
			default: begin
						loada = 0;
						loadb =0;
						loadc = 0;
						nsel = 0;
						asel = 0;
						bsel = 0;
			//			shift = 0;
			//			ALUop = 0;
						vsel = 0;
						write = 0;
						end
	
		endcase
		
		
	
	end
	
	assign w = ~s;
	
	
	assign out = {nsel,loada,loadb,loadc,loads,asel,bsel,vsel,write};


endmodule



*/
/*

module MOVin(vsel,writenum,instR,nsel);

	output [3:0] vsel;
	output [2:0] writenum;
	input  [2:0] InstR;
	output [2:0] nsel;
	
	assign vsel = 4'b100;
	assign write = 1;
	assign writenum = Rn;		

endmodule

module Movtrans(clk,instR,nsel,writenum,readnum,vsel,loadb,loadc,asel,bsel,shift,ALUop);

	input clk;
	input [2:0]instR;
	output [2:0] nsel;
	output [2:0] writenum,readnum;
	output [3:0] vsel;
	output loadb,loadc,asel,bsel;
	output [1:0] shift;
	output [1:0] ALUop;
	
	

	



endmodule

*/




