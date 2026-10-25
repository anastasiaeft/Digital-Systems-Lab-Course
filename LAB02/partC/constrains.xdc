# clk input is from the 100 MHz oscillator on Boolean board
#create_clock -period 10.000 -name gclk [get_ports clk_100MHz]
set_property -dict {PACKAGE_PIN F14 IOSTANDARD LVCMOS33} [get_ports {clk}];
create_clock -add -name sys_clk -period 10.00 -waveform {0 5} [get_ports {clk}];

## UART
set_property -dict {PACKAGE_PIN V12 IOSTANDARD LVCMOS33} [get_ports {RxD}];

## BAUD SELECT SWITCHES
set_property -dict {PACKAGE_PIN L1 IOSTANDARD LVCMOS33} [get_ports {baud_select[0]}];
set_property -dict {PACKAGE_PIN K2 IOSTANDARD LVCMOS33} [get_ports {baud_select[1]}];
set_property -dict {PACKAGE_PIN K1 IOSTANDARD LVCMOS33} [get_ports {baud_select[2]}];

## INPUT SIGNALS
set_property -dict {PACKAGE_PIN N1 IOSTANDARD LVCMOS33} [get_ports {Rx_EN}];
set_property -dict {PACKAGE_PIN J2 IOSTANDARD LVCMOS33} [get_ports {reset}];

## DATA LEDS
set_property -dict {PACKAGE_PIN G1 IOSTANDARD LVCMOS33} [get_ports {Rx_DATA[0]}];
set_property -dict {PACKAGE_PIN G2 IOSTANDARD LVCMOS33} [get_ports {Rx_DATA[1]}];
set_property -dict {PACKAGE_PIN F1 IOSTANDARD LVCMOS33} [get_ports {Rx_DATA[2]}];
set_property -dict {PACKAGE_PIN F2 IOSTANDARD LVCMOS33} [get_ports {Rx_DATA[3]}];
set_property -dict {PACKAGE_PIN E1 IOSTANDARD LVCMOS33} [get_ports {Rx_DATA[4]}];
set_property -dict {PACKAGE_PIN E2 IOSTANDARD LVCMOS33} [get_ports {Rx_DATA[5]}];
set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports {Rx_DATA[6]}];
set_property -dict {PACKAGE_PIN E5 IOSTANDARD LVCMOS33} [get_ports {Rx_DATA[7]}];

## OUTPUT SIGNALS
set_property -dict {PACKAGE_PIN A3 IOSTANDARD LVCMOS33} [get_ports {Rx_FERROR}];
set_property -dict {PACKAGE_PIN B4 IOSTANDARD LVCMOS33} [get_ports {Rx_PERROR}];
set_property -dict {PACKAGE_PIN A4 IOSTANDARD LVCMOS33} [get_ports {Rx_VALID}];