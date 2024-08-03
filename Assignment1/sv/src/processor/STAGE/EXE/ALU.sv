module ALU #(
	parameter BITS = 32)
(
	input logic [1:0] ALU_CONTROL,
	input logic [BITS-1:0] A,
	input logic [BITS-1:0] B,
	input logic IS_SIGNED,
	output logic [BITS-1:0] OUT,
	output logic [3:0] CMP_FLAG
);

logic [31:0] S_A;
logic [31:0] S_B;
logic S_PRE_C_A;
logic S_PRE_C_B;
logic S_CARRY;

ALU_IN_GEN u_ALU_IN_GEN0(
	.SEL(2'b00),
	.IN(A),
	.OUT(S_A),
	.PRE_C(S_PRE_C_A)
);

ALU_IN_GEN u_ALU_IN_GEN1(
	.SEL(ALU_CONTROL),
	.IN(B),
	.OUT(S_B),
	.PRE_C(S_PRE_C_B)
);

CSA_32 u_CSA(
	.exist_carry(1'b0),
	.pre_carry(1'b0),
	.a_in(S_A),
	.b_in(S_B),
	.s_out(OUT),
	.carry(S_CARRY)
);

CMP_ALU u_CMP(
	.SIGNED_OR_UNSIGNED(IS_SIGNED),
	.A(A),
	.B(B),
	.OUT(CMP_FLAG) 
);

endmodule
