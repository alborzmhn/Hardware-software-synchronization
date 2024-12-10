`timescale 1ps / 1ps
module TB;

    reg clk = 0, rst = 0, reset = 0, start = 0;
    reg [15:0] inp1;
    reg [15:0] inp2;
    wire done;
    wire [15:0] out;

	toplevel tl(clk, rst, reset, start, inp1, inp2, done, out);

    always #5 clk = ~clk; 

    initial begin
        reset = 1;
        rst = 1;
        clk = 0;
        start = 0;
        inp1 = 16'b0;
        inp2 = 16'b0;
        
        #20
        reset = 0;

        #10 rst = 0;
        inp1 = 16'h2000; 
        inp2 = 16'h2000; 
        
        #20;
        start = 1;
        #10 start = 0;

        wait(done);

        #10 rst = 0;
        inp1 = 16'h8000; 
        inp2 = 16'h8000; 
        
        #20;
        start = 1;
        #10 start = 0;

        wait(done);
        $stop;
    end
endmodule
