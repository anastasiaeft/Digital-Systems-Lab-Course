`timescale 1ns/1ps
module pong (
    input clk, // pixel clock //
    input rst,
    input up,
    input down,
    input [3:0] paddle_speed,
    input new_game,
    input new_frame,
    input [9:0] hcount,
    input [9:0] vcount,
    output reg [9:0] paddle_x,
    output reg [9:0] paddle_y
    );
    // Paddle parameters
    parameter PADDLE_WIDTH = 11'd10;
    parameter PADDLE_HEIGHT = 10'd100;
    // // Puck parameters
    // parameter PUCK_WIDTH = 11'd10;
    // parameter PUCK_HEIGHT = 10'd10;
    // active drawing area
    parameter H_ACTIVE_END   = 10'd639; 
    parameter V_ACTIVE_END   = 10'd479; 

    localparam Y_MIDDLE = V_ACTIVE_END / 2;

    // Paddle movement
    always @(posedge clk or posedge rst) begin
        if (rst || new_game) begin
            paddle_x <= 10'd0;
            paddle_y <= Y_MIDDLE;
        end
        else if (new_frame) begin
            if (up && (paddle_y > paddle_speed))begin
                paddle_y <= paddle_y - paddle_speed;
            end
            else if (up && (paddle_y <= paddle_speed)) begin
                paddle_y <= 0;
            end
            else if (down && ((paddle_y + PADDLE_HEIGHT) < (V_ACTIVE_END - paddle_speed))) begin
                paddle_y <= paddle_y + paddle_speed;
            end
            else if (down && ((paddle_y + PADDLE_HEIGHT) >= (V_ACTIVE_END - paddle_speed))) begin
                paddle_y <= V_ACTIVE_END - PADDLE_HEIGHT;
            end
        end
    end


endmodule