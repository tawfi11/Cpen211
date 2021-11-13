module regfile_tb;
  reg [15:0] data_in;
  reg [2:0] writenum,readnum;
  reg write,clk,err;
  wire [15:0] data_out;

 
regfile DUT(.data_in(data_in),.writenum(writenum),.write(write),.readnum(readnum),.clk(clk),.data_out(data_out));

  // declare a task for checking state and outputs
  task my_checker;    
//    input [15:0] expected_state; 
    input [15:0] expected_output;   
/*    
  begin
    if( regfile_tb.DUT.data_out !== expected_output ) begin
       $display("ERROR ** output is %b, expected %b",
           FSM2_tb2.DUT.data_out, expected_output  );
       err = 1'b1;
    end
*/
    if( regfile_tb.DUT.data_out !== expected_output ) begin
       $display("ERROR ** output is %b, expected %b", regfile_tb.DUT.data_out, expected_output );
       err = 1'b1;
    end
  endtask


  initial begin
    clk = 0; #5;
    forever begin
      clk = 1; #5;
      clk = 0; #5;
    end
  end

  initial begin
	//checking storing numbers in all 8 registers
	err = 0;
	
	//checking store 1 -> R0
    data_in = 16'b0000_0000_0000_0001; write = 1; writenum = 3'b000;readnum = 3'b000; #10; 
    my_checker(16'b0000_0000_0000_0001);
    $display("data_out --- > %b",data_out);
	
	//checking store 2 -> R1
    data_in = 16'b0000_0000_0000_0010; writenum = 3'b001;readnum = 3'b001; #10; 
    my_checker(16'b0000_0000_0000_0010);
    $display("data_out --- > %b",data_out);

	//checking store 4 -> R2
    data_in = 16'b0000_0000_0000_0100; writenum = 3'b010;readnum = 3'b010; #10; 
    my_checker(16'b0000_0000_0000_0100);
    $display("data_out --- > %b",data_out);

	//checking store 8 -> R3
    data_in = 16'b0000_0000_0000_1000; writenum = 3'b011;readnum = 3'b011; #10; 
    my_checker(16'b0000_0000_0000_1000);
    $display("data_out --- > %b",data_out);

	//checking store 16 -> R4
    data_in = 16'b0000_0000_0001_0000; writenum = 3'b100;readnum = 3'b100; #10; 
    my_checker(16'b0000_0000_0001_0000);
    $display("data_out --- > %b",data_out);

	//checking store 34 -> R5
    data_in = 16'b0000_0000_0010_0010;  writenum = 3'b101;readnum = 3'b101; #10; 
    my_checker(16'b0000_0000_0010_0010);
    $display("data_out --- > %b",data_out);

	//checking store 65 -> R6
    data_in = 16'b0000_0000_0100_0001; writenum = 3'b110;readnum = 3'b110; #10; 
    my_checker(16'b0000_0000_0100_0001);
    $display("data_out --- > %b",data_out);

	//checking store 136 -> R7
    data_in = 16'b0000_0000_1000_1000; writenum = 3'b111;readnum = 3'b111; #10; 
    my_checker(16'b0000_0000_1000_1000);
    $display("data_out --- > %b",data_out);

	//check attempt to override initial number for R5 with write = 0
    data_in = 16'b1000_0000_0000_0000; write = 0; writenum = 3'b101;readnum = 3'b101; #10;
   my_checker(16'b0000_0000_0010_0010);
   $display("data_out --- > %b",data_out);

	//check to actually change R5
   data_in = 16'b1000_1000_1000_1000; write = 1; writenum = 3'b101;readnum = 3'b101; #10;
   my_checker(16'b1000_1000_1000_1000);
   $display("data_out --- > %b",data_out);

	//check to read a value of R3
 	readnum = 3'b011; #10;
   	my_checker(16'b0000_0000_0000_1000);
   $display("data_out --- > %b",data_out);

  //  reset = 1'b0; // remember to de-assert reset 
  /*   
    $display("checking Sa->Sa");
    in = 1'b0; #10; 
    my_checker(`Sa, 1'b0);

    $display("checking Sa->Sb");
    in = 1'b1; #10; 
    my_checker(`Sb, 1'b1);

    $display("checking Sb->Sb");
    in = 1'b0; #10; 
    my_checker(`Sb, 1'b1);

    //? checks for other state transitions ..
*/
    if( ~err ) $display("PASSED");
    else $display("FAILED");
    $stop;
  end
endmodule
