11`timescale 1ns / 1ps
module testbench_C();
    reg clk, reset;
    reg Rx_EN;
    reg RxD;
    reg [2:0] baud_select; 
    wire Rx_FERROR;
    wire Rx_PERROR;
    wire Rx_VALID;
    wire [7:0] Rx_DATA;
    reg [7:0] mess;

    uart_receiver uut (.reset(reset), .clk(clk), .Rx_DATA(Rx_DATA), .baud_select(baud_select), .Rx_EN(Rx_EN), .RxD(RxD), .Rx_FERROR(Rx_FERROR), .Rx_PERROR(Rx_PERROR), .Rx_VALID(Rx_VALID));

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        Rx_EN = 0;
        RxD = 1;
        baud_select = 3'b011; // Example baud rate selection
        #10;
        reset = 0;
        #10000;
        Rx_EN = 1;
        mess = 8'h41; // Example data to send
        #(10*651*16 *2 );
        #3.200
        //start bit
        RxD = 0;
        #(10*651*16 ); // Wait for one bit duration at 19200 baud
        for(integer i = 0; i < 8; i = i + 1) begin
            RxD = mess[i];
            #(10*651*16);
        end
        RxD = ^mess; #(10*651*16);
        // stop bit
        RxD = 1; #(20*651*16);


        mess = 8'h42; // Example data to send
        #(10*651*16 *2 );

        //start bit
        RxD = 0;
        #(10*651*16 ); // Wait for one bit duration at 19200 baud
        for(integer i = 0; i < 8; i = i + 1) begin
            RxD = mess[i];
            #(10*651*16);
        end
        RxD = ^mess; #(10*651*16);
        // stop bit
        RxD = 1; #(10*651*16);
        
        mess = 8'h44; // Example data to send
        #(10*651*16 *2 );

        //start bit
        RxD = 0;
        #(10*651*16 ); // Wait for one bit duration at 19200 baud
        for(integer i = 0; i < 8; i = i + 1) begin
            RxD = mess[i];
            #(10*651*16);
        end
        RxD = ~(^mess); #(10*651*16); //simulate perror
        // stop bit
        RxD = 1; #(10*651*16);



        #5000;
        Rx_EN = 0;
        #200;   
    end
endmodule