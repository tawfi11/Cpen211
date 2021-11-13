module DetectWinner_tb();
	reg index ;
	reg [8:0] ain ;
	reg [8:0] bin ;
	wire [7:0] win_line ;
	
	DetectWinner dut (ain, bin, win_line);
	
	initial begin
	//Nobody is the winner
		ain = 9'b000_000_000;
		bin = 9'b0;
		#10
	//a won by getting the bottom row win_line[0] = 1
		ain = 9'b111_000_000 ;
		#10
	//a won by getting the middle row win_line[1] = 1
		ain = 9'b000_111_000 ;
		#10
	//a won by getting the top row win_line[2] = 1
		ain = 9'b000_000_111 ;
		#10
	//a won by getting the right col win_line[3] = 1
		ain = 9'b100_100_100 ;
		#10
	//a won by getting the middle col win_line[4] = 1
		ain = 9'b010_010_010 ;
		#10
	//a won by getting the left col win_line[5] = 1
		ain = 9'b001_001_001 ;
		#10
	//a won by getting the top left to bottom right diaganol win_line[6] = 1
		ain = 9'b100_010_001 ;
		#10
	//a won by getting the top right to bottom left diaganol win_line [7] = 1
		ain = 9'b001_010_100 ;
		#10
	//nobody won win_line = 0
		ain = 9'b010011000 ;
		#10
	//nobody won win_line = 0
		ain = 9'b110_000_001 ;
		#10
	//nobody won win_line = 0
		ain = 9'b010_000_100 ;
		#10
	//nobody won win_line = 0
		ain = 9'b000_000_001 ;
		#10
	//nobody won win_line = 0
		ain = 9'b010_010_100 ;
		#10
		$stop;	
	end

endmodule 