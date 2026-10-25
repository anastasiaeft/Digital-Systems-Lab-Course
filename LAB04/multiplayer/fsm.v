`timescale 1ns/1ps
module fsm_hdmi(clk, reset, activedraw, hsync, vsync, hcount, vcount);
    input clk, reset;
    output reg activedraw;
    output reg hsync;
    output reg vsync;

    reg [2:0] state, next_state;
    output reg [9:0] hcount;
    output reg [9:0] vcount;
    reg [2:0] count1, count2;
    // reg [7:0] hcount_slow;
    // reg [6:0] vcount_slow;

    // Timing parameters
    parameter H_ACTIVE_END   = 10'd639;   // End of active drawing horizontally
    parameter H_BLANKING_END = 10'd655;   // End of blanking, start of hsync
    parameter H_SYNC_END     = 10'd751;   // End of hsync
    parameter H_TOTAL        = 10'd799;   // Total horizontal count

    parameter V_BLANKING_END = 10'd489;   // End of blanking vertically (480p)
    parameter V_SYNC_END   = 10'd491;   // Start of vertical sync
    parameter V_ACTIVE_END   = 10'd479;   // Below sync threshold
    parameter V_TOTAL        = 10'd524;   // Total vertical count

    parameter H_SLOW_MAX     = 8'd159;    // Horizontal slow counter max (160 pixels)
    parameter V_SLOW_MAX     = 7'd104;    // Vertical slow counter max (105 pixels)
    parameter COUNT_MAX      = 3'd4;      // Counter max for dividing clock

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
                if (hcount == H_ACTIVE_END) begin
                    next_state = Blanking;
                end
            end

            Blanking: begin
                if (vcount == V_BLANKING_END && hcount == H_TOTAL) begin
                    next_state = VertSync;
                end
                else if (hcount == H_BLANKING_END) begin 
                    next_state = HorSync;
                end
                else if ((hcount == H_TOTAL && vcount == V_TOTAL) || (hcount == H_TOTAL && vcount < V_ACTIVE_END)) begin 
                    next_state = ActiveDrawing;
                end
            end

            HorSync: begin
                hsync = 1'b1;
                if (hcount == H_SYNC_END) begin
                    next_state = Blanking;
                end
            end

            VertSync: begin
                vsync = 1'b1;
                if (vcount == V_SYNC_END && hcount == H_TOTAL) begin
                    next_state = Blanking;
                 end
                 else if (hcount == H_BLANKING_END) begin
                    next_state = HorVertSync;
                end
            end

            HorVertSync: begin
                hsync = 1'b1;
                vsync = 1'b1;
                if (hcount == H_SYNC_END) begin
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
            if (hcount == H_TOTAL) begin                
                hcount <= 10'd0;
            end
            else begin
                hcount <= hcount + 10'd1;
            end
        end
    end

    // always @(posedge clk or posedge reset) begin
    //     if (reset) begin
    //         count1 <= 3'd0;
    //         hcount_slow <= 8'd0;
    //     end

    //     else if (count1 == COUNT_MAX) begin
    //         count1 <= 3'd0;
    //         if (hcount_slow == H_SLOW_MAX) begin
    //             hcount_slow <= 8'd0;
    //         end
    //         else begin
    //             hcount_slow <= hcount_slow + 8'd1;
    //         end
    //     end
    //     else begin
    //         count1 <= count1 + 3'd1;
    //     end
    // end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            vcount <= 10'd0;
        end
        else begin
            if (hcount == H_TOTAL) begin
                if (vcount == V_TOTAL) begin                
                    vcount <= 10'd0;
                end
                else begin
                    vcount <= vcount + 10'd1;
                end
            end          
        end
    end

    // always @(posedge clk or posedge reset) begin
    //     if (reset) begin
    //         vcount_slow <= 7'd0;
    //         count2 <= 3'd0;
    //     end
    //     else begin
    //         if (hcount == H_TOTAL) begin
    //             if (count2 == COUNT_MAX) begin
    //                 if (vcount_slow == V_SLOW_MAX) begin
    //                     vcount_slow <= 7'd0; 
    //                 end
    //                 else begin
    //                     vcount_slow <= vcount_slow + 7'd1;
    //                 end
    //                 count2 <= 3'd0; 
    //             end
    //             else begin 
    //                 count2 <= count2 + 3'd1; 
    //             end
    //         end
    //     end          
    // end


endmodule