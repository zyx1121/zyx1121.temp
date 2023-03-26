`timescale 10ns/1ns

module lab3_tb;

reg clock_50;
reg [3:0] key;
wire rgb_data;

lab3 u1 (
  .CLOCK_50(clock_50),
  .KEY(key),
  .RGB_DATA(rgb_data)
);

always
  #1 clock_50 = ~clock_50;

initial begin
  clock_50 = 0;
  key[3] = 1;

  key[3] = 0;
  #30
  key[3] = 1;

  #500_000;

  $finish;
end

initial begin
  $dumpfile("wave.vcd");
  $dumpvars(0, lab3_tb);
end

endmodule