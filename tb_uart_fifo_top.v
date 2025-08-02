`timescale 1ns/1ps

module tb_uart_fifo_top;

  reg clk;
  reg reset;
  reg write_en;
  reg [7:0] data_in;
  wire tx;
  wire tx_done;

  uart_fifo_top uut (
    .clk(clk),
    .reset(reset),
    .write_en(write_en),
    .data_in(data_in),
    .tx(tx),
    .tx_done(tx_done)
  );

  always #5 clk = ~clk;

  initial begin
    $dumpfile("tb_uart_fifo_top.vcd");
    $dumpvars(0, tb_uart_fifo_top);

    clk = 0;
    reset = 1;
    write_en = 0;
    data_in = 0;

    #20 reset = 0;

    // Send some data into FIFO
    repeat (4) begin
      @(posedge clk);
      write_en = 1;
      data_in = $random;
    end

    @(posedge clk);
    write_en = 0;

    #10000 $finish;
  end

endmodule
