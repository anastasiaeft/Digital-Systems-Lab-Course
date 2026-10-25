
module hdmi_controller(
    input clk,
    input rst,
    output [2:0] hdmi_tx_p,
    output [2:0] hdmi_tx_n,
    output hdmi_clk_p,
    output hdmi_clk_n
    );

    wire [9:0] tmds_10b [2:0];  //output of TMDS, 10 bits for each color
    wire [2:0] tmds_signal;     //output of SERIALIZER, 1 bit for each color
    wire [7:0] red;
    wire [7:0] green;
    wire [7:0] blue;

    wire activedraw, hsync, vsync;
    wire [2:0] rgb;
    wire clk_pixel, clk_5x;

    timing_and_color_driver inst_clk(.clk(clk), .rst(rst), .activedraw(activedraw), .hsync(hsync), .vsync(vsync), .rgb(rgb), .clk_pix(clk_pixel), .clk_5x(clk_5x));

    assign red = (rgb[2]==1) ? {7'b1111111,rgb[2]} : {7'b0000000,rgb[2]};
    assign green = (rgb[1]==1) ? {7'b1111111,rgb[1]} : {7'b0000000,rgb[1]};
    assign blue = (rgb[0]==1) ? {7'b1111111,rgb[0]} : {7'b0000000,rgb[0]};

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