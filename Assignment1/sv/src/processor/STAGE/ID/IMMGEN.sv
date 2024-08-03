module IMMGEN #(
	parameter BITS = 32
)
(
	input logic [BITS-1:0] INSTR,
	input logic imms1,
	input logic imms2,
	input logic imms3,
	output logic [BITS-1:0] IMM
);

logic [31:0] IMM_TMP;
always_comb begin
	case({imms1,imms2,imms3})
		0 : IMM_TMP <= {INSTR[31:12],12'b000000000000};  // LUI and AUIPC 
		1 : IMM_TMP <= {{11{INSTR[31]}},INSTR[31],INSTR[19:12],INSTR[20],INSTR[30:21],1'b0}; // JAL
		2 : IMM_TMP <= {{19{INSTR[31]}},INSTR[31],INSTR[7],INSTR[30:25],INSTR[11:8],1'b0}; // B type instruction 
		3 : IMM_TMP <= {{20{INSTR[31]}},INSTR[31:20]}; //JALR and Load instructions, I type insturctions except SLLI,SRLI and SRAI
		4 : IMM_TMP <= {{20{INSTR[31]}},INSTR[31:25],INSTR[11:7]}; //Store instructions
		default : IMM_TMP <= 0;
	endcase
end

assign IMM = IMM_TMP;

endmodule
