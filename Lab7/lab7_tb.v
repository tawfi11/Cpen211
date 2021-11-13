module lab7_tb();
	reg [3:0] KEY;
	reg [9:0] SW;
	wire [9:0] LEDR; 
	wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	reg err;
	
	lab7_top DUT(KEY,SW,LEDR,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5);
	
	initial begin
		KEY[0] = 1;
		#5;
		KEY[0] = 0;
		forever begin
			#5;
			KEY[0] = 1;
			#5;
			KEY[0] = 0;
		end
	end
	
	initial begin
	err = 0;
	KEY[1] = 0; //reset
	
	//Check for mem 0 - 9
	if(DUT.MEM.mem[0] != 16'b1101000000000101
) begin
		err = 1;
		$display("Memory stored in mem[0] is wrong");

	end
	if(DUT.MEM.mem[1] != 16'b0110000000100000
) begin
		err = 1;
		$display("Memory stored in mem[1] is wrong");

	end
	if(DUT.MEM.mem[2] != 16'b1101001000000110
) begin
		err = 1;
		$display("MEmory stored in mem[2] is wrong");

	end
	if(DUT.MEM.mem[3] != 16'b1000001000100000
) begin
		err = 1;
		$display("Memory stored in mem[3] is wrong");

	end
	if(DUT.MEM.mem[4] != 16'b1110000000000000
) begin
		err = 1;
		$display("Memory stored in mem[4] is wrong");

	end
	if(DUT.MEM.mem[5] != 16'b1010110011011100) begin
		err = 1;
		$display("Memory stored in mem[5] is wrong");

	end
	
	
	#10;
	
	KEY[1] = 1;
	
	#10;
	
	if (DUT.CPU.PC !== 9'b0) begin err = 1; $display("FAILED: PC is not reset to zero."); end

   @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  // wait here until PC changes; expect PC set to 1 *before* executing MOV R0, X

   if (DUT.CPU.PC !== 9'h1) begin err = 1; $display("FAILED: PC should be 1."); end
	
	@(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  // wait here until PC changes; autograder expects PC set to 2 *after* executing MOV R0, X

   if (DUT.CPU.PC !== 9'h2) begin err = 1; $display("FAILED: PC should be 2.");  end
   if (DUT.CPU.DP.REGFILE.R0 !== 16'b0000000000000101) begin err = 1; $display("FAILED: R0 should be 16'b101.");  end  // because MOV R0, X should have occurred
	
	@(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  // wait here until PC changes expect PC set to 3 *after* executing LDR R1, [R0]

    if (DUT.CPU.PC !== 9'h3) begin err = 1; $display("FAILED: PC should be 3.");  end
    if (DUT.CPU.DP.REGFILE.R1 !== 16'b1010110011011100) begin err = 1; $display("FAILED: R1 should be 0x18BC"); end //LDR

    @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  // wait here until PC changes;

    if (DUT.CPU.PC !== 9'h4) begin err = 1; $display("FAILED: PC should be 4.");  end
    if (DUT.CPU.DP.REGFILE.R2 !== 16'b0000000000000110) begin err = 1; $display("FAILED: R2 should be 1974.");  end

    @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  // wait here until PC changes; autograder expects PC set to 5 *after* executing STR R1, [R2]
   
    if (DUT.CPU.PC !== 9'h5) begin err = 1; $display("FAILED: PC should be 5.");  end
    if (DUT.MEM.mem[6] !== 16'b1010110011011100) begin err = 1; $display("FAILED: mem[6] wrong; looks like your STR isn't working"); end
	 
	 @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);
	 
    if (~err) $display("PASSED ALL TESTS");
    $stop;
	 end
	endmodule
	

	
