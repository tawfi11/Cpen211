`define reset 5'b00000
`define pause 5'b00001
`define decode 5'b00010
`define buffer1 5'b00011
`define halt 5'b00100
`define push1 5'b00101
`define buffer2 5'b00110
`define push2 5'b00111
`define updatesp 5'b01000
`define updatepc1 5'b01001
`define pop1 5'b01010
`define pop2 5'b01011
`define pop3 5'b01100
`define pop4 5'b01101
`define buffer3 5'b01110
`define sblt1 5'b01111
`define sblt2 5'b10000
`define sblt3 5'b10001
`define sblt4 5'b01010
`define sblt5 5'b10011
`define updatepc2 5'b10100

module top_module(clk,reset,done);
    input clk, reset;
    output reg done;
    reg [3:0] pc;
    reg [3:0] sp;
    reg [5:0] tmp;
    reg [3:0] addr;
    reg write;
    reg [5:0] tmp2;
    wire [5:0] data;
    reg [4:0] state;
    reg [1:0] op;
    reg [3:0] im4;
    reg [5:0] datain;

    RAM1P #(4,6) MEM (clk,addr,write,data);

    always @(posedge clk) begin
        datain = data;
        if(reset == 1) begin
            state = `reset;
        end else begin
            casex({state,op})
                {`reset,2'bxx}: state = `pause;
                {`pause, 2'bxx}: state = `decode;
                {`decode,2'bxx}: state = `buffer1;
                {`buffer1,2'b00}: state = `halt;
                {`buffer1,2'b01}: state = `push1;
                {`buffer1,2'b10}: state = `pop1;
                {`buffer1,2'b11}: state = `sblt1;
                {`halt,2'bxx}: state = `pause;
               // {`push1,2'bxx}: state = `buffer2;
                {`push1,2'bxx}: state = `push2;
                {`push2,2'bxx}: state = `updatesp;
                {`updatesp,2'bxx}: state = `updatepc1;
                {`pop1,2'bxx}: state = `pop2;
                {`pop2,2'bxx}: state = `pop3;
                {`pop3,2'bxx}: state = `pop4;
                {`pop4,2'bxx}: state = `buffer3;
                {`buffer3,2'bxx}: state = `updatepc1;
                {`sblt1,2'bxx}: state = `sblt2;
                {`sblt2,2'bxx}: state = `sblt3;
                {`sblt3,2'bxx}: state = `sblt4;
                {`sblt4,2'bxx}: state = `sblt5;
                {`sblt5,2'bxx}: if(tmp < 0) begin
                                    state = `updatepc2;
                                end else begin
                                    state = `updatepc1;
                                end
                {`updatepc1,2'bxx}: state = `pause;
                {`updatepc2,2'bxx}: state = `pause;
                default: state  = 5'bxxxxx;
            endcase
        end

        casex(state)
            `reset: {pc,done,sp} = {4'b0000,1'b0,4'b1111}; 
            `pause: {write,addr} = {1'b0,pc};
            `decode: {op,im4} = {datain[5:4],datain[3:0]};
            `push1: {write,addr} = {1'b0,im4};
            //`buffer2: tmp2 = datain;
            `push2: {write,addr} = {1'b1,sp};
            `updatesp: sp = sp - 4'b0001;
            `updatepc1: pc = pc + 4'b0001;
            `pop1: sp = sp + 1;
            `pop2: {write,addr} = {1'b0,sp};
            `pop3: tmp = datain;
            `pop4: {datain,addr,write} = {tmp,im4,1'b1};
            `buffer3: write = 0;
            `sblt1: {sp,write} = {sp + 4'b0001,1'b0};
            `sblt2: addr = sp;
            `sblt3: tmp2 = datain;
            `sblt4: tmp = tmp2 - tmp;
            `sblt5: {write,addr,datain} = {1'b1,sp,tmp};
            `updatepc2: pc = pc + im4;
            `halt: done = 1;
            default: write = 1'bx;
        endcase

    end
endmodule