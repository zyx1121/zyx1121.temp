module lab3 #(
  parameter RGB_NUM_WIDTH = 4,
  parameter RGB_NUM = 8,
  parameter WHITE   = 24'b100110011001100110011001,
  parameter RED     = 24'hff0000,
  parameter GREEN   = 24'h00ff00,
  parameter BLUE    = 24'h0000ff,
  parameter YELLOW  = 24'hffff00,
  parameter CYAN    = 24'h00ffff,
  parameter MAGENTA = 24'hff00ff,
  parameter BLACK   = 24'h000000
)(
  input CLOCK_50,
  input [3:0] KEY,
  output RGB_DATA
);

  wire reset_n;
  wire [23:0] rgb_data [RGB_NUM - 1:0];
  wire [RGB_NUM_WIDTH - 1:0] rgb_index;

  assign reset_n = KEY[3];
  assign rgb_data[0] = WHITE;
  assign rgb_data[1] = RED;
  assign rgb_data[2] = GREEN;
  assign rgb_data[3] = BLUE;
  assign rgb_data[4] = YELLOW;
  assign rgb_data[5] = CYAN;
  assign rgb_data[6] = MAGENTA;
  assign rgb_data[7] = BLACK;

  ws2812_controller #(
    .RGB_NUM_WIDTH(RGB_NUM_WIDTH),
    .RGB_NUM(RGB_NUM)
  ) rgb_strip (
    .clock(CLOCK_50),
    .reset_n(reset_n),
    .data_in(rgb_data[rgb_index]),
    .data_index(rgb_index),
    .data_out(RGB_DATA)
  );

endmodule
