module RAM1P(clk,addr,write,data);
  parameter address_width = 4;
  parameter data_width = 6;
  parameter filename = "data.txt";
  input clk, write;
  input [address_width-1:0] addr;
  inout [data_width-1:0] data;
  reg [data_width-1:0] mem [2**address_width-1:0];

  initial $readmemb(filename,mem);
  assign data = (~write) ? mem[addr] : {data_width{1'bz}};
  always @(posedge clk)
    if (write)
      mem[addr] <= data;
endmodule
