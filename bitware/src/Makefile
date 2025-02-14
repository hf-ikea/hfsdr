testfifo:
	iverilog -o fifo_tb.out fifo_tb.v -g2012
	vvp fifo_tb.out

clean:
	rm -f fifo_tb.out
	rm -f fifotest.vcd