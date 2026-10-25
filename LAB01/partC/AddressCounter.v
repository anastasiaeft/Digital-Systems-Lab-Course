module AddressCounterC(clk, button, rst, addr);
    input button, rst, clk;
    output reg [3:0] addr;


    always @(posedge clk) begin
        if (rst == 1)
            addr <= 0;
        else if (button == 1)
            addr <= addr + 1;
        else addr <= addr;
    end
endmodule