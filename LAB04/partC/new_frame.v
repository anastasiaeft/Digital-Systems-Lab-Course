`timescale 1ns/1ps
module new_frame(clk, rst, hcount, vcount, new_frame, LED);

    input clk, rst;
    input [9:0] hcount, vcount;
    output reg new_frame;
    output reg LED;
    
    reg [5:0] count_frame;

    parameter H_ACTIVE_END   = 10'd639;   
    parameter V_ACTIVE_END   = 10'd479;

    always @(posedge clk or posedge rst) begin
        if (rst)
            new_frame <= 1'b0;
        else if (hcount == H_ACTIVE_END && vcount == V_ACTIVE_END)
            new_frame <= 1'b1;
        else
            new_frame <= 1'b0;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            LED <= 1'b0;
            count_frame <= 6'd0;
        end
        else if (count_frame == 6'd59) begin
            LED <= 1'b1;
            count_frame <= 6'd0;
        end
        else begin
            LED <= 1'b0;
            if (new_frame) begin
                count_frame <= count_frame + 6'd1;
            end
        end 
    end

endmodule