

module fsm (reset, clk, Rx_EN, RxD, Rx_Sample_Enable, ValidPulse, FerrorPulse, PerrorPulse, data, counter_reset);
    input reset, clk;
    input Rx_EN;
    input RxD;
    input Rx_Sample_Enable;
    output reg ValidPulse;
    output reg FerrorPulse;
    output reg PerrorPulse;
    output reg [7:0] data;
    output reg counter_reset;
    
    reg [2:0] addr;
    reg addr_reset, addr_enable;
    reg [3:0] counter;
    reg [2:0] sample_count;
    reg ValidSample;
    reg Sample;
    reg slow_enable;

    parameter IDLE =3'b000,
            START=3'b001,
            DATA =3'b010,
            PARITY = 3'b011,
            STOP =  3'b100;

    reg [2:0] state, next_state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        next_state = state;
        ValidPulse = 1'b0;
        FerrorPulse = 1'b0;
        PerrorPulse = 1'b0;
        counter_reset = 1'b0;
        addr_reset = 1'b0;
        addr_enable = 1'b0;
        case(state)
            IDLE: begin
                if (Rx_EN && RxD==1'b0) begin
                    counter_reset = 1'b1;
                    next_state = START;
                end 
            end
            START: begin
                if (slow_enable && ValidSample && Sample==1'b0) begin
                    addr_reset = 1'b1;
                    next_state = DATA;
                end 
                else if (slow_enable && !ValidSample) begin
                    next_state = IDLE;
                    FerrorPulse = 1'b1;
                end 
            end
            DATA: begin
                addr_enable = 1'b1;
                if (slow_enable && ValidSample) begin
                    if (addr == 3'b111) begin
                        next_state = PARITY;
                    end
                end 
                else if (slow_enable && ValidSample==1'b0) begin
                    next_state = IDLE;
                    FerrorPulse = 1'b1;
                end
            end

            PARITY: begin
                if (slow_enable && ValidSample) begin
                    if (Sample == ^data) begin
                        next_state = STOP;
                    end 
                    else begin
                        next_state = IDLE;
                        PerrorPulse = 1'b1;
                    end
                end
                else if (slow_enable && ValidSample==1'b0) begin
                    next_state = IDLE;
                    FerrorPulse = 1'b1;
                end
            end
            STOP: begin
                if (slow_enable && ValidSample) begin
                    next_state = IDLE;
                    if (Sample) begin
                        ValidPulse = 1'b1;
                    end
                    else begin
                        FerrorPulse = 1'b1;
                    end
                end  
                else if (slow_enable && ValidSample==1'b0) begin
                    next_state = IDLE;
                    FerrorPulse = 1'b1;
                end
            end
            default: begin
                next_state = IDLE;
            end
        endcase
        
    end

    // Address Counter Logic
    always @(posedge clk or posedge reset) begin
        if (reset || addr_reset) begin
            addr <= 3'b000;
        end else begin
            if (addr_enable && slow_enable) begin
                addr <= addr + 1;
            end
        end
    end

    //assign slow_enable = (Rx_Sample_Enable && counter == 4'b1111) ? 1'b1 : 1'b0;

    //Sampling Logic
    always @(posedge clk or posedge reset) begin
        if (reset || counter_reset) begin
            sample_count <= 3'b000;
            ValidSample <= 1'b1;
            Sample <= 1'b0;
            counter <= 4'd0;
            slow_enable <= 1'b0;
        end 
        else
        if(Rx_Sample_Enable)begin
            case (counter)
            4'd4: begin sample_count <= sample_count + RxD;  counter <= counter + 1;  end
            4'd6: begin sample_count <= sample_count + RxD;  counter <= counter + 1; end
            4'd8: begin sample_count <= sample_count + RxD;  counter <= counter + 1; end
            4'd10:begin  sample_count <= sample_count + RxD; counter <= counter + 1; end
            4'd15: begin
                slow_enable <= 1'b1;
                if (sample_count == 3'b100 || sample_count == 3'b000) begin
                    ValidSample <= 1'b1;
                end 
                else begin
                    ValidSample <= 1'b0;
                end
                
                if (sample_count >= 3'b010) begin
                    Sample <= 1'b1;
                end
                else begin
                    Sample <= 1'b0;
                end
                sample_count <= 3'b000;
                counter <= 4'd0;
            end
            default:begin  counter <= counter + 1; end
        endcase
        end
        else begin
            slow_enable <= 1'b0;
        end
        
    end
    
    always@(posedge clk, posedge reset) begin
        if (reset) begin
            data<=8'b0;
        end
        else if (ValidSample && addr_enable && slow_enable) begin
            data[addr]<=Sample;
        end
    end
        
endmodule