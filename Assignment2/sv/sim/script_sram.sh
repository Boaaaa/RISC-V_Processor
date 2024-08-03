
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
vlog -work ./work ../src/processor/stage/IF/adder32.sv
vlog -work ./work ../src/processor/stage/IF/MUX3TO1.sv
vlog -work ./work ../src/processor/stage/IF/reg32_inner_if.sv
vlog -work ./work ../src/processor/stage/IF/IF.sv
#ID
vlog -work ./work ../src/processor/stage/ID/BTB.sv
vlog -work ./work ../src/processor/stage/ID/IMMGEN.sv
vlog -work ./work ../src/processor/stage/ID/decoder.sv
vlog -work ./work ../src/processor/stage/ID/RegisterFile.sv
vlog -work ./work ../src/processor/stage/ID/ID.sv
#EXE
vlog -work ./work ../src/processor/COMMON/adder/PG.sv
vlog -work ./work ../src/processor/COMMON/adder/CSA.sv
vlog -work ./work ../src/processor/COMMON/adder/G_NET.sv
vlog -work ./work ../src/processor/COMMON/adder/PG_NET.sv
vlog -work ./work ../src/processor/COMMON/adder/CLG.sv
vlog -work ./work ../src/processor/COMMON/adder/CSA_32.sv
vlog -work ./work ../src/processor/stage/EXE/ALU_IN_GEN.sv
vlog -work ./work ../src/processor/stage/EXE/CMP.sv
vlog -work ./work ../src/processor/stage/EXE/ALU.sv
vlog -work ./work ../src/processor/stage/EXE/ALU_CONTROLER.sv
vlog -work ./work ../src/processor/stage/EXE/PREDICT_CHECKOR.sv
vlog -work ./work ../src/processor/stage/EXE/EXE.sv
#MEM
vlog -work ./work ../src/processor/stage/MEM/MEM.sv
#WB
vlog -work ./work ../src/processor/stage/WB/WB.sv
#CU
vlog -work ./work ../src/processor/CU.sv
#other
vlog -work ./work ../src/processor/stage/ID/STALL_DETECTOR.sv
#PROCESSOR
vlog -work ./work ../src/processor/PROCESSOR.sv
#sram
vlog -work ./work ../src/SSRAM/sram_32_1024_freepdk45.v
vlog -work ./work ../src/SSRAM/lfsr.sv
vlog -work ./work ../src/SSRAM/mem_wrap_fake.sv
#TOP
vlog -work ./work ../src/top.sv
#TB
vlog -work ./work ../tb/TB_TOP.sv

vsim work.TB_TOP -voptargs=+acc
