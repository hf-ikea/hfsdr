`include "proto245s.sv"
module top (
    input wire adc_clk,
    input wire [13:0] adc_data,
    // FT601 interface
    input wire FT_CLK,
    inout wire [31:0] FT_DATA,
    inout wire [3:0] BE,
    input wire RXF_N,    // ACK_N
    input wire TXE_N,
    input wire RESET_N,
    output wire WR_N,    // REQ_N
    output wire SIWU_N,
    output wire RD_N,
    output wire OE_N
);
    wire txfifo_rst;
    wire txfifo_wr;
    proto245s #(.DATA_W(32)) fifo (
        .ft_rst(RESET_N),
        .ft_clk(FT_CLK),
        .ft_rxfn(RXF_N),
        .ft_txen(TXE_N),
        //.ft_din(),
        .ft_dout(FT_DATA),
        .ft_bein(BE),
        .ft_beout(BE),
        .ft_rdn(RD_N),
        .ft_wrn(WR_N),
        .ft_oen(OE_N),
        .ft_siwu(SIWU_N),
        .txfifo_clk(adc_clk),
        .txfifo_rst(txfifo_rst),
        .txfifo_data(adc_data),
        .txfifo_wr(txfifo_wr)
    );
endmodule