`timescale 1ns / 1ps

module merosB_tb;

    reg clock, reset;
    wire an3, an2, an1, an0;
    wire a, b, c, d, e, f, g, dp;

    FourDigitLEDdriver dut(.clk(clock), .reset(reset), .an3(an3), .an2(an2), .an1(an1), .an0(an0), .a(a), .b(b), .c(c), .d(d), .e(e), .f(f), .g(g), .dp(dp));

    always begin
        #10
        clock <= ~clock;
    end

    initial begin
        clock = 0;
        reset = 0;
        #10
        reset = 1;
        #90
        reset = 0;
        #8259 reset=1;
        #100 reset=0;
        #10000 $finish;
    end

endmodule