// https://vlsiverify.com/verilog/verilog-codes/asynchronous-fifo/#FIFO_Memory
module fifo_memory #(parameter DEPTH = 32, DATA_WIDTH = 16, PTR_WIDTH = 3) (
    input wire wclk, w_en, rclk, r_en,
    input wire [PTR_WIDTH:0] b_wptr, b_rptr,
    input wire [DATA_WIDTH - 1:0] data_in,
    input wire full, empty,
    output reg [DATA_WIDTH - 1:0] data_out
);
    reg [DATA_WIDTH - 1:0] fifo[0:DEPTH - 1];

    always @ (posedge wclk) begin
        // if we write and we arent full, then set fifo at the write pointer to the data input
        if (w_en & !full) begin
            fifo[b_wptr[PTR_WIDTH - 1:0]] <= data_in;
        end
        `ifdef DOUBLE_OUTPUT
            data_out[15:0] <= fifo[b_rptr[PTR_WIDTH - 1:0]];
            data_out[31:16] <= fifo[b_rptr[PTR_WIDTH - 1:0] + 1]; // overflow? whatever, rptr still needs to be incremented
        `else
            data_out <= fifo[b_rptr[PTR_WIDTH - 1:0]];
        `endif
    end
endmodule