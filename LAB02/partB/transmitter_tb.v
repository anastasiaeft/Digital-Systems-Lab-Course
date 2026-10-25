`timescale 1ns/1ps
module transmitter_tb;
    reg reset,clk;
    reg [7:0] Tx_DATA;
    reg [2:0] baud_select;
    reg Tx_WR;
    reg Tx_EN;



    uart_transmitter dut(reset, clk, Tx_DATA, baud_select, Tx_WR, Tx_EN, TxD, Tx_BUSY);

    initial begin
        reset = 1;
        clk = 0;
        Tx_DATA = 8'h41; //'A' ascii
        baud_select = 3'b011; // 9600 baud
        Tx_EN = 1;
        Tx_WR = 0;

        #10000
        reset = 0;
        #20000
        Tx_WR = 1; // start transmission
        #100000
        Tx_WR = 0; // stop transmission signal

        #1200000
        Tx_EN = 0; // disable transmitter
        #20000
        Tx_WR = 1; // try to start transmission while disabled
        #10000
        Tx_WR = 0; // stop transmission signal


        #20000
        Tx_DATA = 8'h42; //'B' ascii
        #20000
        Tx_EN = 1; // enable transmitter
        #20000
        Tx_WR = 1; // start transmission
        #100000
        Tx_WR = 0; // stop transmission signal
    

    end

    always clk = #5 ~clk;

endmodule