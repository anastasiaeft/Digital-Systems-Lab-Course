//testbench
`include "LEDdecoder.v"
`timescale 1ns/1ps

module decoder_tb;
    integer i;

    reg [3:0] char;
    wire [6:0] LED;

    LEDdecoder dut(char,LED);
    
    initial begin
        for(i = 0; i < 16; i = i + 1) begin
            char = i;
            #1
            $display("char=%h|LED = %b|Kathodes open: a = %b,b = %b,c = %b,d = %b,e = %b,f = %b,g = %b", char,LED ,LED[6],LED[5],LED[4],LED[3],LED[2],LED[1],LED[0]); 
        end
    end
    
endmodule