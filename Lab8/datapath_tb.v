module datapath_tb;

	reg clk, write, asel, bsel, loadc,loads,loada,loadb,vsel;
	reg [2:0] writenum, readnum;
	reg [1:0] shift, ALUop;
	reg [15:0] datapath_in;
	
	wire [15:0] datapath_out;
	
	wire Z_out;
	reg err;

datapath DUT(.datapath_in(datapath_in), .writenum(writenum), .write(write), .readnum(readnum), .clk(clk), .asel(asel), .bsel(bsel), .vsel(vsel), .loadb(loadb), .loada(loada), .loadc(loadc), .loads(loads), .shift(shift), .ALUop(ALUop), .datapath_out(datapath_out), .Z_out(Z_out));



task my_checker;    
    input  expected_Z; 
    input [15:0] expected_output;   
  begin
    if( datapath_tb.DUT.datapath_out !== expected_output ) begin
       $display("ERROR ** output is %b, expected %b",
           datapath_tb.DUT.datapath_out, expected_output  );
       err = 1'b1;
    end

    if( datapath_tb.DUT.Z_out !== expected_Z ) begin
       $display("ERROR ** output is %b, expected %b", datapath_tb.DUT.Z_out, expected_Z );
       err = 1'b1;
    end
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
	
	err = 0;

	// MOV R0, #7
	$display("MOV R0, #7");
	datapath_in = 7;
	vsel = 1;
	writenum = 0;
	write = 1;
	readnum = 0;
	#10;
	write = 0;

	// MOV R1 #2
	$display("MOV R1 #2");
	datapath_in = 2;
	vsel = 1;
	writenum = 1;
	write = 1;
	readnum = 1;
	#10;
	write = 0;


	// SHIFT R0, LSL#1
		$display("SHIFT R0, LSL#1");
		//load R0 to Register B
		$display (" load R0 to Register B");
		writenum = 0;
		readnum = 0;
		loadb = 1;
		shift = 1;
		bsel = 0;
		asel = 1;
		ALUop = 0;
		#10;
		loadb = 0;	//reset registers
	
		// change datapath_out to R0 shifted
		$display(" change datapath_out to R0 shifted");
		loadc = 1;
		#10;
		loadc = 0;
		my_checker(1'bx,14);
		
		//store shifted R0 to R0
		$display(" store shifted R0 to R0");
		vsel = 0;
		writenum = 0;
		write = 1;
		#10;
		write = 0;
		
	// ADD R2, R1, R0
	$display("ADD R2, R1, R0");
		//load R0 to register A, make Ain = R0
		$display(" load R0 to register A, make Ain = R0");
		readnum = 0;
		loada = 1;
		asel = 0;
		#10;
		loada = 0;
		loadb = 0;
		
		//load R1 to register B, make Bin = R1, add two values
		$display(" load R1 to register B, make Bin = R1, add two values");
		readnum = 1;
		loadb = 1;
		shift = 0;
		bsel = 0;
		ALUop = 0;
		#10;
		loadb = 0;
		
		//load value to register C
		$display(" load value to register C");
		loadc = 1;
		#10;
		loadc = 0;
		
		//store added value in R2
		$display(" store added value in R2");
		vsel = 0;
		writenum = 2;
		write = 1;
		#10;
		write = 0;
		writenum = 0;
	
	//read R2 to datapath_out
	$display("read R2 to datapath_out");
	write = 0;
	readnum = 2;
	loadb = 1;
	shift = 0;
	bsel = 0;
	asel = 1;
	ALUop = 0;
	#10;
	loadb = 0;
	
	loadc = 1;
	#10;
	my_checker(1'bx,16);
	
	
	if(~err) $display("PASSED");
	else $display("FAILED");

	$stop;

end




endmodule
