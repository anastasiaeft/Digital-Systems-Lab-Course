`timescale 1ns/1ps
module KathodeDrivingCD(count, digit1, digit2, digit3, digit4, char);
    input [3:0] count, digit1, digit2, digit3, digit4;
    output reg [3:0] char;

    always @(count) begin 
         case (count)
                4'b0000: char = digit1;
                4'b1101: char = digit1;
                4'b1110: char = digit1;
                4'b1111: char = digit1;
                4'b1001: char = digit2;
                4'b1010: char = digit2;
                4'b1011: char = digit2;
                4'b1100: char = digit2;
                4'b1000: char = digit3;
                4'b0111: char = digit3;
                4'b0110: char = digit3;
                4'b0101: char = digit3;
                4'b0100: char = digit4;
                4'b0011: char = digit4;
                4'b0010: char = digit4;
                4'b0001: char = digit4;

                // Default
                default: char = 4'b0000;
            endcase
    end
endmodule