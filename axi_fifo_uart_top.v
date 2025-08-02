module axi_fifo_uart_top (
    input wire clk,
    input wire reset,

    // AXI Write Channels
    input wire [3:0] s_axi_awaddr,
    input wire s_axi_awvalid,
    output wire s_axi_awready,

    input wire [31:0] s_axi_wdata,
    input wire s_axi_wvalid,
    output wire s_axi_wready,

    output wire [1:0] s_axi_bresp,
    output wire s_axi_bvalid,
    input wire s_axi_bready,

    // UART output
    output wire tx
);

    wire fifo_full, fifo_empty, fifo_wr_en, fifo_rd_en;
    wire [7:0] fifo_data_out, fifo_data_in;
    wire tx_done;

    // AXI Lite Slave (write only)
    axi_lite_slave axi_slave (
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
        .fifo_wr_en(fifo_wr_en),
        .fifo_wr_data(fifo_data_in),
        .fifo_full(fifo_full)
    );

    assign fifo_data_in = s_axi_wdata[7:0];

    // FIFO
    fifo #(.DATA_WIDTH(8), .DEPTH(16)) fifo_inst (
        .clk(clk),
        .reset(reset),
        .write_en(fifo_wr_en),
        .read_en(fifo_rd_en),
        .din(fifo_data_in),
        .dout(fifo_data_out),
        .full(fifo_full),
        .empty(fifo_empty)
    );

    // UART Transmitter
    uart_tx uart_tx_inst (
        .clk(clk),
        .reset(reset),
        .tx_start(~fifo_empty),
        .tx_data(fifo_data_out),
        .tx(tx),
        .tx_done(tx_done)
    );

    assign fifo_rd_en = tx_done;

endmodule
