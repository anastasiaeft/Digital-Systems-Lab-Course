`timescale 1ns/1ps
module pong (
    input clk, // pixel clock //
    input rst,
    input up1,
    input down1,
    input up2,
    input down2,
    input [3:0] paddle_speed,
    input [3:0] puck_speed,
    input new_game,
    input new_frame,
    input [9:0] hcount,
    output reg [9:0] p1_paddle_x,
    output reg [9:0] p1_paddle_y,
    output reg [9:0] p2_paddle_x,
    output reg [9:0] p2_paddle_y,
    output reg [9:0] puck_x,
    output reg [9:0] puck_y
    );
    // Paddle parameters
    parameter PADDLE_WIDTH = 11'd10;
    parameter PADDLE_HEIGHT = 10'd100;
    // // Puck parameters
    parameter PUCK_WIDTH = 11'd32;
    parameter PUCK_HEIGHT = 10'd32;
    //active drawing area
    parameter H_ACTIVE_END   = 10'd639; 
    parameter V_ACTIVE_END   = 10'd479; 

    localparam X_MIDDLE = H_ACTIVE_END / 2;
    localparam Y_MIDDLE = V_ACTIVE_END / 2;

    reg right_dir; // 1 for right, 0 for left
    reg down_dir;  // 1 for down, 0 for up
    reg game_over; 

    // Paddle movement (p1)
    // dont want to have to do it but in order for this to work i might need the paddles to move even on the game over state for multiplayer
    always @(posedge clk or posedge rst) begin
        if (rst || new_game ) begin
            p1_paddle_x <= 10'd0;
            p1_paddle_y <= Y_MIDDLE - (PADDLE_HEIGHT / 2);
        end
        else if (new_frame && !game_over) begin //paddles dont move on multiplayer with keyboard bc the game reaches game over state before it can receive data for current dimentions(20x20)
            if (up1 && (p1_paddle_y > paddle_speed))begin
                p1_paddle_y <= p1_paddle_y - paddle_speed;
            end
            else if (up1 && (p1_paddle_y <= paddle_speed)) begin
                p1_paddle_y <= 0;
            end
            else if (down1 && ((p1_paddle_y + PADDLE_HEIGHT) < (V_ACTIVE_END - paddle_speed))) begin
                p1_paddle_y <= p1_paddle_y + paddle_speed;
            end
            else if (down1 && ((p1_paddle_y + PADDLE_HEIGHT) >= (V_ACTIVE_END - paddle_speed))) begin
                p1_paddle_y <= V_ACTIVE_END - PADDLE_HEIGHT;
            end
        end
    end

    // Paddle movement (p2)
        // Paddle movement
    always @(posedge clk or posedge rst) begin
        if (rst || new_game ) begin
            p2_paddle_x <= H_ACTIVE_END - PADDLE_WIDTH;
            p2_paddle_y <= Y_MIDDLE - (PADDLE_HEIGHT / 2);
        end
        else if (new_frame && !game_over) begin  //paddles dont move on multiplayer with keyboard bc the game reaches game over state before it can receive data for current dimentions
            if (up2 && (p2_paddle_y > paddle_speed))begin
                p2_paddle_y <= p2_paddle_y - paddle_speed;
            end
            else if (up2 && (p2_paddle_y <= paddle_speed)) begin
                p2_paddle_y <= 0;
            end
            else if (down2 && ((p2_paddle_y + PADDLE_HEIGHT) < (V_ACTIVE_END - paddle_speed))) begin
                p2_paddle_y <= p2_paddle_y + paddle_speed;
            end
            else if (down2 && ((p2_paddle_y + PADDLE_HEIGHT) >= (V_ACTIVE_END - paddle_speed))) begin
                p2_paddle_y <= V_ACTIVE_END - PADDLE_HEIGHT;
            end
        end
    end

    // Puck movement
    always @(posedge clk or posedge rst) begin
        if (rst ) begin
            puck_x <= X_MIDDLE - (PUCK_WIDTH / 2);
            puck_y <= Y_MIDDLE - (PUCK_HEIGHT / 2);
            game_over <= 1'b0;

            //initialize random direction based on hcount and vcount
            right_dir <= 1'b0;
            down_dir <= 1'b0;
        end
        else if (new_game) begin
            puck_x <= X_MIDDLE - (PUCK_WIDTH / 2);
            puck_y <= Y_MIDDLE - (PUCK_HEIGHT / 2);
            game_over <= 1'b0;

            //initialize random direction based on hcount and vcount
            right_dir <= hcount[0];
            down_dir <= hcount[1];
        end
        else if (new_frame && !game_over) begin
            if (right_dir) begin
                if (puck_x + PUCK_WIDTH + puck_speed >= H_ACTIVE_END - PADDLE_WIDTH) begin
                    if (((puck_y < p2_paddle_y) && (puck_y + PUCK_HEIGHT >= p2_paddle_y)) || ((puck_y + PUCK_HEIGHT > p2_paddle_y + PADDLE_HEIGHT) && (puck_y < p2_paddle_y + PADDLE_HEIGHT)) || ((puck_y > p2_paddle_y) && (puck_y + PUCK_HEIGHT < p2_paddle_y + PADDLE_HEIGHT))) begin
                        right_dir <= 1'b0;
                        puck_x <= H_ACTIVE_END - PADDLE_WIDTH - PUCK_WIDTH;
                    end
                    else begin
                        puck_x <= H_ACTIVE_END - PADDLE_WIDTH - PUCK_WIDTH;
                        game_over <= 1'b1;
                    end
                end
                else begin
                    puck_x <= puck_x + puck_speed;
                end
            end
            else begin
                if (puck_x <= puck_speed + PADDLE_WIDTH) begin
                    if (((puck_y < p1_paddle_y) && (puck_y + PUCK_HEIGHT >= p1_paddle_y)) || ((puck_y + PUCK_HEIGHT > p1_paddle_y + PADDLE_HEIGHT) && (puck_y < p1_paddle_y + PADDLE_HEIGHT)) || ((puck_y > p1_paddle_y) && (puck_y + PUCK_HEIGHT < p1_paddle_y + PADDLE_HEIGHT))) begin
                        right_dir <= 1'b1;
                        puck_x <= PADDLE_WIDTH;
                    end
                    else begin
                        puck_x <= PADDLE_WIDTH;
                        game_over <= 1'b1;
                    end
                end
                else begin
                    puck_x <= puck_x - puck_speed;
                end
            end

            if (down_dir) begin
                if (puck_y + PUCK_HEIGHT + puck_speed >= V_ACTIVE_END) begin
                    puck_y <= V_ACTIVE_END - PUCK_HEIGHT;
                    down_dir <= 1'b0;
                end
                else begin
                    puck_y <= puck_y + puck_speed;
                end
            end
            else begin
                if (puck_y <= puck_speed) begin
                    puck_y <= 0;
                    down_dir <= 1'b1;
                end
                else begin
                    puck_y <= puck_y - puck_speed;
                end
            end
        end 
    end


endmodule