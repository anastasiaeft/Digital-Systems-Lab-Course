`timescale 1ns/1ps
module LEDdecoder(char, LED); 

    input [3:0] char; 
    output reg [6:0] LED; 
    
    always @(char) begin
        case (char) 
            
            4'b0000 : LED = 7'b0000001;
            4'b0001 : LED = 7'b1001111;
            4'b0010 : LED = 7'b0010010;
            4'b0011 : LED = 7'b0000110;
            4'b0100 : LED = 7'b1001100;
            4'b0101 : LED = 7'b0100100;
            4'b0110 : LED = 7'b0100000;
            4'b0111 : LED = 7'b0001111;
            4'b1000 : LED = 7'b0000000;
            4'b1001 : LED = 7'b0000100;
            4'b1010 : LED = 7'b0001000;
            4'b1011 : LED = 7'b1100000;
            4'b1100 : LED = 7'b0110001;
            4'b1101 : LED = 7'b1000010;
            4'b1110 : LED = 7'b0110000;
            4'b1111 : LED = 7'b0111000;

            default : LED = 7'b0000000;
        endcase
    end
    
endmodule