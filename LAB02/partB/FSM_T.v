`timescale 1ns/1ps
module T_FSM(reset, clk, Tx_DATA, slow_enable, Tx_WR, Tx_EN, TxD, Tx_BUSY);
    input reset, clk;
    input [7:0] Tx_DATA;
    input slow_enable;
    input Tx_EN;
    input Tx_WR;
    output reg TxD;
    output reg Tx_BUSY;

    reg [2:0] addr;
    reg addr_reset, addr_enable;


    parameter OFF = 3'b000,
            IDLE =3'b001,
            START=3'b010,
            DATA =3'b011,
            PARITY = 3'b100,
            STOP =  3'b101;



    reg [2:0] state, next_state;


    //FSM Sequential Logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= OFF;
        end else begin
            state <= next_state;
        end
    end

    //FSM Combinational Logic
    always @(*) begin
        next_state = state;
        addr_reset = 1'b1;
        addr_enable = 1'b0;
        TxD = 1'b1;
        Tx_BUSY = 1'b0;  
        case(state)
            OFF: begin
                Tx_BUSY = 1'b0;
                TxD = 1'b1; //Trnasmitter is OFF - output is high
                if (Tx_EN && Tx_WR) begin   //request to start transmission
                    next_state = IDLE;
                end 
            end
            IDLE: begin
                Tx_BUSY = 1'b0; // got start request waiting slow enable to strart transmittion
                TxD = 1'b1;    //output still high 
                if (slow_enable) begin
                    next_state = START;
                end  
            end
            START: begin
                Tx_BUSY = 1'b1; // start transmission, set busy to high
                TxD = 1'b0; // indicate start bit
                if (slow_enable) begin
                    next_state = DATA;
                end  
            end
            DATA: begin
                Tx_BUSY = 1'b1; //sending data, still busy
                TxD = Tx_DATA[addr]; // sending data bit by bit
                addr_enable = 1'b1; 
                addr_reset = 1'b0;
                if (slow_enable && addr == 3'b111) begin //once all data bits are sent go to next state
                    next_state = PARITY;
                end 
            end
            PARITY: begin
                Tx_BUSY = 1'b1; // sending parity bit, still busy
                TxD = ^Tx_DATA; // calc even parity bit
                if (slow_enable) begin
                    next_state = STOP;
                end  
            end
            STOP: begin
                Tx_BUSY = 1'b1; // sending stop bit, still busy
                TxD = 1'b1; // indicate stop bit
                if (slow_enable) begin
                    next_state = OFF;
                end 
            end
            default: next_state = OFF;
        endcase
    end

    // Data bit address counter
    always @(posedge clk or posedge reset) begin
        if (reset || addr_reset) begin  // reset address if reset is pressed or when transmitter isnt sending data
            addr <= 3'b000;
        end else if (addr_enable && slow_enable) begin // increment address when on DATA state at each slow enable pulse, reset when address reaches 7
            if (addr == 3'b111) begin
                addr <= 3'b000;
            end else begin
                addr <= addr + 3'b001;
            end
        end
    end

endmodule