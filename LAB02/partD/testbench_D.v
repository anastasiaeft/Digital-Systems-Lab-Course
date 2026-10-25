module testbench_D
    #(
    parameter integer MSG_BYTES = 36,
    parameter [8*MSG_BYTES-1:0] TEST_MESSAGE = "UART TRANSMITTER RECEIVER PROTOCOL"
    ) ();

    localparam integer ADDR_WIDTH = $clog2(MSG_BYTES); // = 6 for 36 bytes

    reg [ADDR_WIDTH-1:0] address;
    reg clk;
    reg reset;
    reg [2:0] baud_select;
    reg [7:0] Tx_DATA;
    reg Tx_WR;
    reg Tx_EN;
    reg Rx_EN;
    wire Tx_BUSY;
    wire [7:0] Rx_DATA;
    wire Rx_FERROR;
    wire Rx_PERROR;
    wire Rx_VALID;

    reg [7:0] message [MSG_BYTES-1:0];
    reg [7:0] received_message [MSG_BYTES-1:0];

    integer i,k;

    // Instantiate the UART module
    // uart_receiver uut_rx (
    //     .reset(reset),
    //     .clk(clk),
    //     .Rx_DATA(Rx_DATA),
    //     .baud_select(baud_select),
    //     .Rx_EN(Rx_EN),
    //     .RxD(uart_tx_to_rx),
    //     .Rx_FERROR(Rx_FERROR),
    //     .Rx_PERROR(Rx_PERROR),
    //     .Rx_VALID(Rx_VALID)
    // );
    //  uart_transmitter uut_tx (
    //     .reset(reset),
    //     .clk(clk),
    //     .Tx_DATA(Tx_DATA),
    //     .baud_select(baud_select),
    //     .Tx_WR(Tx_WR),
    //     .Tx_EN(Tx_EN),
    //     .TxD(uart_tx_to_rx),
    //     .Tx_BUSY(Tx_BUSY)
    // );
    uart uart_inst (
        .reset(reset),
        .clk(clk),
        .baud_select(baud_select),
        .Tx_DATA(Tx_DATA),
        .Tx_WR(Tx_WR),
        .Tx_EN(Tx_EN),
        .Rx_EN(Rx_EN),
        .Tx_BUSY(Tx_BUSY),
        .Rx_DATA(Rx_DATA),
        .Rx_FERROR(Rx_FERROR),
        .Rx_PERROR(Rx_PERROR),
        .Rx_VALID(Rx_VALID)
    );

    // Clock generation
    
        always #5 clk = ~clk; // 100MHz clock
    
    // Initialize message array
    initial begin
        
    end
    // Test sequence
    initial begin
       for (k = 0; k < MSG_BYTES; k = k + 1) begin
            message[k] = (TEST_MESSAGE >> (8*k)) & 8'hFF;
            received_message[k] = 8'd32;
        end
        clk = 0;
        reset = 1'd1;
        Rx_EN = 1'd0;
        Tx_EN = 1'd0;
        baud_select = 3'b011; // Example baud rate selection
        #10;
        reset = 0;
        #100000;
        Rx_EN = 1'd1;
        Tx_EN = 1'd1;
       

       for (i = MSG_BYTES-1; i >= 0; i = i - 1) begin
            if(!Tx_BUSY)begin
                Tx_DATA = message[i];
                #10000
                Tx_WR = 1'd1;
                #2000000
                Tx_WR = 1'd0;
                #2000000;
            end
        end
        // Finish simulation
        $finish;
    end

    always @(Rx_VALID) begin
        if (Rx_VALID) begin
            received_message[address] = Rx_DATA;
            address = address + 1;
        end
    end
endmodule