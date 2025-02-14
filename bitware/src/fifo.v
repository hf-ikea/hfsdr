// https://vlsiverify.com/verilog/verilog-codes/asynchronous-fifo/#Top_Module
`include "fifo_synchronizer.v"
`include "fifo_memory.v"
`include "write_pointer_handler.v"
`include "read_pointer_handler.v"

module asynchronous_fifo #(parameter DEPTH = 32, DATA_WIDTH = 16) (
    input wire wclk, wrst_n,
    input wire rclk, rrst_n,
    input wire w_en, r_en,
    input wire [DATA_WIDTH - 1:0] data_in,
    `ifdef DOUBLE_OUTPUT
        output wire [31:0] data_out,
    `else
        output wire [DATA_WIDTH - 1:0] data_out,
    `endif
    output wire full, empty
);
    parameter PTR_WIDTH = $clog2(DEPTH);

    wire [PTR_WIDTH:0] g_wptr_sync, g_rptr_sync;
    wire [PTR_WIDTH:0] b_wptr, b_rptr;
    wire [PTR_WIDTH:0] g_wptr, g_rptr;

    wire [PTR_WIDTH - 1:0] waddr, raddr;

    fifo_synchronizer #(PTR_WIDTH) sync_wptr (.clk(rclk), .rst_n(rrst_n), .d_in(g_wptr), .d_out(g_wptr_sync));
    fifo_synchronizer #(PTR_WIDTH) sync_rptr (.clk(wclk), .rst_n(wrst_n), .d_in(g_rptr), .d_out(g_rptr_sync));

    wptr_handler #(PTR_WIDTH) wptr_h(.wclk(wclk), .wrst_n(wrst_n), .w_en(w_en), .g_rptr_sync(g_rptr_sync), .b_wptr(b_wptr), .g_wptr(g_wptr), .full(full));
    rptr_handler #(PTR_WIDTH) rptr_h(.rclk(rclk), .rrst_n(rrst_n), .r_en(r_en), .g_wptr_sync(g_wptr_sync), .b_rptr(b_rptr), .g_rptr(g_rptr), .empty(empty));
    fifo_memory #(.DEPTH(DEPTH), .DATA_WIDTH(DATA_WIDTH), .PTR_WIDTH(PTR_WIDTH))fifomemory(.wclk(wclk), .w_en(w_en), .rclk(rclk), .r_en(r_en), .b_wptr(b_wptr), .b_rptr(b_rptr), .data_in(data_in), .full(full), .empty(empty), .data_out(data_out));
endmodule