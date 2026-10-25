module uart_receiver(reset, clk, Rx_DATA, baud_select, Rx_EN, RxD, Rx_FERROR, Rx_PERROR, Rx_VALID);
    input reset, clk;
    input [2:0] baud_select;
    input Rx_EN;
    input RxD;
    output [7:0] Rx_DATA;
    output Rx_FERROR; // Framing Error //
    output Rx_PERROR; // Parity Error //
    output  Rx_VALID; // Rx_DATA is Valid //

    wire [7:0] data;
    wire RxD_sync;
    wire Rx_sample_ENABLE;
    wire valid_pulse;
    wire ferror_pulse;
    wire perror_pulse;
    wire counter_reset;


    baud_controller baud_controller_rx_inst(reset, clk, baud_select, Rx_sample_ENABLE);
    synchronizer synchronizer_rx_inst(clk, RxD, RxD_sync);
    fsm fsm_rx_inst(reset, clk, Rx_EN, RxD_sync, Rx_sample_ENABLE, valid_pulse, ferror_pulse, perror_pulse, data, counter_reset);
    outputs_handler outputs_handler_inst(clk, reset, data, counter_reset, ferror_pulse, perror_pulse, valid_pulse, Rx_VALID, Rx_DATA, Rx_FERROR, Rx_PERROR);


endmodule