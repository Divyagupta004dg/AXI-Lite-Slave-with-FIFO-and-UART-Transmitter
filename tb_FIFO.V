`timescale 1ns / 1ps

module tb_fifo;

  parameter DATA_WIDTH = 8;
  parameter DEPTH = 16;

  reg clk;
  reg reset;
  reg write_en;
  reg read_en;
  reg [DATA_WIDTH-1:0] din;
  wire [DATA_WIDTH-1:0] dout;
  wire full;
  wire empty;

  // Instantiate FIFO (uut = Unit Under Test)
  fifo #(DATA_WIDTH, DEPTH) uut (
    .clk(clk),
    .reset(reset),
    .write_en(write_en),
    .read_en(read_en),
    .din(din),
    .dout(dout),
    .full(full),
    .empty(empty)
  );

  // Clock generation: 10ns period
  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    $dumpfile("tb_fifo.vcd");
    $dumpvars(0, tb_fifo);

    // Init
    reset = 1;
    write_en = 0;
    read_en  = 0;
    din = 0;

    #10 reset = 0;

    // Write 5 values
    repeat (5) begin
      @(posedge clk);
      write_en = 1;
      din = $random;
    end

    @(posedge clk);
    write_en = 0;

    // Read 5 values
    repeat (5) begin
      @(posedge clk);
      read_en = 1;
    end

    @(posedge clk);
    read_en = 0;

    #20 $finish;
  end

endmodule
