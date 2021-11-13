`define MREAD 2'b01
`define MWRITE 2'b10

module lab8_top(KEY,SW,LEDR,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,CLOCK_50);
input [3:0] KEY;
input [9:0] SW;
output [9:0] LEDR;
output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
input CLOCK_50;


//wire [15:0] out, ir;
wire [8:0] mem_addr;
wire [1:0] mem_cmd;
wire [15:0] read_data, write_data;
wire [15:0] dout;
wire msel;
wire mread;
wire doutToggle, write, mwrite;

wire Z, N, V;
wire LEDout;

wire toggleSwitchInput, toggleLEDOutput;
wire clk = ~KEY[0] | CLOCK_50;
assign reset = ~KEY[1];

	//input_iface IN(CLOCK_50, SW, ir, LEDR[7:0]);
	cpu CPU(
		.clk(clk),
		.reset(reset),
		.mem_cmd(mem_cmd),
		.mem_addr(mem_addr),
		.read_data(read_data),
		.write_data(write_data),
		.LEDout(LEDout)
	);
	
RAM MEM(.clk(clk),.read_address(mem_addr[7:0]),.write_address(mem_addr[7:0]),.write(write),.din(write_data),.dout(dout));

eq #(2) mreadEQ(`MREAD, mem_cmd, mread);
eq #(2) mwriteEQ(`MWRITE, mem_cmd, mwrite);

eq #(1) mselEQ(1'b0, mem_addr[8:8], msel);

assign write = msel & mwrite;
assign doutToggle = msel & mread;

triStateBuffer doutBuffer(dout, doutToggle, read_data);

assign toggleSwitchInput = (mem_cmd == `MREAD && mem_addr == 9'h140 ? 1 : 0);
triStateBuffer #(16) SwitchBuffer ({8'b0,SW[7:0]},toggleSwitchInput,read_data);

assign toggleLEDOutput = (mem_cmd == `MWRITE && mem_addr == 9'h100 ? 1 : 0);
vDFFE #(8) LEDtoggle (clk, toggleLEDOutput, write_data[7:0], LEDR[7:0]);
//module vDFFE(clk, en, in, out) ;
//parameter n = 1;  // width of register

  // fill in sseg to display 4-bits in hexidecimal 0,1,2...9,A,B,C,D,E,F
  sseg H0(write_data[3:0],   HEX0);
  sseg H1(write_data[7:4],   HEX1);
  sseg H2(write_data[11:8],  HEX2);
  sseg H3(write_data[15:12], HEX3);
  assign HEX4 = 7'b1111111;
  assign HEX5 = 7'b1111111; // disabled
  assign LEDR[8] = LEDout;
endmodule

module eq(a, b, out);
parameter n;
input [n-1:0] a,b;
output out;
assign out = (a == b);
endmodule

module triStateBuffer(in,gate,out);
	parameter n = 16;
	input [n-1:0] in;
	input gate;
	output [n-1:0] out;

	assign out = gate ? in : {n{1'bz}};
endmodule

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

  reg [data_width-1:0] mem [2**addr_width-1:0];

  initial $readmemb(filename, mem);

  always @ (posedge clk) begin
    if (write)
      mem[write_address] <= din;
    dout <= mem[read_address]; // dout doesn't get din in this clock cycle 
                               // (this is due to Verilog non-blocking assignment "<=")
  end 
endmodule

/*module input_iface(clk, SW, ir, LEDR);
  input clk;
  input [9:0] SW;
  output [15:0] ir;
  output [7:0] LEDR;
  wire sel_sw = SW[9];  
  wire [15:0] ir_next = sel_sw ? {SW[7:0],ir[7:0]} : {ir[15:8],SW[7:0]};
  vDFF #(16) REG(clk,ir_next,ir);
  assign LEDR = sel_sw ? ir[7:0] : ir[15:8];  
endmodule */        

module vDFF(clk,D,Q);
  parameter n=1;
  input clk;
  input [n-1:0] D;
  output [n-1:0] Q;
  reg [n-1:0] Q;
  always @(posedge clk)
    Q <= D;
endmodule

// The sseg module below can be used to display the value of datpath_out on
// the hex LEDS the input is a 4-bit value representing numbers between 0 and
// 15 the output is a 7-bit value that will print a hexadecimal digit.  You
// may want to look at the code in Figure 7.20 and 7.21 in Dally but note this
// code will not work with the DE1-SoC because the order of segments used in
// the book is not the same as on the DE1-SoC (see comments below).

module sseg(in,segs);
  input [3:0] in;
  output [6:0] segs;
  reg[6:0] segs;

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
		0  : segs = 7'b1000000;		//0
		1  : segs = 7'b1111001;		//1
		2  : segs = 7'b0100100;		//2
		3  : segs = 7'b0110000;		//3
		4  : segs = 7'b0011001;		//4
		5  : segs = 7'b0010010;		//5
		6  : segs = 7'b0000010;		//6
		7  : segs = 7'b1111000;		//7
		8  : segs = 7'b0000000;		//8
		9  : segs = 7'b0010000;		//9
		10 : segs = 7'b0001000;		//10
		11 : segs = 7'b0000011;		//11
		12 : segs = 7'b1000110;		//12
		13 : segs = 7'b0100001;		//13
		14 : segs = 7'b0000110;		//14
		15 : segs = 7'b0001110;		//15
		default : segs = 7'b0111111;		//-
	endcase
	
	end

endmodule

