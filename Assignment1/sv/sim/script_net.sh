source /eda/scripts/init_questa_core_prime
rm -rf work
vlib work

#COMMON
vlog -work ./work ../netlist/PROCESSOR.v

vlog -work ./work ../src/top.sv
#TB
vlog -work ./work ../TB/TB_TOP.sv

vsim -L ../src/mem_wrap -L /eda/dk/nangate45/verilog/qsim2020.4 work.TB_TOP

#vsim -L ../src/mem_wrap -L /eda/dk/nangate45/verilog/qsim2020.4 -sdftyp /TB_TOP/u_tb_top/u_PROCESSOR=../netlist/PROCESSOR.sdf work.TB_TOP
