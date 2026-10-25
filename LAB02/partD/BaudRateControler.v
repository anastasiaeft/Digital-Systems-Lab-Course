
module baud_controller(reset, clk, baud_select, sample_ENABLE);
    input reset, clk;
    input [2:0] baud_select;
    output reg sample_ENABLE;
    
    reg [14:0] counter;
    reg [14:0] max_count;
    
// Baudsel BaudRate
// 000       300
// 001       1200
// 010       4800
// 011       9600
// 100       19200
// 101       38400
// 110       57600
// 111       115200
//-----------------------------------------------------------------------------------------------
// Assuming a clock frequency of 100MHz(fpga clock) we'll need to set the max_count accordingly
// max_count = Clock_Frequency / Round(16xBaud_Rate)

    always @(baud_select) begin
        case(baud_select)
            3'b000: max_count = 15'd20833; //baud rate 300
            3'b001: max_count = 15'd5208;//baud rate 1200
            3'b010: max_count = 15'd1302; //baud rate 4800
            3'b011: max_count = 15'd651;   //baud rate 9600
            3'b100: max_count = 15'd326;   //baud rate 19200
            3'b101: max_count = 15'd163;   //baud rate 38400
            3'b110: max_count = 15'd108;   //baud rate 57600
            3'b111: max_count = 15'd54;    //baud rate 115
        endcase
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 15'd0;
            sample_ENABLE <= 1'b0;
        end else begin
            if (counter == max_count) begin
                counter <= 15'd0;
                sample_ENABLE <= 1'b1;
            end else begin
                counter <= counter + 15'd1;
                sample_ENABLE <= 1'b0;
            end
        end
    end

endmodule