
module hdmi_controller(
    input clk,
    input rst,
    output [2:0] hdmi_tx_p,
    output [2:0] hdmi_tx_n,
    output hdmi_clk_p,
    output hdmi_clk_n,
    output led
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
    wire [7:0] paddle_red, paddle_green, paddle_blue;
    wire [7:0] puck_red, puck_green, puck_blue;
    wire new_frame;

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
    timing_and_color_driver inst_clk(.clk(clk), .rst(rst), .activedraw(activedraw), .hsync(hsync), .vsync(vsync), .rgb(rgb), .clk_pix(clk_pixel), .clk_5x(clk_5x));
        fsm #(
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

    block_sprite #(.SPRITE_WIDTH (PADDLE_WIDTH), .SPRITE_HEIGHT (PADDLE_HEIGHT))paddle_inst(
        .hcount_in(hcount),
        .vcount_in(vcount),
        .sprite_x(11'd0),
        .sprite_y(10'd10),
        .red_out(paddle_red),
        .green_out(paddle_green),
        .blue_out(paddle_blue)
    );

    block_sprite #(.SPRITE_WIDTH (PUCK_WIDTH), .SPRITE_HEIGHT (PUCK_HEIGHT))puck_inst(
        .hcount_in(hcount),
        .vcount_in(vcount),
        .sprite_x(11'd10),
        .sprite_y(10'd10),
        .red_out(puck_red),
        .green_out(puck_green),
        .blue_out(puck_blue)
    );

    assign red = paddle_red | puck_red;
    assign green = paddle_green | puck_green;
    assign blue = paddle_blue | puck_blue;

    // assign red = (rgb[2]==1) ? {7'b1111111,rgb[2]} : {7'b0000000,rgb[2]};
    // assign green = (rgb[1]==1) ? {7'b1111111,rgb[1]} : {7'b0000000,rgb[1]};
    // assign blue = (rgb[0]==1) ? {7'b1111111,rgb[0]} : {7'b0000000,rgb[0]};

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

endmodule