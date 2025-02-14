default:
	yosys top.v fifo.v -p "synth_ecp5 -json hfsdr.json -top top_mod"
	nextpnr-ecp5 --json hfsdr.json --25k --package CSFBGA285 --lpf hfsdr.lpf --lpf-allow-unconstrained

testfifo:
	iverilog -o fifo_tb.out fifo_tb.v -g2012
	vvp fifo_tb.out

clean:
	rm -f fifo_tb.out
	rm -f fifotest.vcd
	rm -f hfsdr.json