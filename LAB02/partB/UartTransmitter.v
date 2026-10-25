`timescale 1ns/1ps
module uart_transmitter(reset, clk, Tx_DATA, baud_select, Tx_WR, Tx_EN, TxD, Tx_BUSY);
    input reset, clk;
    input [7:0] Tx_DATA;
    input [2:0] baud_select;
    input Tx_EN;
    input Tx_WR;
    output TxD;
    output Tx_BUSY;

    wire Tx_sample_ENABLE, debounced_Tx_WR;
    wire slow_enable;

    Debouncer debouncer_inst(clk, Tx_WR, debounced_Tx_WR);

    baud_controller baud_controller_tx_inst(reset, clk, baud_select, Tx_sample_ENABLE);

    EnableTrigger trigger_tx_inst(clk, reset, Tx_sample_ENABLE, slow_enable);

    T_FSM fsm_tx_inst(reset, clk, Tx_DATA, slow_enable, debounced_Tx_WR, Tx_EN, TxD, Tx_BUSY);
endmodule