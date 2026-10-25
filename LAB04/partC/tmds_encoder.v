`timescale 1ns / 1ps
module tmds_encoder(
    input clk,
    input rst,
    input [7:0] data_in,
    input [1:0] control_in,
    input ve_in, // video data enable
    output reg [9:0] tmds_out
    );
    
    wire [8:0] q_m;
    reg signed [4:0] tally;
    integer i;

    reg [3:0] count_ones, count_zeros;
    
    tm_choice tm_choice_inst(.data_in(data_in), .q_m(q_m));

    always @(q_m) begin
        count_ones = 4'd0;
        for (i = 0; i < 8; i = i + 1) begin
            count_ones = count_ones + q_m[i];
        end
        count_zeros = 4'd8 - count_ones;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tmds_out <= 10'd0;
            tally <= 5'd0;
        end
        else begin
            if (ve_in) begin

                if ((tally == 0) || (count_ones == count_zeros)) begin
                    tmds_out[9] <= ~q_m[8];
                    tmds_out[8] <= q_m[8];

                    if (q_m[8]==0) begin
                        tally <= tally + (count_zeros - count_ones);
                        tmds_out[7:0] <= ~(q_m[7:0]);
                    end

                    else begin
                        tally <= tally + (count_ones - count_zeros);
                        tmds_out[7:0] <= q_m[7:0];
                    end
                end

                else if (((tally > 0) && (count_ones > count_zeros)) || ((tally < 0) && (count_ones < count_zeros))) begin
                //else if (tally < 0 && count_ones < count_zeros) begin
                    tmds_out[9] <= 1'b1;
                    tmds_out[8] <= q_m[8];
                    tmds_out[7:0] <= ~(q_m[7:0]);

                    tally <= tally + (2*q_m[8]) + (count_zeros - count_ones);
                    //tally <= tally - 1 + q_m[8] + (count_zeros - count_ones);
                end

                else begin
                    tmds_out[9] <= 1'b0;
                    tmds_out[8] <= q_m[8];
                    tmds_out[7:0] <= q_m[7:0];

                    tally <= tally - (2*(!q_m[8])) + (count_ones - count_zeros);
                    //tally <= tally + 1 + q_m[8] + (count_ones - count_zeros);
                end
            end

            else begin
                tally <= 5'd0;

                case (control_in)
                    2'b00 : tmds_out <= 10'b1101010100;
                    2'b01 : tmds_out <= 10'b0010101011;
                    2'b10 : tmds_out <= 10'b0101010100;
                    2'b11 : tmds_out <= 10'b1010101011;
                endcase
            end
        end
    end

endmodule 