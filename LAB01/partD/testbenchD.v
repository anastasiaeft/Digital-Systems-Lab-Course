`timescale 1ns/1ps
module merosD_tb;

    reg clock, reset;
    //wire [3:0] digits1, digits2, digits3, digits4;
    wire an3, an2, an1, an0;
    wire a, b, c, d, e, f, g, dp;


    //MessageRotator_D counter_rot(.clk(clock), .reset(reset), .digits1(digits1), .digits2(digits2), .digits3(digits3), .digits4(digits4));
    FourDigitLEDdriver dut(.clk(clock), .reset(reset), .button(1'b0), .an3(an3), .an2(an2), .an1(an1), .an0(an0), .a(a), .b(b), .c(c), .d(d), .e(e), .f(f), .g(g), .dp(dp));

    always begin
        #10
        clock <= ~clock;
    end

    initial begin
        
        $dumpfile("merosD_tb.vcd");  // το VCD α�?χείο
        $dumpvars(0, merosD_tb); 

        //$monitor("time=%0t | digits=%b %b %b %b", $time, digits1, digits2, digits3, digits4);

        clock = 0;
        reset = 0;
   
        #100
        reset = 1;
        #30
        reset = 0;
    end

endmodule