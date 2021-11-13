module detect_winner(ain, bin, cin, f, valid);
	input [8:0] ain, bin, cin;
	output [2:0] f;
	output valid;
 
	reg index ;
	reg check ; 
	reg [2:0] win;
	
	
	always @(*) begin
		win = 3'b000; //Assume no winners yet
		check = 1; //Assume initial valid game
		
		// Check validity (same squares)	
		if((ain [0] == bin[0]) || (ain[0] == cin[0]) || (ain [1] == bin[1]) || (ain[1] == cin[1]) || (ain [2] == bin[2]) || (ain[2] == cin[2]) || (ain [3] == bin[3]) || (ain[3] == cin[3]) || (ain [4] == bin[4]) || (ain[4] == cin[4]) || (ain [5] == bin[5]) || (ain[5] == cin[5]) || (ain [6] == bin[6]) || (ain[6] == cin[6]) || (ain [7] == bin[7]) || (ain[7] == cin[7]) || (ain [8] == bin[8]) || (ain[8] == cin[8])) begin
			check = 0;
		end
		
		if((bin[0] == cin[0]) || (bin[1] == cin[1]) || (bin[2] == cin[2]) || (bin[3] == cin[3]) || (bin[4] == cin[4]) || (bin[5] == cin[5]) || (bin[6] == cin[6]) || (bin[7] == cin[7]) || (bin[8] == cin[8])) begin
			check = 0;
		end
		
		//check validity (adjacent squares)
		if(ain[8] || bin[8] || cin[8]) begin
			if(ain[5] || bin[5] || cin[5]) begin
				if(!(ain[2] || bin[2] || cin[2])) begin
					check = 0;
				end
			end else begin
				check = 0;
			end
		end
		
		if(ain[6] || bin[6] || cin[6]) begin
			if(ain[3] || bin[3] || cin[3]) begin
				if(!(ain[0] || bin[0] || cin[0])) begin
					check = 0;
				end
			end else begin
				check = 0;
			end
		end
		
		if(ain[7] || bin[7] || cin[7]) begin
			if(ain[4] || bin[4] || cin[4]) begin
				if(!(ain[1] || bin[1] || cin[1])) begin
					check = 0;
				end
			end else begin
				check = 0;
			end
		end
		
		if(ain[6] || ain[7] || ain[8]) begin
			win[0] = 1'b1;
		end
		
		if(bin[6] || bin[7] || bin[8]) begin
			win[1] = 1'b1;
		end
		
		if(cin[6] || cin[7] || cin[8]) begin
			win[2] = 1'b1;
		end
		
		
			
	end
	
	assign valid = check;
	assign f = win;
	
endmodule

module q1_tb();
	reg [8:0] ain, bin, cin;
	wire [2:0] f;
	wire valid;
	
	detect_winner dut (ain, bin, cin, f, valid);
	
	initial begin
		ain = 9'b000_000_000;
		bin = 9'b000_000_000;
		cin = 9'b000_000_000;
		#10;
		
		ain = 9'b000_000_001;
		bin = 9'b000_001_000;
		cin = 9'b001_000_000;
		#10;
		
		ain = 9'b011_011_011;
		bin = 9'b000_000_000;
		cin = 9'b000_100_100;
		#10;
		
		ain = 9'b010_100_001;
		bin = 9'b100_001_010;
		cin = 9'b001_010_100;
		#10;
		
		ain = 9'b001_001_001;
		bin = 9'b000_000_001;
		cin = 9'b000_000_000;
		#10;
		
		ain = 9'b000_000_000;
		bin = 9'b000_000_000;
		cin = 9'b000_001_000;
		#10;
		
		ain = 9'b001_001_001;
		bin = 9'b000_000_000;
		cin = 9'b100_000_000;
		#10;
		
		$stop;
	end
endmodule
