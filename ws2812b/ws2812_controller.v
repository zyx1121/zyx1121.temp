//
//  period 1200ns
//    * 0   code : 400ns high, 800ns low
//    * 1   code : 800ns high, 400ns low
//    * rst code : 50000ns high
//
//  clock 50MHz -> 20ns
//

module ws2812_controller #(
  parameter RGB_NUM_WIDTH = 4,
  parameter RGB_NUM = 8,
  parameter DIV_WIDTH = 5,
  parameter DIV = 20
)(
  input clock,
  input reset_n,
  input [23:0] data_in,
  output reg [RGB_NUM_WIDTH - 1:0] data_index,
  output reg data_out
);

  reg [2:0] status;
  reg [DIV_WIDTH - 1:0] counter;
  reg [6:0] rst_counter;
  reg [4:0] bit_index;
  reg clock_400ns;

  localparam RST  = 3'd0;
  localparam LO_0 = 3'd1;
  localparam LO_1 = 3'd2;
  localparam HI_0 = 3'd3;
  localparam HI_1 = 3'd4;
  localparam DONE = 3'd5;

  always @(posedge clock, negedge reset_n) begin
    if (!reset_n) begin

      counter     <= 1'b0;
      clock_400ns <= 1'b0;

    end else begin

      counter     <= (counter == DIV - 1'b1) ? 1'b0 : counter + 1'b1;
      clock_400ns <= (counter == DIV - 1'b1) ? ~clock_400ns : clock_400ns;

    end
  end

  always @(posedge clock_400ns, negedge reset_n) begin
    if (!reset_n) begin

      status      <= RST;
      bit_index   <= 1'b0;
      data_index  <= 1'b0;
      rst_counter <= 1'b0;

    end else begin

      case (status)
        RST: begin
          status      <= (rst_counter == 7'd125) ? (data_in[bit_index] == 1'b0) ? LO_0 : HI_0 : RST;
          rst_counter <= (rst_counter == 7'd125) ? 1'b0 : rst_counter + 1'b1;
        end

        LO_0: begin
          status <= LO_1;
        end

        LO_1: begin
          status <= DONE;
        end

        HI_0: begin
          status <= HI_1;
        end

        HI_1: begin
          status <= DONE;
        end

        DONE: begin
          status     <= (data_index == RGB_NUM - 1'b1 && bit_index == 5'd23) ? RST : (data_in[bit_index] == 1'b0) ? LO_0 : HI_0;
          bit_index  <= (bit_index == 5'd23) ? 1'b0 : bit_index + 1'b1;
          data_index <= (bit_index == 5'd23) ? (data_index == RGB_NUM - 1'b1) ? 1'b0 : data_index + 1'b1 : data_index;
        end

        default: begin
          status      <= RST;
          bit_index   <= 1'b0;
          data_index  <= 1'b0;
          rst_counter <= 1'b0;
        end

      endcase

    end
  end

  always @(*) begin
    if (!reset_n) begin

      data_out <= 1'b0;

    end else begin

      case (status)

        RST: begin
          data_out <= 1'b1;
        end

        LO_0: begin
          data_out <= 1'b1;
        end

        LO_1: begin
          data_out <= 1'b0;
        end

        HI_0: begin
          data_out <= 1'b1;
        end

        HI_1: begin
          data_out <= 1'b1;
        end

        DONE: begin
          data_out <= 1'b0;
        end

        default: begin
          data_out <= 1'b1;
        end

      endcase

    end
  end

endmodule
