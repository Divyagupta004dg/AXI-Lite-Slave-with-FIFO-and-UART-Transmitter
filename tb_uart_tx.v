`timescale 1ns/1ps

module tb_uart_tx;

  reg clk;
  reg reset;                // 🔄 Changed from rst to reset
  reg tx_start;
  reg [7:0] tx_data;
  wire tx;
  wire tx_done;             // 🔄 Changed from tx_busy to tx_done

  // Instantiate UART Transmitter
  uart_tx uut (
    .clk(clk),
    .reset(reset),         // 🔄 match with RTL port name
    .tx_start(tx_start),
    .tx_data(tx_data),
    .tx(tx),
    .tx_done(tx_done)      // 🔄 match with RTL port name
  );

  // Clock generation: 10ns period = 100MHz
  always #5 clk = ~clk;

  initial begin
    $dumpfile("tb_uart_tx.vcd");
    $dumpvars(0, tb_uart_tx);

    clk = 0;
    reset = 1;
    tx_start = 0;
    tx_data = 8'h00;

    #20;
    reset = 0;

    #40;
    tx_data = 8'hA5;      // Example byte to send
    tx_start = 1;

    #10;
    tx_start = 0;         // Deassert start

    #50000;               // Wait enough time for UART to finish sending
    $finish;
  end

endmodule
