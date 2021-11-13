module regfile_tb();
	reg [15:0] data_in;
	reg [2:0] writenum, readnum;
	reg write, clk;
	wire [15:0] data_out;
	reg err;
	
	regfile DUT (.data_in(data_in),.writenum(writenum),.write(write),.readnum(readnum),.clk(clk),.data_out(data_out));
	
	initial begin
		clk = 0;
		#5;
		forever begin
			clk = 1;
			#5;
			clk = 0;
			#5;
		end
	end
	
	initial begin
		err = 1'b0;
		write = 1'b1;
		
		#5;
		
		writenum = 3'b000;
		data_in = 16'd5;
		 
		#5;
		if(data_out == 16'd5) begin
			$display("INCORRECT, data should not equal anything, your data equals %d", data_out);
			err = 1'b1;
		end
		
		writenum = 3'b001;
		data_in = 16'd7;
		
		#5;
		
		readnum = 3'b001;
		
		#10;
		if(data_out != 16'd7) begin
			err = 1'b1;
			$display("ERROR, data_out should be %d, you got %d", 16'd5, data_out);
		end
		
		$display("data_out is %d", data_out);
		
		#5;
		if(err == 1'b0) begin
			$display("CONGRATS, PASSED ALL TESTS");
		end else begin
			$display("ERROR, TESTBENCH FAILED");
		end
		
		#5;
		
		$stop;
		
	end
endmodule
