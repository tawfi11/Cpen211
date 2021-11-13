`define MREAD 2'b01
`define MWRITE 2'b10
`define SW_BASE 9'h140
`define LEDR_BASE 9'h100

module lab7_top(KEY,SW,LEDR,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5);
	input [3:0] KEY;
	input [9:0] SW;
	output [9:0] LEDR;
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	
	wire [15:0] out, ir;
	wire Z, N, V;
	wire clk = ~KEY[0];
	wire reset = ~KEY[1];
	
	wire [1:0] mem_cmd;
	wire [8:0] mem_addr;
	wire [15:0] read_data, write_data;
	wire [15:0] dout;
	wire write;
	
	
	extra_shit Jesus (mem_cmd, mem_addr, dout, read_data, write);
	
	RAM MEM (clk,mem_addr[7:0],mem_addr[7:0],write,write_data,dout);
	
	cpu CPU (read_data,clk,reset,write_data,N,V,Z, mem_addr, mem_cmd);
	
	switch_shit swi_in(SW[7:0],mem_cmd,mem_addr,read_data);
	
	led_shit led_out(clk,LEDR[7:0],mem_cmd,mem_addr,write_data);
	
	
			
	assign HEX5[0] = ~Z;
	assign HEX5[6] = ~N;
	assign HEX5[3] = ~V;

	// fill in sseg to display 4-bits in hexidecimal 0,1,2...9,A,B,C,D,E,F
	sseg H0(out[3:0],   HEX0);
	sseg H1(out[7:4],   HEX1);
	sseg H2(out[11:8],  HEX2);
	sseg H3(out[15:12], HEX3);
	assign HEX4 = 7'b1111111;
	assign {HEX5[2:1],HEX5[5:4]} = 4'b1111; // disabled
	assign LEDR[8] = 1'b0;
	
endmodule

module sseg(in,segs);
  input [3:0] in;
  output reg[6:0] segs;

  // NOTE: The code for sseg below is not complete: You can use your code from
  // Lab4 to fill this in or code from someone else's Lab4.  
  //
  // IMPORTANT:  If you *do* use someone else's Lab4 code for the seven
  // segment display you *need* to state the following three things in
  // a file README.txt that you submit with handin along with this code: 
  //
  //   1.  First and last name of student providing code
  //   2.  Student number of student providing code
  //   3.  Date and time that student provided you their code
  //
  // You must also (obviously!) have the other student's permission to use
  // their code.
  //
  // To do otherwise is considered plagiarism.
  //
  // One bit per segment. On the DE1-SoC a HEX segment is illuminated when
  // the input bit is 0. Bits 6543210 correspond to:
  //
  //    0000
  //   5    1
  //   5    1
  //    6666
  //   4    2
  //   4    2
  //    3333
  //
  // Decimal value | Hexadecimal symbol to render on (one) HEX display
  //             0 | 0
  //             1 | 1
  //             2 | 2
  //             3 | 3
  //             4 | 4
  //             5 | 5
  //             6 | 6
  //             7 | 7
  //             8 | 8
  //             9 | 9
  //            10 | A
  //            11 | b
  //            12 | C
  //            13 | d
  //            14 | E
  //            15 | F
  
  always @(*) begin
	
	case(in)
	
	4'd0 : segs = 7'b1000000;
	4'd1 : segs = 7'b1111001;
	4'd2 : segs = 7'b0100100;
	4'd3 : segs = 7'b0110000;
	4'd4 : segs = 7'b0011001;
	4'd5 : segs = 7'b0010010;
	4'd6 : segs = 7'b0000010;
	4'd7 : segs = 7'b1111000;
	4'd8 : segs = 7'b0000000;
	4'd9 : segs = 7'b0011000;
	4'd10 : segs = 7'b0001000;
	4'd11 : segs = 7'b0000011;
	4'd12 : segs = 7'b1000110;
	4'd13 : segs = 7'b0100001;
	4'd14 : segs = 7'b0000110;
	4'd15 : segs = 7'b0001110;
	
	default: segs = 7'bxxxxxxx;
	
  endcase
  
  end

 // assign segs = 7'b0001110;  // this will output "F" 

endmodule

module vDFF(clk,D,Q);
  parameter n=1;
  input clk;
  input [n-1:0] D;
  output [n-1:0] Q;
  reg [n-1:0] Q;
  always @(posedge clk)
    Q <= D;
endmodule

module switch_shit(SW,mem_cmd,mem_addr,read_data);

	input [7:0] SW;
	input [1:0] mem_cmd;
	input [8:0] mem_addr;
	output [15:0] read_data;
	
	wire allow1,allow2,allow;
	
	EqComp #(9) Bullshit1(`SW_BASE,mem_addr,allow1);
	EqComp #(2) Bullshit2(`MREAD,mem_cmd,allow2);
	
	assign allow = allow1 & allow2;
	
	TriStateDriver #(8) switch_in(SW,allow,read_data[7:0]);
	TriStateDriver #(8) zeros(8'b0,allow,read_data[15:8]);
	
	
endmodule

module led_shit(clk,LED,mem_cmd,mem_addr,write_data);

	input clk;
	output [7:0]LED;
	input [1:0] mem_cmd;
	input [8:0] mem_addr;
	input [15:0] write_data;
	
	wire [7:0]write = write_data [7:0];
	
	wire allow1,allow2,allow;
	
	EqComp #(9) Bullshit1(`LEDR_BASE,mem_addr,allow1);
	EqComp #(2) Bullshit2(`MWRITE,mem_cmd,allow2);
	
	assign allow = allow1 & allow2;
	
	vDFFE #(8) led_update(clk, allow, write, LED) ;

endmodule


 