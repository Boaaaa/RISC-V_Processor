.data
sS:
.word 0x00000000
.word 0xfffffc00
.word 0xfffffe00
.word 0xffffff00
Lo:
.word 0x0000000f
.word 0xffffffec
Li:
.word 0x0000001f

.text
.globl __start

__start:  
auipc gp,0x1fc18 
addi gp,gp,16 
auipc sp,0x7fbff 
addi sp,sp,-12 
add s0,sp,zero 
jal ra,main 

el:  
j el
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
jal ra,maxx
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
bge a4,a6,maxx1 
mv a7,a6 

maxx1:
sub a4,a4,a6 
addi a4,a4,15 
li a6,30 
bltu a6,a4,maxx2
addi a7,a7,3

maxx2:
sw a7,0(a3) 
lw a4,12(a2) 
lw a6,8(a2) 
add a4,a5,a4 
add a6,a0,a6 
mv a7,a4 
bge a4,a6,maxx3 
mv a7,a6 

maxx3:
sub a4,a4,a6 
addi a4,a4,15 
li a6,30 
bltu a6,a4,maxx4 
addi a7,a7,3

maxx4:
sw a7,4(a3) 
lw a6,0(a2) 
lw a4,4(a2) 
add a1,a1,a6 
mv a6,a4 
bge a4,a1,maxx5
mv a6,a1 

maxx5:
sub a4,a4,a1 
addi a4,a4,15 
li a1,30 
bltu a1,a4,maxx6
addi a6,a6,3 

maxx6:
sw a6,8(a3) 
lw a4,12(a2) 
lw a1,8(a2) 
add a0,a0,a4 
add a5,a5,a1 
mv a4,a5 
bge a5,a0,maxx7
mv a4,a0 

maxx7:
sub a5,a5,a0 
addi a5,a5,15 
li a2,30 
bltu a2,a5,maxx8
addi a4,a4,3 

maxx8:
sw a4,12(a3) 
ret 
