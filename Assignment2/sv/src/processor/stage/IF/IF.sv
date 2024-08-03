module IF(
	input logic CLK,
	input logic RSTn,
	input logic [31:0] basic_addr,
	input logic EN_IF,
	input logic S0,
	input logic S1,
	input logic [31:0] PC_EXE,
	input logic [31:0] PC_PREDICT,
	input logic [31:0] RDATA,
	input logic VALID,
	output logic [31:0] ADDR,	
	output logic [31:0] NPC_IF,
	output logic [31:0] PC_IF,
	output logic [31:0] INST,
	output logic [31:0] PRE_PC
);

logic [31:0] PC_SEL_OUT;
logic [31:0] PC_REG_OUT;
logic [31:0] PC_ADD_OUT;
logic [31:0] S_RDATA;
//logic [31:0] INST_OUT;


assign PRE_PC = PC_ADD_OUT;

MUX3TO1 mux31(.in1(PC_ADD_OUT),.in2(PC_PREDICT),.in3(PC_EXE),.sel({S1,S0}),.out(PC_SEL_OUT));

REG32_INNER_IF regpc(.clk(CLK),.rst(RSTn),.en(EN_IF),.regin(PC_SEL_OUT),.basic_addr(basic_addr),.regout(PC_REG_OUT));

ADDER32 adderpc(.in1(32'b0000_0000_0000_0000_0000_0000_0000_0100),.in2(PC_REG_OUT),.out(PC_ADD_OUT));

//store the value of NPC to prepare for next stage ID
assign ADDR = PC_REG_OUT;
//reg32 to_mem(.clk(CLK),.rst(RSTn),.en(EN_IF),.regin(PC_REG_OUT),.regout(ADDR));

//store the value of NPC to prepare for next stage ID
reg32 npc(.clk(CLK),.rst(RSTn),.en(EN_IF),.regin(PC_ADD_OUT),.regout(NPC_IF));
	
//store the value of PC to prepare for next stage ID
reg32 pc(.clk(CLK),.rst(RSTn),.en(EN_IF),.regin(PC_REG_OUT),.regout(PC_IF));

//reg32 u_mem_data(.clk(CLK),.rst(RSTn),.en(VALID),.regin(RDATA),.regout(S_RDATA));
//store instruction to prepare for next stage ID
//reg32 instr(.clk(CLK),.rst(RSTn),.en(VALID),.regin(RDATA),.regout(INST));
always_comb begin
	if(VALID) begin
		S_RDATA = RDATA;
	end
end
reg32 instr(.clk(CLK),.rst(RSTn),.en(EN_IF),.regin(S_RDATA),.regout(INST));

endmodule
