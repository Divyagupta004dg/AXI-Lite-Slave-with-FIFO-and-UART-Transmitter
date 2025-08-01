// fifo.v - Simple parameterized FIFO (First-In-First-Out)

module fifo #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH = 16
)(
    input wire clk,
    input wire reset,
    input wire write_en,
    input wire read_en,
    input wire [DATA_WIDTH-1:0] din,
    output reg [DATA_WIDTH-1:0] dout,
    output wire full,
    output wire empty
);

    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];
    reg [$clog2(DEPTH):0] wr_ptr;
    reg [$clog2(DEPTH):0] rd_ptr;
    reg [$clog2(DEPTH+1):0] count;

    assign full = (count == DEPTH);
    assign empty = (count == 0);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
            count <= 0;
            dout <= 0;
        end else begin
            if (write_en && !full) begin
                mem[wr_ptr] <= din;
                wr_ptr <= wr_ptr + 1;
                count <= count + 1;
            end
            if (read_en && !empty) begin
                dout <= mem[rd_ptr];
                rd_ptr <= rd_ptr + 1;
                count <= count - 1;
            end
        end
    end

endmodule
