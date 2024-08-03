module EXE #(
	parameter BITS = 32)
(
    //DATA
    input logic clk,
	input logic rst,
	input logic EN_EXE,
	input logic [BITS-1:0] MEM_OUTPUT,
	input logic [BITS-1:0] RESULT_MEM,
	input logic [BITS-1:0] RF_OUT_A,
	input logic [BITS-1:0] RF_OUT_B,
	input logic [BITS-1:0] IMM,
	input logic [BITS-1:0] PC_ID,
	input logic [BITS-1:0] NPC_ID,
	input logic [4:0] RS1,
	input logic [4:0] RS2,
	input logic [4:0] RD,
	input logic [4:0] RD_MEM,
	input logic [2:0] FUNC3,
	input logic [6:0] FUNC7,
	input logic [1:0] PREDICT_STATUS_REG,
	//CONTROL
	input logic F_SEL,
	input logic [1:0] AUIPC_SEL,
	input logic [1:0] IMM_RS2_SEL,
	input logic [2:0] ALUOP,
	input logic JAL_SEL,
	input logic PC_IMM_SEL,
	
	output logic [BITS-1:0] PC_EXE,
	output logic [4:0] RD_EXE,
	output logic [BITS-1:0] RESULT_EXE,
	output logic IS_FLUSH,
    output logic [1:0] NEW_STATUS,
	output logic [BITS-1:0] VALUE_RS2	
);

wire [31:0] S_MEM_RST;
//wire [31:0] S_NOP_RST;
wire S_SEL_0_RS1;
wire S_SEL_1_RS1;
wire S_SEL_0_RS2;
wire S_SEL_1_RS2;
wire [31:0] S_RF_A_MEM_RST;
wire [31:0] S_RST_EXE_RST0;
wire [31:0] S_RST_EXE_RST1;
wire [31:0] S_RESULT_EXE;
wire [31:0] S_ALU_A;
wire [31:0] S_ALU_B;
wire [1:0] S_OPT;
wire [3:0] S_CMP_TYPE;
wire [31:0] S_ALU_OUT;
wire [3:0] S_CMP_FLAG;
wire [31:0] S_JMP_PC;
wire S_PC_ADDER_CARRY;
wire S_IS_BRANCH;
wire S_PREDICT_RESULT;
wire [31:0] S_JAL_RST;
wire [31:0] S_JMP_PC_RST;
wire [31:0] S_RF_B_MEM_RST;
wire [4:0] S_RD_EXE;
wire S_IS_FORWARDING_RS1;
wire S_IS_FORWARDING_RS2;
wire S_IS_FORWARDING_RD;
wire S_IS_FORWARDING_RD1;
wire S_IS_FORWARDING_RD2;
wire S_IS_SIGNED;

MUX21 u_MUX_MEM(
	.SEL(F_SEL),
	.A(RESULT_MEM),
	.B(MEM_OUTPUT),
	.OUT(S_MEM_RST)
);

//MUX21 u_MUX_NOP(
//	.SEL(NOP_SEL),
//	.A(RF_OUT_A),
//	.B(0),
//	.OUT(S_NOP_RST)
//);

SELGEN u_SELGEN_0_RS1(
	.A(RS1),
	.B(RD_MEM),
	.OUT(S_SEL_0_RS1)
);

SELGEN u_SELGEN_1_RS1(
	.A(RS1),
	.B(S_RD_EXE),
	.OUT(S_SEL_1_RS1)
);

SELGEN u_SELGEN_0_RS2(
	.A(RS2),
	.B(RD_MEM),
	.OUT(S_SEL_0_RS2)
);

SELGEN u_SELGEN_1_RS2(
	.A(RS2),
	.B(S_RD_EXE),
	.OUT(S_SEL_1_RS2)
);

MUX21 u_MUX_RF_A_MEM(
	.SEL(S_SEL_0_RS1 & S_IS_FORWARDING_RS1 & S_IS_FORWARDING_RD2),
	.A(RF_OUT_A),
	.B(S_MEM_RST),
	.OUT(S_RF_A_MEM_RST)
);

MUX21 u_MUX_RST0_EXE(
	.SEL(S_SEL_1_RS1 & S_IS_FORWARDING_RS1 & S_IS_FORWARDING_RD1),
	.A(S_RF_A_MEM_RST),
	.B(S_RESULT_EXE),
	.OUT(S_RST_EXE_RST0)
);

MUX21 u_MUX_RF_B_MEM(
	.SEL(S_SEL_0_RS2 & S_IS_FORWARDING_RS2 & S_IS_FORWARDING_RD2),
	.A(RF_OUT_B),
	.B(S_MEM_RST),
	.OUT(S_RF_B_MEM_RST)
);

MUX21 u_MUX_RST1_EXE(
	.SEL(S_SEL_1_RS2 & S_IS_FORWARDING_RS2 & S_IS_FORWARDING_RD1),
	.A(S_RF_B_MEM_RST),
	.B(S_RESULT_EXE),
	.OUT(S_RST_EXE_RST1)
);

MUX31 u_MUX_AUIPC_RS1(
	.SEL(AUIPC_SEL),
	.A(PC_ID),
	.B(S_RST_EXE_RST0),
	.C(32'b0),
	.OUT(S_ALU_A)
);

MUX31 u_MUX_IMM_RS2(
	.SEL(IMM_RS2_SEL),
	.A(S_RST_EXE_RST1),
	.B(IMM),
	.C(32'h4),
	.OUT(S_ALU_B)
);

ALU_CONTROLER u_ALU_CONTROLER(
	.ALUOP(ALUOP),
	.FUNCT3(FUNC3),
	.FUNCT7(FUNC7),
	
	.CMP_TYPE(S_CMP_TYPE),
	.OPT(S_OPT),  //SEL_A(A or NA or 0), SEL_B(B or NB or CB), 
	.IS_FORWARDING_RS1(S_IS_FORWARDING_RS1),
	.IS_FORWARDING_RS2(S_IS_FORWARDING_RS2),
	.IS_FORWARDING_RD(S_IS_FORWARDING_RD),
	.IS_SIGNED(S_IS_SIGNED)
);

ALU u_ALU(
	.ALU_CONTROL(S_OPT),
	.A(S_ALU_A),
	.B(S_ALU_B),
	.IS_SIGNED(S_IS_SIGNED),
	.OUT(S_ALU_OUT),
	.CMP_FLAG(S_CMP_FLAG)
);

CSA_32 u_PC_ADDER(
	.exist_carry(1'b0),
	.pre_carry(1'b0),
	.a_in(PC_ID),
	.b_in(IMM),
	.s_out(S_JMP_PC),
	.carry(S_PC_ADDER_CARRY)
);

PREDICT_CHECKOR u_PREDICT_CHECKOR(
	.PREDICT_STATUS(PREDICT_STATUS_REG),
	.CMP_FLAG(S_CMP_FLAG),
	.CMP_TYPE(S_CMP_TYPE),
	.IS_BRANCH(S_IS_BRANCH),
	.PREDICT_RESULT(S_PREDICT_RESULT)
);

MUX21 u_MUX_JAL(
	.SEL(JAL_SEL),
	.A(NPC_ID),
	.B(S_ALU_OUT),
	.OUT(S_JAL_RST)
);

MUX21 u_MUX_IS_JMP(
	.SEL(S_IS_BRANCH),
	.A(S_JMP_PC),
	.B(NPC_ID),
	.OUT(S_JMP_PC_RST)
);

MUX21 u_MUX_PC_EXE(
	.SEL(PC_IMM_SEL),
	.A(S_ALU_OUT),
	.B(S_JMP_PC_RST),
	.OUT(PC_EXE)
);


FSM #(2) u_FSM(
	.OLD(PREDICT_STATUS_REG),
	.FLAG(S_PREDICT_RESULT),
	.NEW_STATE(NEW_STATUS)
);


reg32 #(5) u_RD_REG(
	.clk(clk),
	.rst(rst),
	.en(EN_EXE),
	.regin(RD),
	.regout(S_RD_EXE)
);
assign RD_EXE = S_RD_EXE;

reg32 #(32) u_RESULT_EXE_REG(
	.clk(clk),
	.rst(rst),
	.en(EN_EXE),
	.regin(S_JAL_RST),
	.regout(S_RESULT_EXE)
);

assign RESULT_EXE = S_RESULT_EXE;

//reg32 #(1) u_FLUSH_REG(
//	.clk(clk),
//	.rst(rst),
//	.en(EN_EXE),
//	.regin(!S_PREDICT_RESULT),
//	.regout(IS_FLUSH)
//);

assign IS_FLUSH = !S_PREDICT_RESULT;

reg32 #(32) u_RS2_REG(
	.clk(clk),
	.rst(rst),
	.en(EN_EXE),
	.regin(S_RST_EXE_RST1),
	.regout(VALUE_RS2)
);

reg32 #(1) u_FORWARDING_RD_REG(
	.clk(clk),
	.rst(rst),
	.en(EN_EXE),
	.regin(S_IS_FORWARDING_RD),
	.regout(S_IS_FORWARDING_RD1)
);

reg32 #(1) u_FORWARDING_RD1_REG(
	.clk(clk),
	.rst(rst),
	.en(EN_EXE),
	.regin(S_IS_FORWARDING_RD1),
	.regout(S_IS_FORWARDING_RD2)
);
endmodule
