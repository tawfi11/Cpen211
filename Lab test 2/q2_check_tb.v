module q2_check_tb;
  reg clk, reset, s, err;
  reg [7:0] in;
  reg [1:0] op;
  wire [15:0] out;
  wire done;

  fun DUT(clk, reset, s, in, op, out, done);

  initial forever begin
    clk=0; #5;
    clk=1; #5; 
  end

  initial begin
    err = 0; 
    s = 0;
    in = 8'b0;
    reset = 1; 
    #10;
    reset = 0;
    op = 2'b00; 
    s = 1'b1;
    #10;
    s = 1'b0;
    @(posedge done);
    if (out !== 16'b0) begin
      $display("ERROR ** CLEAR failed.");
      err = 1;
      $stop;
    end

    in = 8'd2; 
    op = 2'b01; 
    s = 1'b1;
    #10;
    s = 1'b0;
    @(posedge done);
    if (DUT.A !== 16'd2) begin
      $display("ERROR ** LOADA failed.");
      err = 1;
      $stop;
    end

    in = 8'd3; 
    op = 2'b10; 
    s = 1'b1;
    #10;
    s = 1'b0;
    @(posedge done);
    if (DUT.B !== 8'd3) begin
      $display("ERROR ** LOADB failed.");
      err = 1;
      $stop;
    end

    in = 8'd0; 
    op = 2'b11; 
    s = 1'b1;
    #10;
    s = 1'b0;
    @(posedge done);
    if (out !== 15'd2) begin
      $display("ERROR ** STEP failed (out wrong).");
      err = 1;
      $stop;
    end
    if (DUT.A !== 15'd4) begin
      $display("ERROR ** STEP failed (A wrong).");
      err = 1;
      $stop;
    end
    if (DUT.B !== 8'd1) begin
      $display("ERROR ** STEP failed (B wrong).");
      err = 1;
      $stop;
    end

    s = 1'b1; #10; s = 1'b0;
    @(posedge done);
    if (out !== 15'd6) begin
      $display("ERROR ** STEP failed.");
      err = 1;
      $stop;
    end
    if (DUT.A !== 15'd8) begin
      $display("ERROR ** STEP failed (A wrong).");
      err = 1;
      $stop;
    end
    if (DUT.B !== 8'd0) begin
      $display("ERROR ** STEP failed (B wrong).");
      err = 1;
      $stop;
    end

    if (~err) $display("INTERFACE OK");
    $stop;
  end
endmodule
