section .text:  

__start:  
auipc gp,0x1fc18 
addi gp,gp,16 
auipc sp,0x7fbff 
addi sp,sp,-12 
add s0,sp,zero 
jal ra,400024 <main> 

el:  
j 400018 <el> 
nop 
nop 

  

main:  
lui a5,0x10010 
lw a0,24(a5) 
lui a3,0x10010 
lui a2,0x10010 
lui a1,0x10010 
addi sp,sp,-16 
addi a3,a3,28 
mv a2,a2 
addi a1,a1,16 
sw ra,12(sp) 
jal ra,400060 <maxx> 
lw ra,12(sp) 
li a0,0 
addi sp,sp,16 
ret 

maxx:  
lw a7,0(a1) 
lw a5,4(a1) 
lw a6,4(a2) 
add a0,a0,a7 
lw a4,0(a2) 
add a1,a0,a5 
add a6,a1,a6 
mv a7,a4 
bge a4,a6,400088 <maxx+0x28> 
mv a7,a6 
sub a4,a4,a6 
addi a4,a4,15 
li a6,30 
bltu a6,a4,40009c <maxx+0x3c> 
addi a7,a7,3 
sw a7,0(a3) 
lw a4,12(a2) 
lw a6,8(a2) 
add a4,a5,a4 
add a6,a0,a6 
mv a7,a4 
bge a4,a6,4000bc <maxx+0x5c> 
mv a7,a6 
sub a4,a4,a6 
addi a4,a4,15 
li a6,30 
bltu a6,a4,4000d0 <maxx+0x70> 
addi a7,a7,3 
sw a7,4(a3) 
lw a6,0(a2) 
lw a4,4(a2) 
add a1,a1,a6 
mv a6,a4 
bge a4,a1,4000ec <maxx+0x8c> 
mv a6,a1 
sub a4,a4,a1 
addi a4,a4,15 
li a1,30 
bltu a1,a4,400100 <maxx+0xa0> 
addi a6,a6,3 
sw a6,8(a3) 
lw a4,12(a2) 
lw a1,8(a2) 
add a0,a0,a4 
add a5,a5,a1 
mv a4,a5 
bge a5,a0,400120 <maxx+0xc0> 
mv a4,a0 
sub a5,a5,a0 
addi a5,a5,15 
li a2,30 
bltu a2,a5,400134 <maxx+0xd4> 
addi a4,a4,3 
sw a4,12(a3) 
ret 
