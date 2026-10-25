module block_sprite(
    input [9:0] hcount_in,
    input [9:0] vcount_in,
    input [10:0] sprite_x,
    input [9:0] sprite_y,
    output reg [7:0] red_out,
    output reg [7:0] green_out,
    output reg [7:0] blue_out);

    parameter SPRITE_WIDTH = 11'd10;
    parameter SPRITE_HEIGHT = 10'd100;


    always @(hcount_in or vcount_in or sprite_x or sprite_y) begin
        if (hcount_in >= sprite_x && hcount_in < (sprite_x + SPRITE_WIDTH) &&
            vcount_in >= sprite_y && vcount_in < (sprite_y + SPRITE_HEIGHT)) begin
            red_out = 8'b11111111;
            green_out = 8'b11111111;
            blue_out = 8'b11111111;
        end
        else begin
            red_out = 8'b00000000;
            green_out = 8'b00000000;
            blue_out = 8'b00000000;
        end
    end
    
endmodule