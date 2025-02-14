// https://vlsiverify.com/verilog/verilog-codes/asynchronous-fifo/#Asynchronous_FIFO_Operation
module fifo_synchronizer #(parameter WIDTH = 3) (input wire clk, rst_n, input wire [WIDTH:0] d_in, output reg [WIDTH:0] d_out);
    reg [WIDTH:0] q1;
    always @ (posedge clk) begin
        if(!rst_n) begin
            q1 <= 0;
            d_out <= 0;
        end
        else begin
            q1 <= d_in;
            d_out <= q1;
        end
    end
endmodule