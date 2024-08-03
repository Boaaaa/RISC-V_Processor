
source /eda/scripts/init_questa_core_prime
rm -rf work
vlib work

#COMMON
vlog -work ./work ../src/processor/COMMON/FSM.sv
vlog -work ./work ../src/processor/COMMON/MUX21.sv
vlog -work ./work ../src/processor/COMMON/MUX31.sv
vlog -work ./work ../src/processor/COMMON/reg.sv
vlog -work ./work ../src/processor/COMMON/SELGEN.sv
vlog -work ./work ../src/processor/COMMON/MUX21_EN.sv
#IF
vlog -work ./work ../src/processor/STAGE/IF/adder32.sv
vlog -work ./work ../src/processor/STAGE/IF/MUX3TO1.sv
vlog -work ./work ../src/processor/STAGE/IF/reg32_inner_if.sv
vlog -work ./work ../src/processor/STAGE/IF/IF.sv
#ID
vlog -work ./work ../src/processor/STAGE/ID/BTB.sv
vlog -work ./work ../src/processor/STAGE/ID/IMMGEN.sv
vlog -work ./work ../src/processor/STAGE/ID/decoder.sv
vlog -work ./work ../src/processor/STAGE/ID/RegisterFile.sv
vlog -work ./work ../src/processor/STAGE/ID/ID.sv
#EXE
vlog -work ./work ../src/processor/COMMON/adder/PG.sv
vlog -work ./work ../src/processor/COMMON/adder/CSA.sv
vlog -work ./work ../src/processor/COMMON/adder/G_NET.sv
vlog -work ./work ../src/processor/COMMON/adder/PG_NET.sv
vlog -work ./work ../src/processor/COMMON/adder/CLG.sv
vlog -work ./work ../src/processor/COMMON/adder/CSA_32.sv
vlog -work ./work ../src/processor/STAGE/EXE/ALU_IN_GEN.sv
vlog -work ./work ../src/processor/STAGE/EXE/CMP.sv
vlog -work ./work ../src/processor/STAGE/EXE/ALU.sv
vlog -work ./work ../src/processor/STAGE/EXE/ALU_CONTROLER.sv
vlog -work ./work ../src/processor/STAGE/EXE/PREDICT_CHECKOR.sv
vlog -work ./work ../src/processor/STAGE/EXE/EXE.sv
#MEM
vlog -work ./work ../src/processor/STAGE/MEM/MEM.sv
#WB
vlog -work ./work ../src/processor/STAGE/WB/WB.sv
#CU
vlog -work ./work ../src/processor/CU.sv
#other
vlog -work ./work ../src/processor/STAGE/ID/STALL_DETECTOR.sv
#PROCESSOR
vlog -work ./work ../src/processor/PROCESSOR.sv
#TOP
vlog -work ./work ../src/top.sv
#TB
vlog -work ./work ../TB/TB_TOP.sv

vsim -L ../src/mem_wrap work.TB_TOP -voptargs=+acc
