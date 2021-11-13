module q2_tb;
	reg [2:0] a;
	reg b, c;
	
	initial begin
		a = 3'b101;
		b = 1;
		c = 1;
		
		#5; //5s
		
		c = 0;
		
		#5; //10s
		
		a = 3'b000;
		b = 0;
		
		#5; //15s
		
		c = 1;
		b = 1;
		
		#5; //20s
		
		c = 0;
		b = 0;
		
		#10; //30s
		
		a = 3'b010;
		c = 1;
		
		#5; //35s
		
		b = 1;
		
		#5; //40s
		
		$stop;
	end
endmodule		