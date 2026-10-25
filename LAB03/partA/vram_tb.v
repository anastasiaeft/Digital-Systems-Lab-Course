`timescale 1ns/1ps

module vram_tb;

    // DUT signals
    reg         clk;
    reg         we;
    reg  [13:0] addr;
    reg  [2:0]  din;
    wire [2:0]  dout;

    // Instantiate DUT
    vram dut (
        .clk (clk),
        .we  (we),
        .addr(addr),
        .din (din),
        .dout(dout)
    );

    // Clock generation: 100 MHz (period 10 ns)
    initial clk = 0;
    always #5 clk = ~clk;

    // Simple write task
    task write_pixel(input [13:0] address, input [2:0] data);
    begin
        @(posedge clk);
        addr = address;
        din  = data;
        we   = 1'b1;
        @(posedge clk);   // write on this edge
        we   = 1'b0;
        din  = 3'b000;
    end
    endtask

    // Read & check task (1-cycle latency)
    task read_and_check(input [13:0] address, input [2:0] expected);
        reg [2:0] q;
    begin
        // Apply address
        @(posedge clk);
        addr = address;
        we   = 1'b0;

        // Wait for BRAM read latency
        @(posedge clk);
        q = dout;

        if (q !== expected) begin
            $display("ERROR: addr %0d expected %b got %b at time %0t",
                     address, expected, q, $time);
            $stop;
        end else begin
            $display("OK: addr %0d = %b (time %0t)", address, q, $time);
        end
    end
    endtask

    // Test sequence
    initial begin
        // Init
        we   = 1'b0;
        addr = 14'd0;
        din  = 3'b000;

        repeat (10) @(posedge clk);

        // ΓΡΑΦΕΣ
        write_pixel(14'd0,    3'b101);  // R,B
        write_pixel(14'd1,    3'b011);  // G,B
        write_pixel(14'd100,  3'b111);  // R,G,B
        write_pixel(14'd5000, 3'b001);  // μόνο B

        repeat (5) @(posedge clk);
        read_and_check(14'd0,    3'b101);
        read_and_check(14'd1,    3'b011);
        read_and_check(14'd100,  3'b111);
        read_and_check(14'd5000, 3'b001);

        $display("==== All tests passed ====");
        $finish;
    end

endmodule