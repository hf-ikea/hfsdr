module top(input rx_refclk, input hdinp, input hdinn, output dsync_n);
    wire [15:0] rxd;
    wire [1:0] rx_k_ch0;
    wire [1:0] rk_disp_err_ch0;
    wire [1:0] rk_cv_err_ch0;
    wire axi_aclk;
    wire link_axi_resetn;
    wire link_irq;
    wire link_reset;
    wire device_reset;
    wire serdes_char_alignment;
    wire serdes_ready;
    wire link_rx_data;
    wire link_clk;

    wire tpl_axi_resetn;
    wire tpl_ready;
    wire adc_valid;

    DCUA DCU0_inst (
        .CH0_HDINP(hdinp),
        .CH0_HDINP(hdinn),
        .CH0_RX_REFCLK(rx_refclk),
        .CH0_FF_RX_D_0(rxd[0]),
        .CH0_FF_RX_D_1(rxd[1]),
        .CH0_FF_RX_D_2(rxd[2]),
        .CH0_FF_RX_D_3(rxd[3]),
        .CH0_FF_RX_D_4(rxd[4]),
        .CH0_FF_RX_D_5(rxd[5]),
        .CH0_FF_RX_D_6(rxd[6]),
        .CH0_FF_RX_D_7(rxd[7]),
        .CH0_FF_RX_D_8(rx_k_ch0[0]),
        .CH0_FF_RX_D_9(rk_disp_err_ch0[0]),
        .CH0_FF_RX_D_10(rk_cv_err_ch0[0]),
        .CH0_FF_RX_D_12(rxd[8]),
        .CH0_FF_RX_D_13(rxd[9]),
        .CH0_FF_RX_D_14(rxd[10]),
        .CH0_FF_RX_D_15(rxd[11]),
        .CH0_FF_RX_D_16(rxd[12]),
        .CH0_FF_RX_D_17(rxd[13]),
        .CH0_FF_RX_D_18(rxd[14]),
        .CH0_FF_RX_D_19(rxd[15]),
        .CH0_FF_RX_D_20(rx_k_ch0[1]),
        .CH0_FF_RX_D_21(rk_disp_err_ch0[0]),
        .CH0_FF_RX_D_22(rk_cv_err_ch0[0]),
        .CH0_FF_RX_PCLK(link_clk)
    );
    DCU0_inst.CH1_PROTOCOL = "JESD204";
    DCU0_inst.NUM_CHS = 1;

    axi_jesd204_rx #(
        .NUM_LANES(1),
        .NUM_LINKS(1),
        .LINK_MODE(1), // 2 - 64B/66B;  1 - 8B/10B
        .DATA_PATH_WIDTH(4),
        .TPL_DATA_PATH_WIDTH(4),
        .ASYNC_CLK(0)
    ) rx_axi (
        .s_axi_aclk(axi_aclk),
        .s_axi_aresetn(link_axi_resetn),
        //.S_AXI(),
        .irq(link_irq),
        .reset(link_reset),
        .device_reset(device_reset),
        .clk(link_clk), // must be line clock / 40 (because this is 8B/10B)
        .device_clk(link_clk), // link clock * data width / tpl data width (= link clock in this application)
        .sync(dsync_n),
        //.sysref(),
        .RX_DATA(link_rx_data),
        .phy_en_char_align(serdes_char_alignment),
        .phy_ready(serdes_ready),
    );


    jesd204_rx #(
        .NUM_LANES(1),
        .NUM_LINKS(1),
        .LINK_MODE(1)
    ) rx (
        .reset(core_reset),
        .device_reset(device_reset),
    );

    ad_ip_jesd204_tpl_adc #(
        .ID(0),
        .NUM_LANES(1),             // jesd L
        .NUM_CHANNELS(1),          // jesd M
        .SAMPLES_PER_FRAME(1),     // jesd S
        .CONVERTER_RESOLUTION(14), // jesd N
        .BITS_PER_SAMPLE(16),      // jesd NP
        .OCTETS_PER_BEAT(4),
        .TWOS_COMPLEMENT(1),
    ) jesd_tpl (
        .s_axi_aclk(axi_aclk),
        .s_axi_aresetn(tpl_axi_resetn),
        //.S_AXI(),
        .link_clk(link_clk),
        .LINK_DATA(link_rx_data),
        .enable(tpl_ready),
        .adc_valid(adc_valid),
        //.adc_data(),
        //.adc_dovf(),
    );
endmodule