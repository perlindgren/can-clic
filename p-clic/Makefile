all: sv

sv: p_clic.sv tb_p_clic.sv 
	verilator --binary p_clic.sv tb_p_clic.sv --top-module tb_p_clic --trace --assert --timing
	obj_dir/Vtb_p_clic 
	gtkwave  waveform.vcd 

lint: p_clic.sv tb_p_clic.sv 
	verilator --lint-only p_clic.sv tb_p_clic.sv --top-module tb_p_clic --timing
	
clean: 
	rm -r obj_dir