module ALU_tb();
	reg [15:0] Ain, Bin;
	reg[1:0] ALUop;
	wire [15:0] out;
	wire Z;
	reg err;
	
	ALU DUT (.Ain(Ain),.Bin(Bin),.ALUop(ALUop),.out(out),.Z(Z));
	
	initial begin
		err = 1'b0;
		
		Ain = 16'd101;
		Bin = 16'd100;
		
		$display("Ain = %d, Bin = %d", Ain, Bin);
		
		#5;
		
		ALUop = 2'b00;
		
		#5;
		
		
		if(out != 201) begin
			err = 1'b1;
			$display( "Error, expected value is: %d. Your value is: %d", 201, out);
		end
		$display("Ain + Bin = %d", out);
		
		#5;
		
		ALUop = 2'b01;
		
		#5;
		
		
		if(out != 1) begin
			err = 1'b1;
			$display("Error, expected value is: %d. Your value is: %d", 1, out);
		end
		$display("Ain - Bin = %d", out);
		
		#5;
	
		ALUop = 2'b10;
		
		#5;
		
		
		if(out != (Ain & Bin)) begin
			err = 1'b1;
			$display("Error, expected value is: %b. Your value is: %b", (Ain & Bin), out);
		end
		$display("Ain & Bin = %b", out);
		
		#5;
		
		ALUop = 2'b11;
		
		#5;
		
		
		if(out != ~Bin) begin
			err = 1'b1;
			$display("Error, expected value is: %b. Your value is: %b", ~Bin, out);
		end
		$display("~Bin = %b", out);
		
		#5;
		
		ALUop = 2'b01;
		
		#5;
		
		
		Ain = 16'd100;
		
		#5;
		
		
		if(out != 16'b0 & Z != 1) begin
			$display("Error, Z should be %b and out should be %b", 1'b0, 16'b0);
			err = 1'b1;
		end
		$display("Z = %b, out = %b", Z, out);
		
		#5; 
		
		if(err == 1'b1) begin
			$display("ERROR FOUND, TEST FAILED");
		end else begin
			$display("PASSED ALL TESTS, CONGRATS");
		end
		
		#5;
		
		$stop;
	end
	
endmodule
