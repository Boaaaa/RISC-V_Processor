module ID #(
	parameter BITS = 32
)(
	input logic CLK,
	input logic RSTn,
	input logic EN_ID,
	input logic [31:0] NPC,
	input logic [31:0] PC,
	input logic [31:0] INST,
	input logic IS_J_TYPE,
	input logic IMM_S0,
	input logic IMM_S1,
	input logic IMM_S2,
	input logic EN_READ1,
	input logic EN_READ2,
	input logic EN_WRITE,
	input logic IS_FLUSH,
	input logic [31:0] PC_EXE,
	input logic [1:0] NEW_STATUS,
	input logic [4:0] RD_MEM,
	input logic [31:0] WDATA,
	input logic is_nop_rd,
	input logic [31:0] PRE_PC,
	input logic [BITS-1:0] basic_sp,
	input logic [BITS-1:0] basic_gp,
	output logic [31:0] NPC_ID,
	output logic [6:0] OPCODE,
	output logic [4:0] RD,
	output logic [2:0] FUNC3,
	output logic [31:0] RF_OUT_A,
	output logic [31:0] RF_OUT_B,
	output logic [4:0] RS1,
	output logic [4:0] RS2,
	output logic [4:0] C_RS1,
	output logic [4:0] C_RS2,
	output logic [6:0] PRE_OPCODE,
	output logic [6:0] FUNC7,
	output logic [31:0] IMM,
	output logic [31:0] PC_PREDICT,
	output logic [1:0] PREDICT_STATUS_REG,
	output logic [31:0] PC_ID
);

logic [31:0] RF_OUT_A_i;
logic [31:0] RF_OUT_B_i;
logic [4:0] RD_i;
logic [2:0] FUNC3_i;
logic [4:0] RS1_i;
logic [4:0] RS2_i;
logic [6:0] FUNC7_i;
logic [31:0] IMM_i;
logic [31:0] TARGET_i;
logic [1:0] STATUS_i;
logic [1:0] INDEX_OUT_BTB_i;
logic [1:0] INDEX_BTB_i;
logic [31:0] S_PC_ID;
logic [4:0] S_RD;
logic [6:0] S_OPCODE;
logic IS_J_TYPE_WRITE;
logic [31:0] S_INST;

DECODER  #( 
	.BITS(BITS)
) decoder(
	.INSTR(S_INST),
	.opcode(S_OPCODE),
	.rd(RD_i),
	.funct3(FUNC3_i),
	.rs1(RS1_i),
	.rs2(RS2_i),
	.funct7(FUNC7_i)
);
assign C_RS1 = RS1_i;
assign C_RS2 = RS2_i;
assign OPCODE = S_OPCODE;

reg32 #(7) ID_OPCODE(.clk(CLK),.rst(RSTn),.en(EN_ID),.regin(S_OPCODE),.regout(PRE_OPCODE));

always_comb begin
	if(PC == 32'h003ffffc) begin
		S_INST = 32'b0;
	end else begin
		S_INST = INST;
	end
end

RegisterFile #(
	.BITS(BITS)
) RF(
	.clk(CLK),
	.rstn(RSTn),
	.read1(EN_READ1),
	.read2(EN_READ2),
	.write(EN_WRITE),
	.readaddr1(RS1_i),
	.readaddr2(RS2_i),
	.basic_sp(basic_sp),
	.basic_gp(basic_gp),
	.writeaddr(RD_MEM),
	.writedata(WDATA),
	.dataout1(RF_OUT_A_i),
	.dataout2(RF_OUT_B_i)
);

BTB #(
	.BITS(BITS)
) branchPredict(
	.rst(RSTn),
	.LOOK_UP_ADDR(PC),
	.IS_J_TYPE(IS_J_TYPE),
	.IS_J_TYPE_WRITE(IS_J_TYPE_WRITE),
	.EN_WRITE(IS_FLUSH),
	.W_ADDR(S_PC_ID),
	.TARGET_ADDR(PC_EXE),
	.NEW_STATUS(NEW_STATUS),
	.INDEX_BTB(INDEX_BTB_i),
	.TARGET(TARGET_i),
	.STATUS(STATUS_i),
	.INDEX_OUT_BTB(INDEX_OUT_BTB_i)
);

IMMGEN #(
	.BITS(BITS)
) immgenerate(
	.INSTR(S_INST),
	.imms1(IMM_S0),
	.imms2(IMM_S1),
	.imms3(IMM_S2),
	.IMM(IMM_i)
);

MUX21 mux(
	.A(PRE_PC),
	.B(TARGET_i),
	.SEL(STATUS_i[1]),
	.OUT(PC_PREDICT)
);



reg32 #(1) ID_IS_J_TYPE_REG(.clk(CLK),.rst(RSTn),.en(EN_ID),.regin(IS_J_TYPE),.regout(IS_J_TYPE_WRITE));
//store the value of NPC to prepare for next stage EXE
reg32 ID_NPC(.clk(CLK),.rst(RSTn),.en(EN_ID),.regin(NPC),.regout(NPC_ID));

//store the value of PC to prepare for next stage EXE
reg32 ID_PC(.clk(CLK),.rst(RSTn),.en(EN_ID),.regin(PC),.regout(S_PC_ID));

//store the value of RD to prepare for next stage EXE
MUX21 #(5) u_NOP_RD(
	.SEL(is_nop_rd),
	.A(RD_i),
	.B(5'b00000),
	.OUT(S_RD)
);

reg32 #(5) ID_RD(.clk(CLK),.rst(RSTn),.en(EN_ID),.regin(S_RD),.regout(RD));

//store the value of FUNC3 to prepare for next stage EXE
reg32 #(3) ID_FUNC3(.clk(CLK),.rst(RSTn),.en(EN_ID),.regin(FUNC3_i),.regout(FUNC3));

//store the value of RS1 to prepare for next stage EXE
reg32 #(5) ID_RS1(.clk(CLK),.rst(RSTn),.en(EN_ID),.regin(RS1_i),.regout(RS1));

//store the value of RS2 to prepare for next stage EXE
reg32 #(5) ID_RS2(.clk(CLK),.rst(RSTn),.en(EN_ID),.regin(RS2_i),.regout(RS2));

//store the value of FUNC7 to prepare for next stage EXE
reg32 #(7) ID_FUNC7(.clk(CLK),.rst(RSTn),.en(EN_ID),.regin(FUNC7_i),.regout(FUNC7));

//store the value of RF_OUT_A to prepare for next stage EXE
reg32 ID_RF_OUT_A(.clk(CLK),.rst(RSTn),.en(EN_ID),.regin(RF_OUT_A_i),.regout(RF_OUT_A));

//store the value of RF_OUT_B to prepare for next stage EXE
reg32 ID_RF_OUT_B(.clk(CLK),.rst(RSTn),.en(EN_ID),.regin(RF_OUT_B_i),.regout(RF_OUT_B));

//store the value of IMM to prepare for next stage EXE
reg32 ID_IMM(.clk(CLK),.rst(RSTn),.en(EN_ID),.regin(IMM_i),.regout(IMM));

//store the value of PREDICT_STATUS_REG to prepare for next stage EXE
reg32 #(2) ID_PREDICT_STATUS_REG(.clk(CLK),.rst(RSTn),.en(EN_ID),.regin(STATUS_i),.regout(PREDICT_STATUS_REG));

//store the value of INDEX_OUT_BTB to prepare for next stage EXE
reg32 #(2) ID_NPC_i(.clk(CLK),.rst(RSTn),.en(EN_ID),.regin(INDEX_OUT_BTB_i),.regout(INDEX_BTB_i));

assign PC_ID = S_PC_ID;

endmodule
