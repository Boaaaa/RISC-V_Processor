source /eda/scripts/init_questa_core_prime
rm -rf work
vlib work

#COMMON
vlog -work ./work ../src/SSRAM/sram_32_1024_freepdk45/sram_32_1024_freepdk45.v
#vlog -work ./work ../src/SSRAM/lfsr.sv
#vlog -work ./work ../src/SSRAM/mem_wrap_fake.sv
#vlog -work ./work ../netlist/PROCESSOR.v
vlog -work ./work ../netlist/top.v
#TB
vlog -work ./work ../tb/TB_TOP.sv

vsim -L /eda/dk/nangate45/verilog/qsim2020.4  work.TB_TOP
