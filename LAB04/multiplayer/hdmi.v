`timescale 1ns/1ps
module hdmi_controller(
    input clk,
    input rst,
    input [3:0] paddle_speed,
    input [3:0] puck_speed,
    input new_game,
    input RxD,
    output [2:0] hdmi_tx_p,
    output [2:0] hdmi_tx_n,
    output hdmi_clk_p,
    output hdmi_clk_n,
    output led,
    output Rx_FERROR,
    output Rx_PERROR,
    output Rx_VALID
    );

    wire [9:0] tmds_10b [2:0];  //output of TMDS, 10 bits for each color
    wire [2:0] tmds_signal;     //output of SERIALIZER, 1 bit for each color
    wire [7:0] red;
    wire [7:0] green;
    wire [7:0] blue;

    wire activedraw, hsync, vsync;
    wire [9:0] hcount;
    wire [9:0] vcount;
    wire [2:0] rgb;
    wire clk_pixel, clk_5x;
    wire [7:0] p1_paddle_red, p1_paddle_green, p1_paddle_blue;
    wire [7:0] p2_paddle_red, p2_paddle_green, p2_paddle_blue;
    wire [7:0] puck_red, puck_green, puck_blue;
    wire new_frame;
    wire [9:0] puck_x;
    wire [9:0] puck_y;
    wire Rx_EN;
    wire [2:0] baud_select;
    wire [7:0] Rx_DATA;
    wire up1, down1, up2, down2;
    wire [9:0] p1_paddle_x;
    wire [9:0] p1_paddle_y;
    wire [9:0] p2_paddle_x;
    wire [9:0] p2_paddle_y;

    //need this to fix timing errors between different clock domains
    wire up1_pix, down1_pix, up2_pix, down2_pix;


    parameter PADDLE_WIDTH = 11'd010;
    parameter PADDLE_HEIGHT = 10'd100;
    parameter PUCK_WIDTH = 11'd32;
    parameter PUCK_HEIGHT = 10'd32;
    parameter Hor_ACTIVE_END   = 10'd639;   
    parameter Hor_BLANKING_END = 10'd655;   
    parameter Hor_SYNC_END     = 10'd751;   
    parameter Hor_TOTAL        = 10'd799;   
    parameter Ver_BLANKING_END = 10'd489;   
    parameter Ver_SYNC_END   = 10'd491;   
    parameter Ver_ACTIVE_END   = 10'd479;   
    parameter Ver_TOTAL        = 10'd524;   
 

    new_frame #(.H_ACTIVE_END   (Hor_ACTIVE_END), .V_ACTIVE_END   (Ver_ACTIVE_END)) nf_inst(.clk(clk_pixel), .rst(rst), .hcount(hcount), .vcount(vcount), .new_frame(new_frame), .LED(led));
    timing_and_color_driver inst_clk(.clk(clk), .rst(rst), .clk_pix(clk_pixel), .clk_5x(clk_5x));
    fsm_hdmi #(
    .H_ACTIVE_END   (Hor_ACTIVE_END),
    .H_BLANKING_END (Hor_BLANKING_END),
    .H_SYNC_END     (Hor_SYNC_END),
    .H_TOTAL        (Hor_TOTAL),
    .V_BLANKING_END (Ver_BLANKING_END),
    .V_SYNC_END   (Ver_SYNC_END),
    .V_ACTIVE_END   (Ver_ACTIVE_END),
    .V_TOTAL        (Ver_TOTAL)
    ) fsm_inst (
    .clk   (clk_pixel),
    .reset (rst),
    .activedraw (activedraw),
    .hsync (hsync),
    .vsync (vsync),
    .hcount (hcount),
    .vcount (vcount)
    );

    assign Rx_EN = 1'b1;
    assign baud_select = 3'b011; //9600 baud rate

    uart_receiver uart_rx_inst(.reset(rst), .clk(clk), .Rx_DATA(Rx_DATA), .baud_select(baud_select), .Rx_EN(Rx_EN), .RxD(RxD), .Rx_FERROR(Rx_FERROR), .Rx_PERROR(Rx_PERROR), .Rx_VALID(Rx_VALID));

    PlayerSignals_driver psd_inst(.clk(clk), .reset(rst), .Rx_DATA(Rx_DATA), .Rx_VALID(Rx_VALID), .up1(up1), .down1(down1), .up2(up2), .down2(down2));

    pong #(
    .PADDLE_WIDTH (PADDLE_WIDTH), 
    .PADDLE_HEIGHT (PADDLE_HEIGHT),
    .H_ACTIVE_END (Hor_ACTIVE_END),
    .V_ACTIVE_END (Ver_ACTIVE_END),
    .PUCK_WIDTH (PUCK_WIDTH),
    .PUCK_HEIGHT (PUCK_HEIGHT)
    ) pong_inst(
        .clk(clk_pixel),
        .rst(rst),
        .up1(up1_pix),
        .down1(down1_pix),
        .up2(up2_pix),
        .down2(down2_pix),
        .paddle_speed(paddle_speed),
        .puck_speed(puck_speed),
        .new_game(new_game),
        .new_frame(new_frame),
        .hcount(hcount),
        .p1_paddle_x(p1_paddle_x),
        .p1_paddle_y(p1_paddle_y),
        .p2_paddle_x(p2_paddle_x),
        .p2_paddle_y(p2_paddle_y),
        .puck_x(puck_x),
        .puck_y(puck_y)
    );

    block_sprite #(.SPRITE_WIDTH (PADDLE_WIDTH), .SPRITE_HEIGHT (PADDLE_HEIGHT))p1_paddle_inst(
        .hcount_in(hcount),
        .vcount_in(vcount),
        .sprite_x(p1_paddle_x),
        .sprite_y(p1_paddle_y),
        .red_out(p1_paddle_red),
        .green_out(p1_paddle_green),
        .blue_out(p1_paddle_blue)
    );

        block_sprite #(.SPRITE_WIDTH (PADDLE_WIDTH), .SPRITE_HEIGHT (PADDLE_HEIGHT))p2_paddle_inst(
        .hcount_in(hcount),
        .vcount_in(vcount),
        .sprite_x(p2_paddle_x),
        .sprite_y(p2_paddle_y),
        .red_out(p2_paddle_red),
        .green_out(p2_paddle_green),
        .blue_out(p2_paddle_blue)
    );

    block_sprite #(.SPRITE_WIDTH (PUCK_WIDTH), .SPRITE_HEIGHT (PUCK_HEIGHT))puck_inst(
        .hcount_in(hcount),
        .vcount_in(vcount),
        .sprite_x(puck_x),
        .sprite_y(puck_y),
        .red_out(puck_red),
        .green_out(puck_green),
        .blue_out(puck_blue)
    );

    assign red = p1_paddle_red | p2_paddle_red | puck_red;
    assign green = p1_paddle_green | p2_paddle_green | puck_green;
    assign blue = p1_paddle_blue | p2_paddle_blue | puck_blue;

    tmds_encoder tmds_red(
        .clk(clk_pixel), // pixel clock
        .rst(rst), // system reset
        .data_in(red), // 8-bit value
        .control_in(2'b0),
        .ve_in(activedraw), // from part2
        .tmds_out(tmds_10b[2])
    );

    tmds_encoder tmds_green(
        .clk(clk_pixel), // pixel clock
        .rst(rst), // system reset
        .data_in(green), // 8-bit value
        .control_in(2'b0),
        .ve_in(activedraw), // from part2
        .tmds_out(tmds_10b[1])
    );

    tmds_encoder tmds_blue(
        .clk(clk_pixel), // pixel clock
        .rst(rst), // system reset
        .data_in(blue), // 8-bit value
        .control_in({vsync, hsync}), // from part2
        .ve_in(activedraw), // from part2
        .tmds_out(tmds_10b[0])
    );

    tmds_serializer red_ser(
        .clk_pixel_in(clk_pixel), // pixel clock
        .clk_5x_in(clk_5x), // // 5x faster clock
        .rst_in(rst), // system reset
        .tmds_in(tmds_10b[2]),
        .tmds_out(tmds_signal[2])
    );

    tmds_serializer green_ser(
        .clk_pixel_in(clk_pixel), // pixel clock
        .clk_5x_in(clk_5x), // // 5x faster clock
        .rst_in(rst), // system reset
        .tmds_in(tmds_10b[1]),
        .tmds_out(tmds_signal[1])
    );

    tmds_serializer blue_ser(
        .clk_pixel_in(clk_pixel), // pixel clock
        .clk_5x_in(clk_5x), // // 5x faster clock
        .rst_in(rst), // system reset
        .tmds_in(tmds_10b[0]),
        .tmds_out(tmds_signal[0])
    );

    OBUFDS OBUFDS_blue (.I(tmds_signal[0]), .O(hdmi_tx_p[0]), .OB(hdmi_tx_n[0]));
    OBUFDS OBUFDS_green(.I(tmds_signal[1]), .O(hdmi_tx_p[1]), .OB(hdmi_tx_n[1]));
    OBUFDS OBUFDS_red (.I(tmds_signal[2]), .O(hdmi_tx_p[2]), .OB(hdmi_tx_n[2]));
    OBUFDS OBUFDS_clock(.I(clk_pixel), .O(hdmi_clk_p), .OB(hdmi_clk_n));


    //for the timing errors between different clock domains, use the timing error fix module

    level_sync s1u(.clk(clk_pixel), .rst(rst), .d(up1),   .q(up1_pix));
    level_sync s1d(.clk(clk_pixel), .rst(rst), .d(down1), .q(down1_pix));
    level_sync s2u(.clk(clk_pixel), .rst(rst), .d(up2),   .q(up2_pix));
    level_sync s2d(.clk(clk_pixel), .rst(rst), .d(down2), .q(down2_pix));

endmodule