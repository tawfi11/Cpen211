`define A 5'b00001
`define B 5'b00001
`define C 5'b00100
`define D 5'b01000
`define E 5'b10000
module top_module(clk,reset,in,out);
    input clk, reset;
    input [1:0] in;
    output [1:0] out;

    reg [4:0] present_state;
    reg [1:0] out;

    always @(posedge clk) begin
        if(reset == 1'b1) begin
            present_state = `A;
        end else begin
        casex (present_state)
            `A: if(in == 2'b11) begin
                    present_state = `B;
                end else if (in == 2'b00) begin
                    present_state = `D;
                end else begin
                    present_state = `A;
                end
            `B: present_state = `A;
            `C: if(in == 2'b01) begin
                    present_state = `E;
                end else if(in == 2'b10) begin
                    present_state = `B;
                end else begin
                    present_state = `C;
                end
            `D: if(in == 2'b01) begin  
                    present_state = `C;
                end else begin
                    present_state = `D;
                end
            `E: present_state = `D;
            default: present_state = 5'bxxxxx;
        endcase
        end

        casex(present_state)
            `A: out = 2'b10;
            `B: out = 2'b00;
            `C: out = 2'b10;
            `D: out = 2'b10;
            `E: out = 2'b00;
            default: out = 2'bxx;
        endcase
    end
endmodule 