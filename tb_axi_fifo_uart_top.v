`timescale 1ns / 1ps

module tb_axi_fifo_uart_top;

  reg clk;
  reg reset;

  reg [3:0] s_axi_awaddr;
  reg s_axi_awvalid;
  wire s_axi_awready;

  reg [31:0] s_axi_wdata;
  reg s_axi_wvalid;
  wire s_axi_wready;

  wire [1:0] s_axi_bresp;
  wire s_axi_bvalid;
  reg s_axi_bready;

  wire tx;

  axi_fifo_uart_top uut (
    .clk(clk),
    .reset(reset),
    .s_axi_awaddr(s_axi_awaddr),
    .s_axi_awvalid(s_axi_awvalid),
    .s_axi_awready(s_axi_awready),
    .s_axi_wdata(s_axi_wdata),
    .s_axi_wvalid(s_axi_wvalid),
    .s_axi_wready(s_axi_wready),
    .s_axi_bresp(s_axi_bresp),
    .s_axi_bvalid(s_axi_bvalid),
    .s_axi_bready(s_axi_bready),
    .tx(tx)
  );

  always #5 clk = ~clk;

  initial begin
    $dumpfile("tb_axi_fifo_uart_top.vcd");
    $dumpvars(0, tb_axi_fifo_uart_top);

    clk = 0;
    reset = 1;
    s_axi_awaddr = 4'h0;
    s_axi_awvalid = 0;
    s_axi_wdata = 32'h00000000;
    s_axi_wvalid = 0;
    s_axi_bready = 1;

    #20 reset = 0;

    // Send 3 write transactions
    repeat (3) begin
      @(posedge clk);
      s_axi_awvalid = 1;
      s_axi_wvalid  = 1;
      s_axi_wdata   = {$random} % 256;

      @(posedge clk);
      s_axi_awvalid = 0;
      s_axi_wvalid = 0;
    end

    #10000;
    $finish;
  end

endmodule
