module fsm(clk, reset, activedraw, hsync, vsync, hcount_slow, vcount_slow);
    input clk, reset;
    output reg activedraw;
    output reg hsync;
    output reg vsync;

    reg [2:0] state, next_state;
    reg [9:0] hcount;
    reg [9:0] vcount;
    reg [2:0] count1, count2;
    output reg [7:0] hcount_slow;
    output reg [6:0] vcount_slow;

    // FSM states
    localparam  ActiveDrawing = 3'b000,
                Blanking      = 3'b001,
                HorSync       = 3'b010,
                VertSync      = 3'b011,
                HorVertSync   = 3'b100;

    // Sequential logic
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= ActiveDrawing;
        else
            state <= next_state;
    end


    // Combinational logic
    always @(*) begin
        next_state = state; // default: stay in current state
        activedraw = 1'b0;
        hsync = 1'b0;
        vsync = 1'b0;
        case (state)
            ActiveDrawing: begin
                activedraw = 1'b1;
                if (hcount == 10'd639) begin
                    next_state = Blanking;
                end
            end

            Blanking: begin
                if (vcount == 10'd489 && hcount == 10'd799) begin
                    next_state = VertSync;
                end
                else if (hcount == 10'd655) begin 
                    next_state = HorSync;
                end
                else if ((hcount == 10'd799 && vcount == 10'd524) || (hcount == 10'd799 && vcount < 10'd479)) begin 
                    next_state = ActiveDrawing;
                end
            end

            HorSync: begin
                hsync = 1'b1;
                if (hcount == 10'd751) begin
                    next_state = Blanking;
                end
            end

            VertSync: begin
                vsync = 1'b1;
                if (vcount == 10'd491 && hcount == 10'd799) begin
                    next_state = Blanking;
                 end
                 else if (hcount == 10'd655) begin
                    next_state = HorVertSync;
                end
            end

            HorVertSync: begin
                hsync = 1'b1;
                vsync = 1'b1;
                if (hcount == 10'd751) begin
                    next_state = VertSync; 
                end
            end

            default: next_state = ActiveDrawing;

        endcase
    end

    //counters 

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            hcount <= 10'd0;
        end
        else begin            
            if (hcount == 10'd799) begin                
                hcount <= 10'd0;
            end
            else begin
                hcount <= hcount + 10'd1;
            end
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count1 <= 3'd0;
            hcount_slow <= 8'd0;
        end

        else if (count1 == 3'd4) begin
            count1 <= 3'd0;
            if (hcount_slow == 8'd159) begin
                hcount_slow <= 8'd0;
            end
            else begin
                hcount_slow <= hcount_slow + 8'd1;
            end
        end
        else begin
            count1 <= count1 + 3'd1;
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            vcount <= 10'd0;
        end
        else begin
            if (hcount == 10'd799) begin
                if (vcount == 10'd524) begin                
                    vcount <= 10'd0;
                end
                else begin
                    vcount <= vcount + 10'd1;
                end
            end          
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            vcount_slow <= 7'd0;
            count2 <= 3'd0;
        end
        else begin
            if (hcount == 10'd799) begin
                if (count2 == 3'd4) begin
                    if (vcount_slow == 7'd104) begin
                        vcount_slow <= 7'd0; 
                    end
                    else begin
                        vcount_slow <= vcount_slow + 7'd1;
                    end
                    count2 <= 3'd0; 
                end
                else begin 
                    count2 <= count2 + 3'd1; 
                end
            end
        end          
    end


endmodule