module top(input clk, input hdinp, input hdinn);

    wire [15:0] rxd;
    wire [1:0] rx_k_ch0;
    wire [1:0] rk_disp_err_ch0;
    wire [1:0] rk_cv_err_ch0;
    DCUA DCU0_inst (
        .CH0_HDINP(hdinp),
        .CH0_HDINP(hdinn),
        .CH0_RX_REFCLK(clk),
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
    );

    DCU0_inst.CH1_PROTOCOL = "JESD204";
    DCU0_inst.NUM_CHS = 1;
endmodule