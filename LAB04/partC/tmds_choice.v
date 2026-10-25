`timescale 1ns / 1ps
module tm_choice (
    input [7:0] data_in,
    output reg [8:0] q_m
);

    reg [3:0] count_ones;
    integer i;

    //calculate the num of 1s
    always @(data_in) begin
        count_ones = 4'd0;
        for (i = 0; i < 8; i = i + 1) begin
            count_ones = count_ones + ({3'b000,data_in[i]});
        end
        
        if ((count_ones > 4'd4) || (count_ones == 4 && data_in[0] == 1'b0)) begin  //option2
            q_m[0] = data_in[0];                      //lsb
            for (i=1; i<8; i=i+1) begin
                q_m[i] = ~(q_m[i-1] ^ data_in[i]);    //xnor
            end
            q_m[8] = 0;                               //msb
        end
        else begin                                                              //option1
            q_m[0] = data_in[0];                     //lsb
            for (i=1; i<8; i=i+1) begin
                q_m[i] = q_m[i-1] ^ data_in[i];      //xor
            end
            q_m[8] = 1'b1;                           //msb
        end
         
    end

endmodule