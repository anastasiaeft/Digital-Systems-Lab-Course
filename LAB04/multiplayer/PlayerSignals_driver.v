`timescale 1ns/1ps
module PlayerSignals_driver(
    input  wire       clk,
    input  wire       reset,
    input  wire [7:0] Rx_DATA,
    input  wire       Rx_VALID,
    output reg        up1,
    output reg        down1,
    output reg        up2,
    output reg        down2
);
    reg prev_Rx_VALID;

    wire rx_edge = Rx_VALID & ~prev_Rx_VALID; // "new byte arrived"

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            up1 <= 1'b0; 
            down1 <= 1'b0; 
            up2 <= 1'b0; 
            down2 <= 1'b0;
            prev_Rx_VALID <= 1'b0;
        end else begin
            prev_Rx_VALID <= Rx_VALID;

            if (rx_edge) begin
                // default: clear all
                up1 <= 1'b0; down1 <= 1'b0; up2 <= 1'b0; down2 <= 1'b0;

                case (Rx_DATA)
                    8'h57, 8'h77: begin 
                        up1   <= 1'b1;
                        down1 <= 1'b0;
                        up2   <= 1'b0;
                        down2 <= 1'b0;
                    end // W/w
                    8'h53, 8'h73: begin
                        up1   <= 1'b0; 
                        down1 <= 1'b1;
                        up2   <= 1'b0;
                        down2 <= 1'b0; 
                    end // S/s
                    8'h49, 8'h69: begin 
                        up1   <= 1'b0;
                        down1 <= 1'b0;
                        up2   <= 1'b1;
                        down2 <= 1'b0; 
                    end // I/i
                    8'h4B, 8'h6B: begin
                        up1   <= 1'b0;
                        down1 <= 1'b0;
                        up2   <= 1'b0; 
                        down2 <= 1'b1; 
                    end // K/k
                    default: begin
                        up1   <= 1'b0;
                        down1 <= 1'b0; 
                        up2 <= 1'b0; 
                        down2 <= 1'b0;
                     end
                endcase
            end
        end
    end
endmodule

