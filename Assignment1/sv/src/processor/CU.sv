module CU
(
	input logic clk,
	input logic rst,
	input logic [6:0] OPCODE,
	input logic IS_FLUSH,
	input logic mem_rdy_if,
	input logic valid_if,
	input logic mem_rdy_mem,
	input logic valid_mem,
	input logic is_stall,
	input logic is_give_up,

	//output
	output logic [4:0] IF_CU, //S0 S1 EN_IF PROC_REQ WE
	output logic [6:0] ID_CU, //EN_READ1 EN_READ2 IMM_S0 IMM_S1 IMM_S2 IS_J_TYPE EN_ID 
	output logic [10:0] EXE_CU,//F_SEL  AUIPC_SEL(2 bits) IMM_RS2_SEL(2 bits) ALUOP JAL_SEL PC_IMM_SEL EN_EXE
	output logic [2:0]  MEM_CU,  //PROC_REQ WE EN_MEM
	output logic [1:0] WB_CU,  // SEL_WB EN_WRITE
	output logic START,
	output logic FLUSH1
	
);

logic [4:0] S_IF_CU;
logic [4:0] S_IF_CU_NORMAL;
logic [4:0] S_MISMATCH_IF_CU;
logic [4:0] S_NEXT_IF_CU;
logic [4:0] S_IF_CU1;
logic [4:0] SS_IF_CU;
logic [4:0] SSS_IF_CU;


logic [6:0] S_ID_CU;

logic [10:0] S_EXE_CU_NORMAL;
logic [2:0] S_MEM_CU_NORMAL;
logic [1:0] S_WB_CU_NORMAL;

logic [10:0] S_EXE_CU_NORMAL1;
logic [2:0] S_MEM_CU_NORMAL1;
logic [1:0] S_WB_CU_NORMAL1;

logic [1:0] S_WB_CU1;
logic [2:0] S_MEM_CU2;
logic [2:0] SS_MEM_CU2;
logic [1:0] S_WB_CU2;

logic [1:0] S_WB_CU3;

logic [10:0] S_EXE_CU_NOP;
logic [2:0]  S_MEM_CU_NOP;
logic [1:0] S_WB_CU_NOP;

logic [10:0] S_EXE_CU;
logic [2:0] S_MEM_CU;
logic [1:0] S_WB_CU;


logic IS_FLUSH1;
logic S_START;

//logic [1:0] S_MEM_STATE;


logic s_valid_if;
logic s_mem_rdy_mem;
logic s_valid_mem;
logic s_continue;
logic [10:0] S_EXE_CU1;
logic [2:0] S_MEM_CU1;
logic S_MEM_RDY_IF;
logic S_MEM_RDY_MEM;
//
logic if_continue;
logic proc_req_if_done;
logic mem_rdy_if_done;
logic mem_continue;
logic proc_req_mem_done;
logic mem_rdy_mem_done;
logic if_proc_sel;
logic mem_proc_sel;
logic if_call_stop;
logic mem_call_stop;
logic mem_sel_go;
logic [1:0] if_fsm_p;
logic [1:0] if_fsm_m;
logic [1:0] mem_fsm_p;
logic [1:0] mem_fsm_m;
logic if_call_start;
logic mem_call_start;
logic if_count;
logic mem_count;
logic s_mem_rdy_check_if;
logic s_mem_rdy_check_mem;
logic s_mem_call_start;
logic wait_mem_valid;

assign S_EXE_CU_NOP = {S_WB_CU2[1],10'b10_10_001_101};

always_comb begin
	if(if_fsm_p == 2'b10 && mem_rdy_if == 1'b1) begin
		s_mem_rdy_check_if = 1'b1;
	end else begin
		s_mem_rdy_check_if = 1'b0;
	end
end

always_comb begin
	if(((MEM_CU[1] == 1'b0 && mem_fsm_p == 2'b10) || (MEM_CU[1] == 1'b1 && mem_fsm_p == 2'b01)) && mem_rdy_mem == 1'b1) begin
		s_mem_rdy_check_mem = 1'b1;
	end else begin
		s_mem_rdy_check_mem = 1'b0;
	end
end

always@(posedge clk) begin
	if(rst) begin
		S_MISMATCH_IF_CU = 5'b01110;
		S_NEXT_IF_CU = 5'b00110;
		S_MEM_CU_NOP = 3'b001;
		S_WB_CU_NOP  = 2'b00;

		mem_count = 1'b0;
		if_count = 1'b0;
		if_call_start = 1'b1;
		mem_call_start = 1'b1;
		s_continue = 1'b1;
		if_fsm_p = 2'b11;
		mem_fsm_m = 2'b11;
		wait_mem_valid = 1'b0;
	end
	else begin
		if(s_continue == 1'b1) begin
			if_call_start = 1'b1;
			mem_call_start = 1'b1;
		end 

		if(if_count == 1'b1) begin
			if_count = 1'b0;
		end
		else if(IF_CU[1] == 1'b1 && mem_rdy_if == 1'b1) begin
			if_fsm_p = 2'b10;
			if_fsm_m = 2'b01;
			if_call_start = 1'b0;
			if_count = 1'b1;		
		end 
		else if(IF_CU[1] == 1'b1 && mem_rdy_if == 1'b0) begin
			if_fsm_p = 2'b10;
			if_call_start = 1'b1;
			if_count = 1'b0;
		end 

		if(s_mem_rdy_check_if == 1'b1 && if_fsm_p == 2'b10 && if_count == 1'b0) begin
			if_fsm_m = 2'b01;
			if_call_start = 1'b0;
		end 
		if(valid_if == 1'b1 && if_fsm_m == 2'b01) begin
			if_fsm_p = 2'b00;
		end

		else if (mem_count == 1'b1) begin
			mem_call_start = 1'b0;
		end
		else if(MEM_CU[2] == 1'b1 && MEM_CU[1] == 1'b0 && mem_rdy_mem == 1'b1) begin
			mem_fsm_p = 2'b10;
			mem_fsm_m = 2'b01;
			mem_call_start = 1'b0;
			mem_count = 1'b1;	
		end else if(MEM_CU[2] == 1'b1 && MEM_CU[1] == 1'b0 && mem_rdy_mem == 1'b0) begin
			mem_fsm_p = 2'b10;
			mem_call_start = 1'b1;
			mem_count = 1'b0;
		end
		else if(MEM_CU[2] == 1'b1 && MEM_CU[1] == 1'b1 && mem_rdy_mem == 1'b1) begin
			mem_fsm_p = 2'b01;
			mem_fsm_m = 2'b00;
			mem_call_start = 1'b0;
			mem_count = 1'b1;	
		end
		else if(MEM_CU[2] == 1'b1 && MEM_CU[1] == 1'b1 && mem_rdy_mem == 1'b0) begin
			mem_fsm_p = 2'b01;
			mem_call_start = 1'b1;
			mem_count = 1'b0;	
		end
		else if(wait_mem_valid == 1'b1) begin
			mem_call_start = 1'b0;
		end
		else begin
			mem_fsm_m = 0;
			mem_fsm_p = 0;
		end

		if(s_mem_rdy_check_mem == 1'b1 && ((MEM_CU[1] == 1'b0 && mem_fsm_p == 2'b10) || (MEM_CU[1] == 1'b1 && mem_fsm_p == 2'b01)) && mem_count == 1'b0) begin
			mem_fsm_m = mem_fsm_p - 2'b01;
			wait_mem_valid = 1'b1;
			mem_call_start = 1'b0;
		end 
		if(valid_mem == 1'b1 && mem_fsm_m != 2'b0 && mem_fsm_p != 1'b0 && (MEM_CU[1] == 1'b0 && mem_fsm_m == 2'b01)) begin
			mem_fsm_p = mem_fsm_m - 2'b01;
		end

		if(if_fsm_p == 0 && ((MEM_CU[1] == 1'b0 && mem_fsm_p == 2'b0) || (MEM_CU[1] == 1'b1 && mem_fsm_m == 0))) begin
			wait_mem_valid = 1'b0;
			s_continue = 1'b1;
			if_fsm_p = 2'b11;
			mem_fsm_m = 2'b11;
			if_count = 1'b0;
			mem_count = 1'b0;	
		end 
		else begin
			s_continue = 1'b0;
		end
	end
end

reg32 #(1) u_mem_call(
	.clk(clk),
	.rst(rst),
	.en(s_continue),
	.regin(mem_call_start),
	.regout(s_mem_call_start)
);

always@(OPCODE) begin
	case(OPCODE)	
		7'b0110011: begin     //R-type add
			S_ID_CU = 7'b11_000_01;
			S_EXE_CU_NORMAL[10:0] = {S_WB_CU2[1],10'b0100_000_101};
			S_MEM_CU_NORMAL = 3'b001;
			S_WB_CU_NORMAL = 2'b01;
			S_IF_CU_NORMAL = 5'b001_10;
		end
		7'b0010111: begin	  //U-type auipc
			S_ID_CU = 7'b00_000_01;
			S_EXE_CU_NORMAL[10:0] = {S_WB_CU2[1],10'b0001_101_101};
			S_MEM_CU_NORMAL = 3'b001;
			S_WB_CU_NORMAL = 2'b01;
			S_IF_CU_NORMAL = 5'b001_10;
		end 
		7'b0110111: begin     //U-type lui
			S_ID_CU = 7'b00_000_01;
			S_EXE_CU_NORMAL[10:0] = {S_WB_CU2[1],10'b1001_101_101};
			S_MEM_CU_NORMAL = 3'b001;
			S_WB_CU_NORMAL = 2'b01;
			S_IF_CU_NORMAL = 5'b001_10;
		end
		7'b0100011: begin     //S-type sw
			S_ID_CU = 7'b11_100_01;
			S_EXE_CU_NORMAL[10:0] = {S_WB_CU2[1],10'b0101_010_101};
			S_MEM_CU_NORMAL = 3'b111;
			S_WB_CU_NORMAL = 2'b00;
			S_IF_CU_NORMAL = 5'b001_10;
		end
		7'b0010011: begin     //I-type addi and nop and mv and li
			S_ID_CU = 7'b10_011_01;
			S_EXE_CU_NORMAL[10:0] = {S_WB_CU2[1],10'b0101_001_101};
			S_MEM_CU_NORMAL = 3'b001;
			S_WB_CU_NORMAL = 2'b01;
			S_IF_CU_NORMAL = 5'b001_10;
		end
		7'b0000011: begin     //I-type lw
			S_ID_CU = 7'b10_011_01;
			S_EXE_CU_NORMAL[10:0] = {S_WB_CU2[1],10'b0101_001_101};
			S_MEM_CU_NORMAL = 3'b101;
			S_WB_CU_NORMAL = 2'b11;
			S_IF_CU_NORMAL = 5'b001_10;
		end
		7'b1101111: begin     //UJ-type  jal and j
			S_ID_CU = 7'b00_001_11;
			S_EXE_CU_NORMAL[10:0] = {S_WB_CU2[1],10'b0010_100_111};
			S_MEM_CU_NORMAL = 3'b001;
			S_WB_CU_NORMAL = 2'b01;
			S_IF_CU_NORMAL = 5'b101_10;
		end 
		7'b1100111: begin     //I-type jalr and ret
			S_ID_CU = 7'b10_011_11;
			S_EXE_CU_NORMAL[10:0] = {S_WB_CU2[1],10'b0101_110_001};
			S_MEM_CU_NORMAL = 3'b001;
			S_WB_CU_NORMAL = 2'b01;
			S_IF_CU_NORMAL = 5'b101_10;
		end 
		7'b1100011: begin     //SB-type bge and bltu
			S_ID_CU = 7'b11_010_11;
			S_EXE_CU_NORMAL[10:0] = {S_WB_CU2[1],10'b0100_011_111};
			S_MEM_CU_NORMAL = 3'b001;
			S_WB_CU_NORMAL = 2'b10;
			S_IF_CU_NORMAL = 5'b101_10;
		end 
		default: begin
			S_IF_CU_NORMAL = 5'b001_10;
			S_ID_CU = 7'b0;
			S_EXE_CU_NORMAL[10:0] = 11'b1;
			S_MEM_CU_NORMAL = 3'b001;
			S_WB_CU_NORMAL = 2'b00;
		end	
	endcase
end



reg32 #(5) u_IF_ID_REG(
	.clk(clk),
	.rst(rst),
	//.en(s_continue && (!is_stall)),
	.en((!is_stall)),
	.regin(S_IF_CU1),
	.regout(SS_IF_CU)
);

reg32 #(16) u_ID_EXE_REG(
	.clk(clk),
	.rst(rst),
	.en(s_continue),
	.regin({S_EXE_CU,S_MEM_CU,S_WB_CU}),
	.regout({S_EXE_CU_NORMAL1,S_MEM_CU_NORMAL1,S_WB_CU_NORMAL1})
);

reg32 #(5) u_EXE_MEM_REG(
	.clk(clk),
	.rst(rst),
	.en(s_continue),
	.regin({S_MEM_CU_NORMAL1,S_WB_CU_NORMAL1}),
	.regout({S_MEM_CU2,S_WB_CU2})
);

reg32 #(2) u_MEM_WB_REG(
	.clk(clk),
	.rst(rst),
	.en(s_continue),
	.regin(S_WB_CU2),
	.regout(S_WB_CU3)
);

reg32 #(1) u_FLUSH(
	.clk(clk),
	.rst(rst),
	.en(s_continue),
	.regin(IS_FLUSH),
	.regout(IS_FLUSH1)
);
assign FLUSH1 = IS_FLUSH1;

MUX21 #(5) u_MUX_FLUSH_IF(
	.SEL(IS_FLUSH),
	.A(S_IF_CU_NORMAL),
	.B(S_MISMATCH_IF_CU),
	.OUT(S_IF_CU)
);

MUX21 #(5) u_MUX_NEXT_IF(
	.SEL(IS_FLUSH1),
	.A(S_IF_CU),
	.B(S_NEXT_IF_CU),
	.OUT(S_IF_CU1) 
);

MUX21 #(11) u_MUX_FLUSH_EXE0(
	.SEL(IS_FLUSH || IS_FLUSH1 || is_stall || is_give_up),
	.A(S_EXE_CU_NORMAL),
	.B(S_EXE_CU_NOP),
	.OUT(S_EXE_CU) 
);

MUX21 #(3) u_MUX_FLUSH_MEM0(
	.SEL(IS_FLUSH || IS_FLUSH1 || is_stall || is_give_up),
	.A(S_MEM_CU_NORMAL),
	.B(S_MEM_CU_NOP),
	.OUT(S_MEM_CU) 
);

MUX21 #(2) u_MUX_FLUSH_WB0(
	.SEL(IS_FLUSH || IS_FLUSH1 || is_stall || is_give_up),
	.A(S_WB_CU_NORMAL),
	.B(S_WB_CU_NOP),
	.OUT(S_WB_CU) 
);

//MUX21 #(3) u_MUX_IF_PROC_REQ(
//	.SEL(if_proc_sel),
//	.A(SS_IF_CU[2:0]),
//	.B(SSS_IF_CU[2:0]),
//	.OUT(IF_CU[2:0]) 
//);

assign IF_CU[2] = SS_IF_CU[2];
assign IF_CU[1] = (SS_IF_CU[1] & if_call_start);
assign IF_CU[0] = SS_IF_CU[0];

//MUX21 #(3) u_MUX_MEM_PROC_REQ(
//	.SEL(mem_proc_sel),
//	.A(S_MEM_CU2),
//	.B(SS_MEM_CU2),
//	.OUT(MEM_CU) 
//);

assign MEM_CU[2] = S_MEM_CU2[2] & mem_call_start;
assign MEM_CU[1] = S_MEM_CU2[1];
assign MEM_CU[0] = S_MEM_CU2[0];

assign IF_CU[4:3] = S_IF_CU1[4:3];
assign ID_CU = S_ID_CU;
//assign IF_CU[2:0] = SS_IF_CU[2:0];
assign EXE_CU = S_EXE_CU_NORMAL1;
//assign MEM_CU = S_MEM_CU2;
assign WB_CU = S_WB_CU3;
assign START = s_continue;

endmodule

