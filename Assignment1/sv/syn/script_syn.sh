source /eda/scripts/init_design_vision
rm -rf work
mkdir work

dc_shell-xg-t

analyze -f sverilog -lib WORK ../src/processor/COMMON/FSM.sv
analyze -f sverilog -lib WORK ../src/processor/COMMON/MUX21.sv
analyze -f sverilog -lib WORK ../src/processor/COMMON/MUX31.sv
analyze -f sverilog -lib WORK ../src/processor/COMMON/reg.sv
analyze -f sverilog -lib WORK ../src/processor/COMMON/SELGEN.sv
analyze -f sverilog -lib WORK ../src/processor/COMMON/MUX21_EN.sv

analyze -f sverilog -lib WORK ../src/processor/STAGE/IF/adder32.sv
analyze -f sverilog -lib WORK ../src/processor/STAGE/IF/MUX3TO1.sv
analyze -f sverilog -lib WORK ../src/processor/STAGE/IF/reg32_inner_if.sv
analyze -f sverilog -lib WORK ../src/processor/STAGE/IF/IF.sv

analyze -f sverilog -lib WORK ../src/processor/STAGE/ID/BTB.sv
analyze -f sverilog -lib WORK ../src/processor/STAGE/ID/IMMGEN.sv
analyze -f sverilog -lib WORK ../src/processor/STAGE/ID/decoder.sv
analyze -f sverilog -lib WORK ../src/processor/STAGE/ID/RegisterFile.sv
analyze -f sverilog -lib WORK ../src/processor/STAGE/ID/ID.sv

analyze -f sverilog -lib WORK ../src/processor/COMMON/adder/PG.sv
analyze -f sverilog -lib WORK ../src/processor/COMMON/adder/CSA.sv
analyze -f sverilog -lib WORK ../src/processor/COMMON/adder/G_NET.sv
analyze -f sverilog -lib WORK ../src/processor/COMMON/adder/PG_NET.sv
analyze -f sverilog -lib WORK ../src/processor/COMMON/adder/CLG.sv
analyze -f sverilog -lib WORK ../src/processor/COMMON/adder/CSA_32.sv
analyze -f sverilog -lib WORK ../src/processor/STAGE/EXE/ALU_IN_GEN.sv
analyze -f sverilog -lib WORK ../src/processor/STAGE/EXE/CMP.sv
analyze -f sverilog -lib WORK ../src/processor/STAGE/EXE/ALU.sv
analyze -f sverilog -lib WORK ../src/processor/STAGE/EXE/ALU_CONTROLER.sv
analyze -f sverilog -lib WORK ../src/processor/STAGE/EXE/PREDICT_CHECKOR.sv
analyze -f sverilog -lib WORK ../src/processor/STAGE/EXE/EXE.sv
analyze -f sverilog -lib WORK ../src/processor/STAGE/MEM/MEM.sv

analyze -f sverilog -lib WORK ../src/processor/STAGE/WB/WB.sv

analyze -f sverilog -lib WORK ../src/processor/CU.sv

analyze -f sverilog -lib WORK ../src/processor/STAGE/ID/STALL_DETECTOR.sv

analyze -f sverilog -lib WORK ../src/processor/PROCESSOR.sv


set power_preserve_rtl_hier_names true

elaborate PROCESSOR

create_clock -name MY_CLK -period 3.0 CLK

set_dont_touch_network MY_CLK

set_clock_uncertainty 0.07 [get_clocks MY_CLK]

set_input_delay 0.5 -max -clock MY_CLK [remove_from_collection [all_inputs] CLK]

set_output_delay 0.5 -max -clock MY_CLK [all_outputs]

set OLOAD [load_of NangateOpenCellLibrary/BUF_X4/A]

set_load $OLOAD [all_outputs]

compile

report_timing > timing.txt

report_area > area.txt

ungroup -all -flatten

change_names -hierarchy -rules verilog

write_sdf ../netlist/PROCESSOR.sdf

write -f verilog -hierarchy -output ../netlist/PROCESSOR.v

write_sdc ../netlist/PROCESSOR.sdc

