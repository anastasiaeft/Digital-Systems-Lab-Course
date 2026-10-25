module hdmi_tb;

    reg clk;
    reg reset;
    wire [2:0] hdmi_tx_p;   //positive part for each color channel
    wire [2:0] hdmi_tx_n;   //negative part for each color channel
    wire hdmi_clk_p;        //positive part for hdmi clk
    wire hdmi_clk_n;        //negative part for hdmi clk

    hdmi_controller #(
    .PADDLE_WIDTH      (11'd2),
    .PADDLE_HEIGHT     (10'd5),
    .PUCK_WIDTH        (11'd3),
    .PUCK_HEIGHT       (10'd3),

    .Hor_ACTIVE_END    (10'd19),
    .Hor_BLANKING_END  (10'd20),
    .Hor_SYNC_END      (10'd23),
    .Hor_TOTAL         (10'd24),

    .Ver_BLANKING_END  (10'd20),
    .Ver_SYNC_END    (10'd21),
    .Ver_ACTIVE_END    (10'd19),
    .Ver_TOTAL         (10'd22)
    ) hdmi_inst (
    .clk(clk),
    .rst(reset),
    .hdmi_tx_p(hdmi_tx_p),
    .hdmi_tx_n(hdmi_tx_n),
    .hdmi_clk_p(hdmi_clk_p),
    .hdmi_clk_n(hdmi_clk_n)
    );

    always begin
        #5 clk <= ~clk;
    end

    initial begin

        $dumpfile("hdmi_tb.vcd");
        $dumpvars(0, hdmi_tb);

        clk = 0;
        reset = 1;

        #200
        reset = 0;

        #42_000_000;
        $finish;
    end
endmodule