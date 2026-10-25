
module level_sync (
  input  wire clk,
  input  wire rst,
  input  wire d,
  output reg  q
);
  reg ff1;
  always @(posedge clk) begin
    if (rst) begin ff1 <= 1'b0; q <= 1'b0; end
    else begin ff1 <= d; q <= ff1; end
  end
endmodule
