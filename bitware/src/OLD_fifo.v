module fifo (
    output RESET_N, // active low chip reset

    input CLK,   // clk input from ft chip @ 100MHz
    input TXE_N, // chip fifo empty, ft chip ready to recieve data, only write when logic 0 (minimum of 1 byte space to write)
    input RXF_N, // chip fifo full, ft chip ready to send data to us, only read when logic 0 (minimum of 1 byte to read)

    output WR_N, // write enable, pull to logic 0 when we want to write to the ft chip
    output RD_N, // read enable, pull to logic 0 when we want to read from the ft chip
    output OE_N, // when pulled to logic 0 by us, ft chip will drive the data + byte enable buses

    inout [31:0] DATA,
    inout [3:0] BE,
);
    reg [15:0] fifo_ram[0:31]; // holds 16 operations, two 14 samples, each padded to 16 bits
    reg [3:0] read_pointer, write_pointer; // pointer of 0 to 15 (4 bits)
    wire internal_full; // active high when we want to write from our fifo to the ft chip fifo

    wire reset_fifo; // active high reset

    always @ (posedge CLK) begin // write to outside fifo (read from internal)
        if (internal_full and !TXE_N) begin
            WR_N <= 0;
            BE <= 4'b1111;
            DATA[31:0] <= fifo_ram[read_pointer];
            write_pointer <= read_pointer;
            read_pointer <= read_pointer + 1;
            BE <= 0;
            WR_N <= 1;
        end
    end

    always @ (posedge CLK) begin // pointer op
        if (reset_fifo) begin
            read_pointer <= 0;
            write_pointer <= 0;
        end
    end
endmodule