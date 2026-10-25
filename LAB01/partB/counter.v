`timescale 1ns/1ps
module counter(clk, reset, state);
    input clk, reset;
    output reg [3:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset == 1) state  <= 4'b1111;
        else state <= state - 1;
    end

endmodule