module DECODER #( parameter BITS = 32)
(
	input logic [BITS-1:0] INSTR,
	output logic [6:0] opcode,
	output logic [4:0] rd,
	output logic [2:0] funct3,
	output logic [4:0] rs1,
	output logic [4:0] rs2,
	output logic [6:0] funct7
);

assign funct7 = INSTR[31:25];
assign rs2 = INSTR[24:20];
assign rs1 = INSTR[19:15];
assign funct3 = INSTR[14:12];
assign rd = INSTR[11:7];
assign opcode = INSTR[6:0];

endmodule
