module datapath_tb();
	reg clk; 
	reg [2:0] readnum; 
	reg [3:0]vsel; 
	reg loada;
	reg loadb; 
	reg [1:0]shift; 
	reg asel, bsel; 
	reg [1:0] ALUop; 
	reg loadc, loads; 
	reg [2:0] writenum; 
	reg write; 
	reg [2:0] Z_out;
	wire [15:0] datapath_out;
	reg [15:0] mdata;
	reg [15:0] sximm8;
	reg [7:0] PC;
	reg [15:0] sximm5;

	reg err;
	
	datapath DUT (.clk(clk), .readnum(readnum), .vsel(vsel), .loada(loada), .loadb(loadb), .shift(shift), .asel(asel), .bsel(bsel), .ALUop(ALUop), .loadc(loadc), .loads(loads), .writenum(writenum), .write(write), .Z_out(Z_out), .datapath_out(datapath_out), .mdata(mdata), .sximm8(sximm8), .PC(PC), .sximm5(sximm5));
	
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
		sximm8 = 16'd7;
		vsel = 4'b0100;
		writenum = 3'd0;
		write = 1'b1;
		
		
		shift = 2'b01;
		asel = 1'b0;
		bsel = 1'b0;
		ALUop = 2'b00;
		loadc = 1'b1;
		
		#10;
		
		sximm8 = 16'd2;
		writenum = 3'd1;
		
		#10;
		
		
		loada = 1'b0;
		readnum = 3'd0;
		loadb = 1'b1;
		
		#10;
		
		loadb = 1'b0;
		readnum = 3'd1;
		loada = 1'b1;
		
		
		
		#10;
		
		loadb = 1'b0;
		loada = 1'b0;
		
		#10;
		
		$display("The output is: %d", datapath_out);
		
		
		vsel = 4'b0001;
		writenum = 3'd2;
		
		#10;
		
		readnum = 3'd3;
		loada = 0;
		loadb = 1;
		
		#10;
		
		asel = 1;
		
		#10;
		
		loadb = 1'b0;
		loada = 1'b0;
		
		
		#10;
		
		if(datapath_tb.DUT.REGFILE.R0 != 16'b111) begin
			err = 1'b1;
			$display("ERROR, expected value is %b, actual value is %b", 16'b111,datapath_tb.DUT.REGFILE.R0);
		end
		if(datapath_tb.DUT.REGFILE.R1 != 16'd2) begin
			err = 1'b1;
			$display("ERROR, expected value is %b, actual value is %b", 16'd2, datapath_tb.DUT.REGFILE.R1);
		end
		if(datapath_tb.DUT.REGFILE.R2 != 16'd16) begin
			err = 1'b1;
			$display("ERROR, expected value is %b, actual value is %b", 16'd16,datapath_tb.DUT.REGFILE.R2);
		end
		
		#10;
		
		if(err == 1'b1) begin
			$display("TESTBENCH FAILED");
		end else begin
			$display("SUCCESS!! TEST PASSED");
		end
		
		
		$stop;
		
	end
	
endmodule

