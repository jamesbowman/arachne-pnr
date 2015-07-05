
j1a.bin: j1a.v j1a.pcf j1.v stack.v Makefile
	yosys -q  -p "hierarchy -top top ; synth_ice40 -blif j1a.blif" j1a.v stack.v j1.v uart.v
	../../bin/arachne-pnr -p j1a.pcf j1a.blif -o j1a.txt
	icebox_explain j1a.txt > j1a.ex
	icepack j1a.txt j1a.bin

clean:
	rm -f j1a.blif j1a.txt j1a.ex j1a.bin
