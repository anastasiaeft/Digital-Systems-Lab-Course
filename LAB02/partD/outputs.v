module outputs_handler(clk, reset, data, counter_reset, ferror_pulse, perror_pulse, valid_pulse, Rx_VALID, Rx_DATA, Rx_FERROR, Rx_PERROR);
    input clk, reset;
    input ferror_pulse;
    input perror_pulse;
    input valid_pulse;
    input [7:0] data;
    input counter_reset;
    output reg Rx_VALID, Rx_FERROR, Rx_PERROR;;
    output wire [7:0] Rx_DATA;
    
    

    always @(posedge clk or posedge reset) begin
        if (reset || counter_reset) begin
            Rx_VALID <= 1'b0;
            Rx_FERROR <= 1'b0;
            Rx_PERROR <= 1'b0;
        end else begin
            if (valid_pulse) begin
                Rx_VALID <= 1'b1;
                Rx_PERROR <= 1'b0;
                Rx_FERROR <= 1'b0;
            end

            if (ferror_pulse) begin
                Rx_FERROR <= 1'b1;
                Rx_VALID <= 1'b0;
            end

            if (perror_pulse) begin
                Rx_PERROR <= 1'b1;
                Rx_VALID <= 1'b0;
            end 
        end
    end

    assign Rx_DATA = data;
    //assign Rx_DATA={data[7],data[6],data[5],data[4],data[3],data[2],data[1],data[0]};

endmodule 