module axi_lite_slave #
(
    parameter ADDR_WIDTH = 4,
    parameter DATA_WIDTH = 32
)(
    input wire clk,
    input wire reset,

    // AXI Lite write address channel
    input wire [ADDR_WIDTH-1:0] s_axi_awaddr,
    input wire s_axi_awvalid,
    output reg s_axi_awready,

    // AXI Lite write data channel
    input wire [DATA_WIDTH-1:0] s_axi_wdata,
    input wire s_axi_wvalid,
    output reg s_axi_wready,

    // AXI Lite write response channel
    output reg [1:0] s_axi_bresp,
    output reg s_axi_bvalid,
    input wire s_axi_bready,

    // FIFO Interface
    output reg fifo_wr_en,
    output reg [7:0] fifo_wr_data,
    input wire fifo_full
);

    // AXI states
    localparam [1:0] IDLE = 2'd0,
                     WRITE = 2'd1,
                     RESP = 2'd2;

    reg [1:0] state, next_state;

    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    always @(*) begin
        // Defaults
        s_axi_awready = 0;
        s_axi_wready  = 0;
        s_axi_bresp   = 2'b00;
        s_axi_bvalid  = 0;
        fifo_wr_en    = 0;
        fifo_wr_data  = 8'd0;

        case (state)
            IDLE: begin
                if (s_axi_awvalid && s_axi_wvalid && !fifo_full) begin
                    s_axi_awready = 1;
                    s_axi_wready  = 1;
                    fifo_wr_en    = 1;
                    fifo_wr_data  = s_axi_wdata[7:0]; // Use only LSB
                    next_state    = RESP;
                end else begin
                    next_state = IDLE;
                end
            end

            RESP: begin
                s_axi_bvalid = 1;
                s_axi_bresp  = 2'b00; // OKAY
                if (s_axi_bready)
                    next_state = IDLE;
                else
                    next_state = RESP;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule
