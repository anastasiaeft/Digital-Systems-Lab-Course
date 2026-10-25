module hdmi_tb;

    reg clk;
    reg reset;
    wire [2:0] hdmi_tx_p;   //positive part for each color channel
    wire [2:0] hdmi_tx_n;   //negative part for each color channel
    wire hdmi_clk_p;        //positive part for hdmi clk
    wire hdmi_clk_n;        //negative part for hdmi clk

    hdmi_controller hdmi_inst(.clk(clk), .rst(reset), .hdmi_tx_p(hdmi_tx_p), .hdmi_tx_n(hdmi_tx_n), .hdmi_clk_p(hdmi_clk_p), .hdmi_clk_n(hdmi_clk_n));

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