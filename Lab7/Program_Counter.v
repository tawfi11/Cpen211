module Program_Counter(clk,load_pc,reset_pc,counter_out);
	
	output [8:0] counter_out;
	input load_pc,reset_pc,clk;
	
	wire [8:0]next_pc;
	reg [8:0] incremented;
	
	assign next_pc = reset_pc ? 9'b0 : incremented;
	
	vDFFE #(9) Counter (clk,load_pc,next_pc, counter_out);
	
	
	always @(*)begin
  
		incremented = counter_out + 1'b1;
		
	end

	

endmodule 


module Memory_address(clk,in,load_addr,counter_out,addr_sel,mem_addr);

	input clk,load_addr,addr_sel;
	input [8:0] in, counter_out;
	output [8:0] mem_addr;
	wire [8:0] data_out;
	
	vDFFE #(9) Data_Address (clk,load_addr,in,data_out);
	
	assign mem_addr = addr_sel ? counter_out : data_out;

endmodule 