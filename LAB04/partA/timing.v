module timing_and_color_driver(
input clk,
input rst,
output activedraw,
output hsync,
output vsync,
output [2:0] rgb,
output clk_pix,
output clk_5x // 1bit each for now
);

    wire locked, clkfb_buf, clkfb_raw;
    wire [13:0] pixel_address;         //because vcount is 10-bit and hcount is 10-bit so sum -> 20-bit
    wire [2:0] data_in;
    wire write_enable;


    // include MMCM, VRAM, FSM(s), counter(s), etc //
    //clk = 25.175 MHz
    wire clk_pix_raw, clk_5x_raw;

    MMCME2_BASE #(
        .CLKIN1_PERIOD(10.000),

        // VCO = (100 MHz / DIVCLK) * MULT = (100/2)*17.625 = 881.25 MHz
        .DIVCLK_DIVIDE(2),
        .CLKFBOUT_MULT_F(17.625),

        // Outputs from same VCO
        .CLKOUT0_DIVIDE_F(35.0),  // 881.25/35  = 25.178571 MHz (fractional-capable output)
        .CLKOUT1_DIVIDE  (7),     // 881.25/7   = 125.892857 MHz

        .CLKOUT0_DUTY_CYCLE(0.5),
        .CLKOUT1_DUTY_CYCLE(0.5),
        .CLKOUT0_PHASE(0.0),
        .CLKOUT1_PHASE(0.0)
    ) mmcm(
        .CLKIN1 (clk),
        .CLKFBIN(clkfb_buf),
        .CLKFBOUT(clkfb_raw),

        .CLKOUT0(clk_pix_raw),
        .CLKOUT1(clk_5x_raw),

        .PWRDWN (1'b0),
        .RST    (rst),
        .LOCKED (locked)
    );

    // Global clock routing (do NOT skip these)
    BUFG fb_buf  (.I(clkfb_raw),  .O(clkfb_buf));
    BUFG pix_buf (.I(clk_pix_raw), .O(clk_pix));
    BUFG x5_buf  (.I(clk_5x_raw),  .O(clk_5x));

    //assign pixel_address = (activedraw) ? {vcount[6:0], hcount[6:0]} : 14'd0; //14-bit address for 640x480
    assign write_enable = 1'b0;
    assign data_in = 3'b000;

    //vram rgb_values(.clk(clk_pix), .we(write_enable), .din(data_in), .addr(pixel_address), .dout(rgb)); wont be using video memory for pong
    //fsm fsm_inst(.clk(clk_pix), .reset(rst), .activedraw(activedraw), .hsync(hsync), .vsync(vsync), .hcount_slow(hcount), .vcount_slow(vcount)); im going to transfer this instantiation to the top module hdmi.v

endmodule

