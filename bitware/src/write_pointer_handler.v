// https://vlsiverify.com/verilog/verilog-codes/asynchronous-fifo/#Write_Pointer_Handler
module wptr_handler #(parameter PTR_WIDTH = 3) (
    input wire wclk, wrst_n, w_en,
    input wire [PTR_WIDTH:0] g_rptr_sync,
    output reg [PTR_WIDTH:0] b_wptr, g_wptr,
    output reg full
);
    reg [PTR_WIDTH:0] b_wptr_next;
    reg [PTR_WIDTH:0] g_wptr_next;
    reg wfull;

    always @ (posedge wclk) begin
        // assigning the next binary pointer to our current one, plus if the condition is satisfied, not full + write enabled
        b_wptr_next <= b_wptr + (w_en & !full);
        g_wptr_next <= (b_wptr_next >> 1)^b_wptr_next;
        // checking if we are full, if the next pointer equals (the negation of the first two bits of the grey write pointer, concat with the raw last bits of the pointer)
        wfull <= (g_wptr_next == {~g_rptr_sync[PTR_WIDTH:PTR_WIDTH - 1], g_rptr_sync[PTR_WIDTH - 2:0]});
    end

    always @ (posedge wclk or negedge wrst_n) begin
        // if reset, reset pointers
        if (!wrst_n) begin
            b_wptr <= 0;
            g_wptr <= 0;
        end
        // else output the next real pointer
        else begin
            b_wptr <= b_wptr_next;
            g_wptr <= g_wptr_next;
        end
    end
    always @ (posedge wclk or negedge wrst_n) begin
        // if reset, make sure the full variable is reset
        if (!wrst_n) full <= 0;
        // if not reset, set output full to the actual if full state
        else full <= wfull;
    end
endmodule