`define MREAD 2'b01
`define MWRITE 2'b10
 
module RAM(clk,read_address,write_address,write,din,dout);
  parameter data_width = 16; 
  parameter addr_width = 8;
  parameter filename = "data.txt";
 
  input clk;
  input [addr_width-1:0] read_address, write_address;
  input write;
  input [data_width-1:0] din;
  output [data_width-1:0] dout;
  reg [data_width-1:0] dout;
 
 // wire [8:0] mem_addr_in;
 // wire [1:0] mem_cmd_in;
 // wire [15:0] read_data;
 // wire [8:0] mem_addr_out;
 // wire [1:0] mem_cmd_out;
 
 // extra_shit idk (mem_cmd_in, mem_addr_in, dout, read_data, mem_cmd_out, mem_addr_out, read_address);
 
  reg [data_width-1:0] mem [2**addr_width-1:0];
  
 
  initial $readmemb(filename, mem);
 
  always @ (posedge clk) begin
    if (write)
      mem[write_address] <= din;
    dout <= mem[read_address]; // dout doesn't get din in this clock cycle 
                               // (this is due to Verilog non-blocking assignment "<=")
  end 
endmodule
 
module EqComp(a, b, eq) ;
  parameter k=8;
  input  [k-1:0] a,b;
  output eq;
  wire   eq;
 
  assign eq = (a == b) ;
endmodule
 
module TriStateDriver(a,b,out);
	
	parameter k = 16;

  input [k-1:0] a;
  input b;
  output [k-1:0] out;
  assign out = b ? a : {k{1'bz}};
endmodule
 
module extra_shit (mem_cmd, mem_addr, dout, read_data, write);
  input [8:0] mem_addr;
  input [1:0] mem_cmd;
  input [15:0] dout;
  output write;
  output [15:0] read_data;
  
  wire msel; //Output of (8) in figure 5
  wire eqcomp_write, eqcomp_read;
 
  EqComp #(1) comp_addr (mem_addr [8], 1'b0, msel);
  EqComp #(2) comp_read (mem_cmd, `MREAD, eqcomp_read);
  EqComp #(2) comp_write (mem_cmd, `MWRITE, eqcomp_write);
  TriStateDriver driver (dout, msel & eqcomp_read, read_data); //Tristate driver (7)
  
  assign write = eqcomp_write & msel;
 
endmodule
