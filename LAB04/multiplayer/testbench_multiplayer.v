`timescale 1ns / 1ps
module tb_hdmi_controller;

  // Parameters
  localparam integer CLK_PERIOD_NS = 10;     // 100MHz
  localparam integer BAUD          = 9600;   // MUST match baud_select in DUT
  localparam real    BIT_TIME_NS   = 1e9 / BAUD;

  // parity config for TX stimulus
  localparam PARITY_ENABLE = 1;   // 1 = send parity bit
  localparam PARITY_ODD    = 0;   // 0=even parity, 1=odd parity


  reg clk;
  reg rst;
  reg [3:0] paddle_speed;
  reg [3:0] puck_speed;
  reg new_game;
  reg RxD;

  wire [2:0] hdmi_tx_p;
  wire [2:0] hdmi_tx_n;
  wire hdmi_clk_p;
  wire hdmi_clk_n;
  wire led;
  wire Rx_FERROR;
  wire Rx_PERROR;
  wire Rx_VALID;

  // Instantiate hdmi
  hdmi_controller #(
    .PADDLE_WIDTH      (11'd20),
    .PADDLE_HEIGHT     (10'd50),
    .PUCK_WIDTH        (11'd30),
    .PUCK_HEIGHT       (10'd30),

    .Hor_ACTIVE_END    (10'd139),
    .Hor_BLANKING_END  (10'd140),
    .Hor_SYNC_END      (10'd143),
    .Hor_TOTAL         (10'd159),

    .Ver_BLANKING_END  (10'd140),
    .Ver_SYNC_END    (10'd141),
    .Ver_ACTIVE_END    (10'd139),
    .Ver_TOTAL         (10'd162)
    )  dut (
    .clk(clk),
    .rst(rst),
    .paddle_speed(paddle_speed),
    .puck_speed(puck_speed),
    .new_game(new_game),
    .RxD(RxD),
    .hdmi_tx_p(hdmi_tx_p),
    .hdmi_tx_n(hdmi_tx_n),
    .hdmi_clk_p(hdmi_clk_p),
    .hdmi_clk_n(hdmi_clk_n),
    .led(led),
    .Rx_FERROR(Rx_FERROR),
    .Rx_PERROR(Rx_PERROR),
    .Rx_VALID(Rx_VALID)
  );

  
  // Clock generation
  always #(CLK_PERIOD_NS/2) clk = ~clk;

  
  // UART stimulus tasks
  task uart_send_byte;
    input [7:0] data;
    input       parity_enable;
    input       parity_odd;
    integer i;
    reg parity_bit;
    begin
      // Compute parity bit
      parity_bit = ^data;            // 1 if odd number of ones
      if (parity_odd) parity_bit = ~parity_bit; // odd parity inversion

      // START bit
      RxD = 1'b0;
      #(BIT_TIME_NS);

      // 8 data bits, LSB first
      for (i = 0; i < 8; i = i + 1) begin
        RxD = data[i];
        #(BIT_TIME_NS);
      end

      // PARITY bit (optional)
      if (parity_enable) begin
        RxD = parity_bit;
        #(BIT_TIME_NS);
      end

      // STOP bit
      RxD = 1'b1;
      #(BIT_TIME_NS);

      // Inter-byte gap (nice to have)
      #(BIT_TIME_NS);
    end
  endtask

  task send_char;
    input [7:0] ch;
    begin
      $display("[%0t ns] UART send '%s' (0x%02h)", $time, ch, ch);
      uart_send_byte(ch, PARITY_ENABLE, PARITY_ODD);
    end
  endtask

  // quick “tap a key�?
  task tap;
    input [7:0] key;
    begin
      send_char(key);
    end
  endtask

  // Test sequence
  initial begin
    // init
    clk = 1'b0;
    rst = 1'b1;
    RxD = 1'b1;            // idle high
    paddle_speed = 4'd4;
    puck_speed   = 4'd4;
    new_game     = 1'b0;

    // reset pulse
    #(20*CLK_PERIOD_NS);
    rst = 1'b0;

    // give some time after reset
    #(2000);

    // start new game pulse
    new_game = 1'b1;
    #(10*CLK_PERIOD_NS);
    new_game = 1'b0;


    tap("w");   // up
    #(500_000);

    tap("w");
    #(500_000);

    tap("w");   // down
    #(500_000);

    tap("w");
    #(500_000);

    // Example for player2 (common choices: 'i' up, 'k' down)
    tap("i");
    #(500_000);
    tap("k");
    #(500_000);
    tap("k");
    #(500_000);
    tap("I");

    // Let it run a bit
    #(5_000_000);

    $finish;
  end

endmodule
