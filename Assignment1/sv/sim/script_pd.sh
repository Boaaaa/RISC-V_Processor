source /eda/scripts/init_questa_core_prime
rm -rf work
vlib work

#COMMON
vlog -work ./work ../innovus/PROCESSOR.v

vlog -work ./work ../src/top.sv
#TB
vlog -work ./work ../TB/TB_TOP.sv

#vsim -L ../src/mem_wrap -L /eda/dk/nangate45/verilog/qsim2020.4 work.TB_TOP

vsim -L ../src/mem_wrap -L /eda/dk/nangate45/verilog/qsim2020.4 -sdfmax /TB_TOP/u_tb_top/u_PROCESSOR=../innovus/PROCESSOR.sdf work.TB_TOP
