all: sv

sv: common_pkg.sv can_clic.sv tb_can_clic.sv 
	verilator --binary common_pkg.sv can_clic.sv tb_can_clic.sv --top-module tb_can_clic --trace --assert --timing
	obj_dir/Vtb_can_clic 
	gtkwave -a waveform.gtkw waveform.vcd 

# lint: common_pkg.sv can_clic.sv tb_can_clic.sv 
# 	verilator --lint-only common_pkg.sv can_clic.sv tb_can_clic.sv --top-module tb_can_clic --timing
	
clean: 
	rm -r obj_dir