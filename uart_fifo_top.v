module uart_fifo_top (
    input wire clk,
    input wire reset,
    input wire write_en,
    input wire [7:0] data_in,
    output wire tx,
    output wire tx_done
);

    wire fifo_empty;
    wire fifo_read_en;
    wire [7:0] fifo_out;

    // FIFO instantiation
    fifo fifo_inst (
        .clk(clk),
        .reset(reset),
        .write_en(write_en),
        .read_en(fifo_read_en),
        .din(data_in),
        .dout(fifo_out),
        .full(),         // unused
        .empty(fifo_empty)
    );

    // UART Transmitter
    uart_tx uart_tx_inst (
        .clk(clk),
        .reset(reset),
        .tx_start(!fifo_empty),
        .tx_data(fifo_out),
        .tx(tx),
        .tx_done(tx_done)
    );

    assign fifo_read_en = tx_done;

endmodule
