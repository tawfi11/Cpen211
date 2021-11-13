module fab(clk, reset, s, in, op, out, done);
    input clk, reset, s;
    input [7:0] in;
    input [1:0] op;
    output [7:0] out;
    output done;

    `define INIT 2'b00
    `define FIB 2'b01
    `define FACT 2'b10
    `define WAIT 2'b11
    `define DONTCARE 2'bxx
    
    reg [7:0] A,B,C,sum,reg_out;
    reg [1:0] present_state;
    reg reg_done;
    assign done = reg_done;
    assign out = reg_out;
    //sum = A + B;

    always @(posedge clk) begin
        if(reset) begin
            present_state = `WAIT;
        end
        case ({present_state,op,s})
            {`WAIT,`INIT,1'b1} : begin
                {A,B,C,present_state,reg_done} = {8'b0000_0000,8'b000_0001,in,`INIT,1'b0};
                reg_out = B;
            end
            {`WAIT,`FIB,1'b1} : begin
                {present_state,reg_done} = {`WAIT,1'b0};
                sum = A + B;
                if(C != 8'b0000_0000)begin
                    A <= B;
                    B = sum;
                    C = C - 8'b000_0001;
                end
                if(C == 8'b0000_0000)begin
                    reg_out = B;
                    present_state = `FIB;
                end
                
            end

            {`WAIT,`FACT,1'b1} : begin
                {present_state,reg_done} = {`WAIT,1'b0};
                if(C != 8'b0000_0000)begin
                    B = B * C;
                    C = C - 8'b0000_0001;
                end
                if(C == 8'b0000_0000)begin
                    reg_out = B;
                    present_state = `FACT;
                end
                
            end

            {`FIB,`FIB,1'b1} : {present_state,reg_done} = {`WAIT,1'b1};
            {`FACT,`FACT,1'b1} : {present_state,reg_done} = {`WAIT,1'b1};
            {`INIT,`INIT,1'b1} : {present_state,reg_done} = {`WAIT,1'b1};
            

            default: {reg_done,present_state} = {1'b0,`WAIT};
        endcase
    end

endmodule

module calc(clk, reset, s, in, op, out, ovf, done);
    input clk,reset,s;
    input [7:0] in;
    input [1:0] op;
    output [7:0] out;
    output ovf,done;

    reg [7:0] B;
    reg [1:0] present_state;
    reg reg_out,reg_done,reg_ovf;

    `define CLEAR 2'b00
    `define ADD 2'b01
    `define SHIFT 2'b10
    `define WAIT 2'b11
    `define HIGH 1'b1
    `define LOW 1'b0

    assign out = B;
    assign done = reg_done;
    assign ovf = reg_ovf;

    always @(posedge clk) begin
        if(reset)
        present_state = `WAIT;
        case ({present_state,op,s})

            {`WAIT,`CLEAR,1'b1} : {B,reg_done,present_state} = {8'b0000_0000,`LOW,`CLEAR};

            {`WAIT,`ADD,1'b1} : begin
                {present_state,reg_done} = {`ADD,`LOW};
                if(B + in > 8'b1111_1111) begin
                    reg_ovf = `HIGH;
                end
                reg_ovf = 1'b0;
                B = B + in;
            end

            {`WAIT,`SHIFT,1'b1} : begin
                {present_state,reg_done} = {`SHIFT,`LOW};
                B = B >> in;
            end

            {`CLEAR,`CLEAR,1'b1} : {reg_done,present_state} = {1'b1,`WAIT};
            {`ADD,`ADD,1'b1} : {reg_done,present_state} = {1'b1,`WAIT};
            {`SHIFT,`SHIFT,1'b1} : {reg_done,present_state} = {1'b1,`WAIT};

            default: {reg_done,present_state} = {1'b0,`WAIT};
        endcase
    end

 
endmodule