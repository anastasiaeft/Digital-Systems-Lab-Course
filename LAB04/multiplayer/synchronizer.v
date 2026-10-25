module synchronizer (clk, async_signal, sync_signal);
    input clk, async_signal;
    output reg sync_signal;
    reg sync_ff1;

    always @(posedge clk) begin
        sync_ff1 <= async_signal;
        sync_signal <= sync_ff1;
    end

endmodule