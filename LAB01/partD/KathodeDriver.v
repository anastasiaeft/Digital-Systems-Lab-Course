`timescale 1ns/1ps
module KathodeDriving(count, char);
    input [3:0] count;
    output reg [3:0] char;

    always @(count) begin
        case (count)
            4'b0000: char = 4'b1100;
            4'b0001: char = 4'b1110;
            4'b0010: char = 4'b1110;
            4'b0011: char = 4'b1110;
            4'b0100: char = 4'b1110;
            4'b0101: char = 4'b1111;
            4'b0110: char = 4'b1111;
            4'b0111: char = 4'b1111;
            4'b1000: char = 4'b1111;
            4'b1001: char = 4'b1010;
            4'b1010: char = 4'b1010;
            4'b1011: char = 4'b1010;
            4'b1100: char = 4'b1010;
            4'b1101: char = 4'b1100;
            4'b1110: char = 4'b1100;
            4'b1111: char = 4'b1100;
            default: char = 4'b0000;
        endcase
    end

endmodule

