module EnableTrigger(clk, reset, Tx_sample_ENABLE, slow_enable);
    input clk, reset;
    input Tx_sample_ENABLE;
    output reg slow_enable;

    reg [3:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 4'd0;
            slow_enable <= 1'b0;
        end else if (Tx_sample_ENABLE) begin
            if (count == 4'd15) begin
                count <= 4'd0;
                slow_enable <= 1'b1;
            end else begin
                count <= count + 4'd1;
                slow_enable <= 1'b0;
            end
        end else begin
            slow_enable <= 1'b0;
        end
    end
endmodule