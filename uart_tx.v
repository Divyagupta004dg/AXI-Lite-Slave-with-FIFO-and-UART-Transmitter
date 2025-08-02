// File: rtl/uart_tx.v

module uart_tx (
    input wire clk,          // System clock
    input wire reset,        // Active high reset
    input wire tx_start,     // Signal to start transmission
    input wire [7:0] tx_data,// Byte to transmit
    output reg tx,           // Serial output
    output reg tx_done       // Transmission done flag
);
    parameter CLK_FREQ = 50000000;   // 50 MHz
    parameter BAUD_RATE = 9600;

    localparam CLKS_PER_BIT = CLK_FREQ / BAUD_RATE;
    localparam TOTAL_BITS = 10; // Start + 8 data + Stop

    reg [3:0] bit_index;
    reg [13:0] clk_count;
    reg [9:0] shift_reg;
    reg sending;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            tx <= 1'b1;  // Idle is high
            tx_done <= 1'b0;
            clk_count <= 0;
            bit_index <= 0;
            shift_reg <= 10'b1111111111;
            sending <= 0;
        end else begin
            if (tx_start && !sending) begin
                // Load start bit + data + stop bit
                shift_reg <= {1'b1, tx_data, 1'b0}; // MSB first
                sending <= 1;
                clk_count <= 0;
                bit_index <= 0;
                tx_done <= 0;
            end else if (sending) begin
                if (clk_count < CLKS_PER_BIT - 1) begin
                    clk_count <= clk_count + 1;
                end else begin
                    clk_count <= 0;
                    tx <= shift_reg[0];
                    shift_reg <= {1'b1, shift_reg[9:1]}; // Shift right
                    bit_index <= bit_index + 1;

                    if (bit_index == TOTAL_BITS - 1) begin
                        sending <= 0;
                        tx_done <= 1;
                    end
                end
            end else begin
                tx_done <= 0;
                tx <= 1'b1; // idle high
            end
        end
    end
endmodule
