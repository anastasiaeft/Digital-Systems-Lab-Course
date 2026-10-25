module AddressPointer(clk, reset, counter, ptr);
    input [6:0] counter;
    input clk, reset;
    output reg [3:0] ptr;

    always @(posedge clk) begin
        if(reset == 1)
            ptr <= 0;
        else begin
            if(counter == 7'b1111111)
                ptr <= ptr + 1;
            else
                ptr <= ptr;
        end
    end
endmodule