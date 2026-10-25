//anti-bounce for a button from FPGA 
//perimenoume merika ms (20ms=2ekat. kykloi rologiou) na hremhsei to koumpi
`timescale 1ns/1ps
module ButtonDeb(clk, button, out_pulse);

    input clk, button;
    output reg out_pulse; //statheropoihmeno koumpi

    reg synchr_button = 0;
    reg temp = 0;
    reg [2:0] counter = 0;
    reg stable_button = 0;  // σταθεροποιημένο κουμπί
    reg prev_stable = 0;    // προηγούμενη τιμή του σταθεροποιημένου κουμπιού

    // Συγχρονισμός του button στο ρολόι
    always @(posedge clk) begin
        synchr_button <= button;
        temp <= synchr_button;
    end

    // Debouncing
    always @(posedge clk) begin
        if (synchr_button == temp) begin
            if (counter == 3'd2)
                stable_button <= synchr_button;
            else
                counter <= counter + 1;
        end else begin
            counter <= 0;
        end
    end

    
    always @(posedge clk) begin
        prev_stable <= stable_button;
        out_pulse <= (stable_button & ~prev_stable);
    end

endmodule