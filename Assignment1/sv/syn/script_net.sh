source /eda/scripts/init_questa_core_prime
rm -rf work
vlib work

#COMMON
vlog -work ./work ../netlist/top.v
#TB
vlog -work ./work ../tb/TB_TOP.sv

vsim -L /eda/dk/nangate45/verilog/qsim2020.4  work.TB_TOP
vsim -L ../src/mem_wrap -L /eda/dk/nangate45/verilog/qsim2020.4 -sdftyp /TB_TOP/UUT=../netlist/top.sdf work.TB_TOP_NET

add wave *

run 20 us
