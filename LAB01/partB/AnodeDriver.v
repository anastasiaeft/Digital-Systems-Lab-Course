`timescale 1ns/1ps
module AnodeDriving(count, an3, an2, an1, an0);
    input [3:0] count;
    output reg an3, an2, an1, an0;

    always @(count) begin
        case (count)
        4'b1110 : begin an3 = 0; an2 = 1; an1 = 1; an0 = 1; end
        4'b1010 : begin an3 = 1; an2 = 0; an1 = 1; an0 = 1; end
        4'b0110 : begin an3 = 1; an2 = 1; an1 = 0; an0 = 1; end
        4'b0010 : begin an3 = 1; an2 = 1; an1 = 1; an0 = 0; end

        default : begin an3 = 1; an2 = 1; an1 = 1; an0 = 1; end
        endcase
    end

endmodule