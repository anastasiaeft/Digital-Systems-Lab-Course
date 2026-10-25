module MessageRotator(clk, reset, addr_mes, digits1, digits2, digits3, digits4);
    input clk, reset;
    input  [3:0] addr_mes;
    //output [3:0] digits [0:3];
    output reg [3:0] digits1;
    output reg [3:0] digits2;
    output reg [3:0] digits3;
    output reg [3:0] digits4;

    reg[3:0] msg [0:15];

    // wire [3:0] addr_mes;
    // wire new_button, new_reset;

    always @(posedge clk) begin
        if (reset) begin
            msg[0] <= 4'd0;
            msg[1] <= 4'd1;
            msg[2] <= 4'd2;
            msg[3] <= 4'd3;
            msg[4] <= 4'd4;
            msg[5] <= 4'd5;
            msg[6] <= 4'd6;
            msg[7] <= 4'd7;
            msg[8] <= 4'd8;
            msg[9] <= 4'd9;
            msg[10] <= 4'd10; // A
            msg[11] <= 4'd11; // B
            msg[12] <= 4'd12; // C
            msg[13] <= 4'd13; // D
            msg[14] <= 4'd14; // E
            msg[15] <= 4'd15; // F
        end
    end

    // reset_synchr sync_reset(.clk(clk), .reset(reset), .synchr_reset(new_reset));
    // button_deb debounce(.clk(clk), .button(button), .out_button(new_button));
    // address addr(.button(new_button), .rst(new_reset), .addr(addr_mes));

    // assign digits1 = msg[addr_mes];
    // assign digits2 = msg[addr_mes + 4'd1];
    // assign digits3 = msg[addr_mes + 4'd2];
    // assign digits4 = msg[addr_mes + 4'd3];
    always @(posedge clk) begin
        if (reset) begin
            digits1 <= 0;
            digits2 <= 0;
            digits3 <= 0;
            digits4 <= 0;
        end
        else begin
            digits1 <= msg[addr_mes];
            digits2 <= msg[addr_mes + 4'd1];
            digits3 <= msg[addr_mes + 4'd2];
            digits4 <= msg[addr_mes + 4'd3];
        end
    end
    
endmodule