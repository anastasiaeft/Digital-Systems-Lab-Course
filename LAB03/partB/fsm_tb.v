module fsm_tb();
reg clk, reset;
wire activedraw;
wire hsync;
wire vsync;

fsm dut(.clk(clk), .reset(reset), .activedraw(activedraw), .hsync(hsync), .vsync(vsync));


always #5 clk = ~clk;


initial begin 
    clk = 0;
    reset = 1;

    #200
    reset = 0;

end


endmodule