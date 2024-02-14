all: sv

sv: can_clic.sv tb_can_clic.sv 
	verilator --binary can_clic.sv tb_can_clic.sv --top-module tb_can_clic --trace --assert
	obj_dir/Vtb_can_clic 
	gtkwave -a waveform.gtkw waveform.vcd 


