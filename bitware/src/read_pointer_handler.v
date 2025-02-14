// https://vlsiverify.com/verilog/verilog-codes/asynchronous-fifo/#Read_Pointer_Handler
module rptr_handler #(parameter PTR_WIDTH = 3) (
    input wire rclk, rrst_n, r_en,
    input wire [PTR_WIDTH:0] g_wptr_sync,
    output reg [PTR_WIDTH:0] b_rptr, g_rptr,
    output reg empty
);
    reg [PTR_WIDTH:0] b_rptr_next;
    reg [PTR_WIDTH:0] g_rptr_next;
    reg rempty;

    always @ (posedge rclk) begin
        // increment our pointers if we arent empty and read enable
        b_rptr_next <= b_rptr + (r_en & !empty);
        g_rptr_next <= (b_rptr_next >> 1)^b_rptr_next;
        // we are empty if our write pointer is the next read pointer
        rempty <= (g_wptr_sync == g_rptr_next);
    end

    always @ (posedge rclk or negedge rrst_n) begin
        // if reset, make sure the read pointers are reset to zero
        if (!rrst_n) begin
            b_rptr <= 0;
            g_rptr <= 0;
        end
        // if not reset then set the read pointers to the next value (or not if condition is not met)
        else begin
            b_rptr <= b_rptr_next;
            g_rptr <= g_rptr_next;
        end
    end
    always @ (posedge rclk or negedge rrst_n) begin
        // if reset, make sure we say we are empty
        if (!rrst_n) empty <= 1;
        // else just assign empty to the real value
        else empty <= rempty;
    end
endmodule