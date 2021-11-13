`define A 5'b00001 //wait
`define B 5'b00010 //CLEAR
`define C 5'b00100 //LoadA
`define D 5'b01000 //LoadB
`define E 5'b10000 //step
module fun(clk, reset, s, in, op, out, done);
    input clk, reset, s;
    input [7:0] in;
    input [1:0] op;
    output [15:0] out;
    output done;
    reg [15:0] A;
    reg [7:0] B;

   // FSM state_machine (.clk(clk), .reset(reset), .s(s), .in(in), .op(op), .out(out), .done(done), .A(A), .B(B));
    reg [4:0] present_state;
    reg [15:0] out;
    reg done;
    reg [4:0] next;

    //counter count (.present_state(out),.clk(clk), .reset(reset), .s(s), .op(op));

    vDFF #(5) flipflop(.clk(clk), .present_state(present_state), .next(next));


    always @(posedge clk) begin
        if(reset == 1'b1) begin
            present_state = `A;
        end else begin
        casex({s,present_state})
            {1'b1,`A}: if(op == 2'b00) begin
                            next = `B;
                        end else if(op == 2'b01) begin
                            next = `C;
                        end else if (op == 2'b10) begin
                            next = `D;
                        end else if(op == 2'b11) begin
                            next = `E;
                        end else begin
                            next = `A;
                        end
            {1'b0,`A}: next = `A;
            {1'bx,`B}: next = `A;
            {1'bx,`C}: next = `A;
            {1'bx,`D}: next = `A;
            {1'bx,`E}: next = `A;
            default: present_state = {5{1'bx}};
        endcase
        end
        
        done = 1'b0;
        case(next)
        `A: done = 1'b1;
        `B: out = {16{1'b0}};
        `C: A = {8'b0, in};
        `D: B = in;
        default: done = 1'bx;
        endcase
        if(next == `E && B[0] != 1'b1) begin
            A = A << 1;
            A[0] = 0;
            B = B >> 1;
            B[7] = 0;
        end else begin
            out = out + A;
        end
    end

endmodule

/*module counter(clk, reset, s, op, out);
    input clk, reset, s;
    input [1:0] op;
    output [4:0] out;
    reg [4:0] present_state;

    fun haha(.clk(clk), .reset(reset), .s(s), .in(in), .op(op), .out(out), .done(done));

    vDFF #(5) flipflop(.clk(clk), .present_state(in), .out(out));

    always @(*) begin
        if(reset == 1'b1) begin
            present_state = `A;
        end else begin
        casex({s,present_state})
            {1'b1,`A}: if(op == 2'b00) begin
                            present_state = `B;
                        end else if(op == 2'b01) begin
                            present_state = `C;
                        end else if (op == 2'b10) begin
                            present_state = `D;
                        end else if(op == 2'b11) begin
                            present_state = `E;
                        end else begin
                            present_state = `A;
                        end
            {1'b0,`A}: present_state = `A;
            {1'bx,`B}: present_state = `A;
            {1'bx,`C}: present_state = `A;
            {1'bx,`D}: present_state = `A;
            {1'bx,`E}: present_state = `A;
            default: present_state = {5{1'bx}};
        endcase
        end
    end
endmodule*/

module vDFF(clk, present_state, next) ;
  parameter n = 1;  // width
  input clk ;
  input [n-1:0] present_state ;
  output [n-1:0] next ;
  reg [n-1:0] next ;

  always @(posedge clk)
    next = present_state ;
endmodule 

/*module FSM(clk, reset, s, in, op, out, done, A, B);
    input clk, reset, s;
    input [7:0] in;
    input [1:0] op;
    output [15:0] out;
    output done;
    output reg [15:0] A;
    output reg [7:0] B;

    reg [4:0] present_state;
    reg [15:0] out;
    reg done;

    counter state (.present_state(out),.clk(clk), .reset(reset), .s(s), .op(op));

    always @(posedge clk) begin
        done = 1'b0;
        case(present_state)
        `A: done = 1'b1;
        `B: out = {16{1'b0}};
        `C: A = {8'b0, in};
        `D: B = in;
        default: done = 1'bx;
        endcase
        if(present_state == `E && B[0] != 1'b1) begin
            A = A << 1;
            A[0] = 0;
            B = B >> 1;
            B[7] = 0;
        end else begin
            out = out + A;
        end
    end
endmodule*/

module fun_tb();
    reg clk, reset, s;
    reg [7:0] in;
    reg [1:0] op;
    wire [15:0] out;
    wire done;

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
        reset = 1;
        #10;
        reset = 0;
        op = 2'b00;
        s = 1;
        in = 16'b0;
        #20;
        $stop;
    end
endmodule