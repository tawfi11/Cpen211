module q1_tb();
    reg [1:0] in;
    reg clk,reset;
    wire [1:0] out;

    top_module dut (.in(in), .clk(clk), .reset(reset), .out (out));

    initial begin
        clk = 1;
        #5;
        forever begin
            clk = 0;
            #5;
            clk = 1;
            #5;
        end
    end

    initial begin  
        reset = 1;
        #10;
        if(out != 2'b10) begin
            $stop;
        end

        in = 2'b00;

        #10;

        if(out != 2'b10) begin
            $stop;
        end

        in = 2'b01;

        if(out!= 2'b10) begin
            $stop;
        end

        #10;

        $stop;
    end
endmodule

        