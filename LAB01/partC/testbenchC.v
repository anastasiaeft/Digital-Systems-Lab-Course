`timescale 1ns / 1ps

module merosC_tb;

    reg clock, reset, button;
    //reg [3:0] addr;
    //wire [3:0] digits [0:3];

    wire an3, an2, an1, an0;
    wire a, b, c, d, e, f, g, dp;


    //MessageRotator msg_digits(.clk(clock), .reset(reset), .button(button), .digits1(digits1), .digits2(digits2), .digits3(digits3), .digits4(digits4));
    FourDigitLEDdriver dut(.clk(clock), .reset(reset), .button(button), .an3(an3), .an2(an2), .an1(an1), .an0(an0), .a(a), .b(b), .c(c), .d(d), .e(e), .f(f), .g(g), .dp(dp));

    always begin
        #10
        clock <= ~clock;
    end

    initial begin
        
        $dumpfile("merosC_tb.vcd");  // το VCD α�?χείο
        $dumpvars(0, merosC_tb); 

        //$monitor("time=%0t | button=%b | digits=%b %b %b %b", $time, button, digits1, digits2, digits3, digits4);

        clock = 0;
        reset = 0;
        button = 0;
        #10
        reset = 1;
        #30
        reset = 0;

        #6000
        button = 1;

        #5
        button = 0;
        #5
        button = 1;
        #5
        button = 0;
        #5
        button = 1;
            
        #1000
        button = 0;

        #5
        button = 1;
        #5
        button = 0;
        #5
        button = 1;
        #5
        button = 0;

        
    

        #1000 
        $finish;

    end

endmodule