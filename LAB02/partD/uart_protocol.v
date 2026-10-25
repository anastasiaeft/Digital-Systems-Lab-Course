module uart(clk, reset, baud_select, Tx_DATA, Tx_WR, Tx_EN, Rx_EN, Tx_BUSY, Rx_DATA, Rx_FERROR, Rx_PERROR, Rx_VALID);
    input clk, reset;
    input [2:0] baud_select;
    input [7:0] Tx_DATA;
    input Tx_WR;
    input Tx_EN;
    input Rx_EN;
    output  Tx_BUSY;
    output  [7:0] Rx_DATA;
    output  Rx_FERROR;
    output  Rx_PERROR;
    output  Rx_VALID;
    
    
    wire uart_connection;


    uart_transmitter uart_transmitter_inst(reset, clk, Tx_DATA, baud_select, Tx_WR, Tx_EN, uart_connection, Tx_BUSY);
    uart_receiver uart_receiver_inst(reset, clk, Rx_DATA, baud_select, Rx_EN, uart_connection, Rx_FERROR, Rx_PERROR, Rx_VALID);

endmodule