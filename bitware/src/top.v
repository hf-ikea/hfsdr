module top(
    input wire adc_clk,
    input wire [13:0] adc_data,
    // FT601 interface
    input wire FT_CLK,
    inout wire [31:0] FT_DATA,   // ONLY 16 BITS USED WITHOUT DOUBLE_OUTPUT DEFINED (it is not defined right now)
    inout wire [3:0] BE,
    input wire RXF_N,    // ACK_N
    input wire TXE_N,
    output wire WR_N,    // REQ_N
    output wire SIWU_N,
    output wire RD_N,
    output wire OE_N,
);
    asynchronous_fifo #(.DEPTH(32), .DATA_WIDTH(16)) fifo(
        .wclk(adc_clk), .rclk(FT_CLK),
        .wrst_n(wrst_n), .rrst_n(rrst_n),
        .w_en(1), .r_en(!TXE_N),
        .data_in(adc_data), .data_out(FT_DATA),
        .full(fifo_full), .empty(fifo_empty));

    assign BE = 4'b1111;
    assign OE_N = 1;
endmodule