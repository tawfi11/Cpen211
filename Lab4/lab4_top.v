`define s1 7'b0011001
`define s2 7'b1000000
`define s3 7'b0110000
`define s4 7'b0000000
`define s5 7'b0010010

module lab4_top(SW,KEY,HEX0);
  input [9:0] SW;
  input [3:0] KEY;
  output [6:0] HEX0;
  
  reg [6:0] HEX0;
  reg [6:0] present_state;
  
  //negedge looks for when KEY[0] drops from 1 to 0
	always @(negedge KEY[0]) begin
		//When SW[0] is flipped up the states transition properly
		if (SW[0] == 1) begin
			//resets back to state 1 if KEY[1] is pressed
			if (KEY[1] == 0) begin
				present_state = `s1;
			end else begin
				//transitions through the states
				case(present_state)
					`s1: present_state = `s2;
					`s2: present_state = `s3;
					`s3: present_state = `s4;
					`s4: present_state = `s5;
					`s5: present_state = `s1;
					default: present_state = 7'bxxxxxxx;
				endcase
			end
			HEX0 = present_state;
		//when SW[0] is flpiped down the states transition backwards
		end else begin
			if (KEY[1] == 0) begin
				present_state = `s1;
			end else begin
				//transitions through the states in reverse
				case(present_state)
					`s5: present_state = `s4;
					`s4: present_state = `s3;
					`s3: present_state = `s2;
					`s2: present_state = `s1;
					`s1: present_state = `s5;
					default: present_state = 7'bxxxxxxx;
				endcase
			end
			HEX0 = present_state;
		end
	end
endmodule

module lab4_top_tb();
	reg [9:0] SW ;
	reg [3:0] KEY ;
	wire [6:0] HEX0 ;
	reg err;
	
	lab4_top dut (SW, KEY, HEX0);
	
	initial begin
		KEY[0] = 1;
		#5;
		forever begin
			KEY[0] = 0;
			#5;
			KEY[0] = 1;
			#5;
		end
	end
	
	initial begin
		SW[0] = 1;
		KEY[1] = 0;
		err = 1'b0;
		#10;
		
		$display("checking reset");
		if(lab4_top_tb.dut.present_state !== `s1) begin
			$display("ERROR ** state is %b, expected %b", lab4_top_tb.dut.present_state, `s1 );
			err = 1'b1;
		end
		
		if(HEX0 !== `s1) begin
			$display("ERROR ** output is %b, expected %b", HEX0, `s1 );
			err = 1'b1;
		end
		
		KEY[1] = 1;
		
		$display("Checking s1 -> s2");
		#10;
		if(lab4_top_tb.dut.present_state !== `s2) begin
			$display("ERROR ** state is %b, expected %b", lab4_top_tb.dut.present_state, `s2 );
			err = 1'b1;
		end
		if(HEX0 !== `s2) begin
			$display("ERROR ** output is %b, expected %b", HEX0, `s2 );
			err = 1'b1;
		end
				
		$display("Checking s2 -> s3");
		#10;
		if(lab4_top_tb.dut.present_state !== `s3) begin
			$display("ERROR ** state is %b, expected %b", lab4_top_tb.dut.present_state, `s3 );
			err = 1'b1;
		end
		if(HEX0 !== `s3) begin
			$display("ERROR ** output is %b, expected %b", HEX0, `s3 );
			err = 1'b1;
		end
		
		$display("Checking s3 -> s4");
		#10;
		if(lab4_top_tb.dut.present_state !== `s4) begin
			$display("ERROR ** state is %b, expected %b", lab4_top_tb.dut.present_state, `s4 );
			err = 1'b1;
		end
		if(HEX0 !== `s4) begin
			$display("ERROR ** output is %b, expected %b", HEX0, `s4 );
			err = 1'b1;
		end
		
		$display("Checking s4 -> s5");
		#10;
		if(lab4_top_tb.dut.present_state !== `s5) begin
			$display("ERROR ** state is %b, expected %b", lab4_top_tb.dut.present_state, `s5 );
			err = 1'b1;
		end
		if(HEX0 !== `s5) begin
			$display("ERROR ** output is %b, expected %b", HEX0, `s5 );
			err = 1'b1;
		end
		
		$display("Checking s5 -> s1");
		#10;
		if(lab4_top_tb.dut.present_state !== `s1) begin
			$display("ERROR ** state is %b, expected %b", lab4_top_tb.dut.present_state, `s1 );
			err = 1'b1;
		end
		if(HEX0 !== `s1) begin
			$display("ERROR ** output is %b, expected %b", HEX0, `s1 );
			err = 1'b1;
		end
		
		SW[0] = 0;
		$display("Checking s1 -> s5");
		#10;
		if(lab4_top_tb.dut.present_state !== `s5) begin
			$display("ERROR ** state is %b, expected %b", lab4_top_tb.dut.present_state, `s5 );
			err = 1'b1;
		end
		if(HEX0 !== `s5) begin
			$display("ERROR ** output is %b, expected %b", HEX0, `s5 );
			err = 1'b1;
		end
		
		$display("Checking s5 -> s4");
		#10;
		if(lab4_top_tb.dut.present_state !== `s4) begin
			$display("ERROR ** state is %b, expected %b", lab4_top_tb.dut.present_state, `s4 );
			err = 1'b1;
		end
		if(HEX0 !== `s4) begin
			$display("ERROR ** output is %b, expected %b", HEX0, `s4 );
			err = 1'b1;
		end
		
		$display("Checking s4 -> s3");
		#10;
		if(lab4_top_tb.dut.present_state !== `s3) begin
			$display("ERROR ** state is %b, expected %b", lab4_top_tb.dut.present_state, `s3 );
			err = 1'b1;
		end
		if(HEX0 !== `s3) begin
			$display("ERROR ** output is %b, expected %b", HEX0, `s3 );
			err = 1'b1;
		end
		
		$display("Checking s3 -> s2");
		#10;
		if(lab4_top_tb.dut.present_state !== `s2) begin
			$display("ERROR ** state is %b, expected %b", lab4_top_tb.dut.present_state, `s2 );
			err = 1'b1;
		end
		if(HEX0 !== `s2) begin
			$display("ERROR ** output is %b, expected %b", HEX0, `s2 );
			err = 1'b1;
		end
		
		$display("Checking s2 -> s1");
		#10;
		if(lab4_top_tb.dut.present_state !== `s1) begin
			$display("ERROR ** state is %b, expected %b", lab4_top_tb.dut.present_state, `s1 );
			err = 1'b1;
		end
		if(HEX0 !== `s1) begin
			$display("ERROR ** output is %b, expected %b", HEX0, `s1 );
			err = 1'b1;
		end
		
		if(err == 1'b0) begin
			$display("PASSED ALL TESTS");
			$stop;
		end
	end
endmodule
