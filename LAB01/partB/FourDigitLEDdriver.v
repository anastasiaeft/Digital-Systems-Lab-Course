`timescale 1ns/1ps
// `include "merosA.v"
// `include "odhghsh_KATHODON.v"
// `include "odhghsh_ANODON.v"
// `include "counter.v"

module FourDigitLEDdriver(reset, clk, button, an3, an2, an1, an0, a, b, c, d, e, f, g, dp);
    input clk, reset, button;
    output an3, an2, an1, an0;
    output a, b, c, d, e, f, g, dp;
    wire clk_slow, clk_fb, locked;
    wire [3:0] count;
    wire [3:0] char;
    wire [3:0] digit1 , digit2 , digit3 , digit4 ;
    wire [6:0] LED;
    wire [3:0] addr_mes;
    wire [6:0] mycounter;
    wire new_button, new_reset;

   // MMCME2_BASE: Base Mixed Mode Clock Manager
   //              Artix-7
   // Xilinx HDL Language Template, version 2018.3

   MMCME2_BASE #(
      .BANDWIDTH("OPTIMIZED"),   // Jitter programming (OPTIMIZED, HIGH, LOW)
      .CLKFBOUT_MULT_F(6),     // Multiply value for all CLKOUT (2.000-64.000).
      .CLKFBOUT_PHASE(0.0),      // Phase offset in degrees of CLKFB (-360.000-360.000).
      .CLKIN1_PERIOD(10.000),       // Input clock period in ns to ps resolution (i.e. 33.333 is 30 MHz).
      // CLKOUT0_DIVIDE - CLKOUT6_DIVIDE: Divide amount for each CLKOUT (1-128)
      .CLKOUT1_DIVIDE(120),

      // CLKOUT0_DUTY_CYCLE - CLKOUT6_DUTY_CYCLE: Duty cycle for each CLKOUT (0.01-0.99).
      
      .CLKOUT1_DUTY_CYCLE(0.5),
      // CLKOUT0_PHASE - CLKOUT6_PHASE: Phase offset for each CLKOUT (-360.000-360.000).

      .CLKOUT1_PHASE(0.0),

      .DIVCLK_DIVIDE(1),         // Master division value (1-106)
      .REF_JITTER1(0.0),         // Reference input jitter in UI (0.000-0.999).
      .STARTUP_WAIT("FALSE")     // Delays DONE until MMCM is locked (FALSE, TRUE)
   )

   MMCME2_BASE_inst (
      // Clock Outputs: 1-bit (each) output: User configurable clock outputs
   
      
      .CLKOUT1(clk_slow),     // 1-bit output: CLKOUT1
      
      // Feedback Clocks: 1-bit (each) output: Clock feedback ports
      .CLKFBOUT(clk_fb),   // 1-bit output: Feedback clock
      // Status Ports: 1-bit (each) output: MMCM status ports
      .LOCKED(locked),       // 1-bit output: LOCK
      // Clock Inputs: 1-bit (each) input: Clock input
      .CLKIN1(clk),       // 1-bit input: Clock
      // Control Ports: 1-bit (each) input: MMCM control ports
      .PWRDWN(1'b0),       // 1-bit input: Power-down
      .RST(reset),             // 1-bit input: Reset
      // Feedback Clocks: 1-bit (each) input: Clock feedback ports
      .CLKFBIN(clk_fb)      // 1-bit input: Feedback clock
   );

   // End of MMCME2_BASE_inst instantiation

   counter counter1(.clk(clk_slow), .reset(new_reset), .state(count));
   AnodeDriving anodedr(.count(count), .an3(an3), .an2(an2), .an1(an1), .an0(an0));
   reset_synchr sync_reset(.clk(clk_slow), .reset(reset), .synchr_reset(new_reset));
   button_deb debounce(.clk(clk_slow), .button(button), .out_pulse(new_button));
   // counter_D addr2(.clk(clk_slow), .reset(new_reset), .addr(addr_mes)); 
   counter_D addr2(.clk(clk_slow), .reset(new_reset), .counter(mycounter)); 
   pointer pointer_inst(clk_slow, new_reset, mycounter, addr_mes);

   MessageRotator msg_digits(.clk(clk_slow), .reset(new_reset), .addr_mes(addr_mes), .digits1(digit1), .digits2(digit2), .digits3(digit3), .digits4(digit4));
   LEDdecoder LEDdecoder_inst(.char(char), .LED(LED));

   //KathodeDriving kathodedr(.count(count), .char(char)); // Meros B
   //address addr1(.clk(clk),.button(new_button), .rst(new_reset), .addr(addr_mes)); // Meros C
   KathodeDriving2 kathodedr(.count(count), .digit1(digit1), .digit2(digit2), .digit3(digit3), .digit4(digit4), .char(char));	// Meros D

   assign {a,b,c,d,e,f,g} = LED;
   assign dp=1'b1;

endmodule