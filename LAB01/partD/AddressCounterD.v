`timescale 1ns/1ps


module AddressCounterD(clk, reset, counter);

    input clk, reset;

    output reg [6:0] counter;  //!tha allajei gia thn FPGA!

    always @(posedge clk) begin
        if (reset == 1) begin
            counter <= 7'd2;
        end
        else begin
            counter <= counter + 1;
        end
    end

endmodule


// module counter_D(clk, reset, addr);

//     input clk, reset;
//     output reg [3:0] addr;

//     reg [3:0] counter;  //!tha allajei gia thn FPGA!

//     always @(posedge clk) begin
//         if (reset == 1) begin
//             counter <= 4'b1111;
//             addr <= 0;
//         end
//         else begin
//             if (counter < 4'b1111) begin
//                 counter <= counter + 1;
//                 addr <= addr;
//             end
//             else begin
//                 addr <= addr + 1;
//                 counter <= counter + 1;
//             end
//         end
//     end

// endmodule
