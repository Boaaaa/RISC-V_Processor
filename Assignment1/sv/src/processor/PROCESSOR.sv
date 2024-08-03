module PROCESSOR (
input   logic   CLK,
input   logic   RSTn,
input logic [31:0] basic_addr,
input logic mem_rdy_if,
input logic valid_if,
input logic mem_rdy_mem,
input logic valid_mem,
input logic [31:0] rdata_if,
input logic [31:0] rdata_mem,
input logic [31:0] basic_sp,
input logic [31:0] basic_gp,
output logic proc_req_if,
output logic we_if,
output logic [31:0] addr,
output logic proc_req_mem,
output logic we_mem,
output logic [31:0] addr_mem,
output logic [31:0] wdata_mem
);


wire        en_if;
wire        s0;
wire        s1;
wire [31:0] pc_exe;
wire [31:0] pc_predict;
wire [31:0] npc_if;
wire [31:0] pc_if;
wire [31:0] inst;
////////////////
wire        is_stall;
wire        en_id;
wire        is_j_type;
wire        imm_s0;
wire        imm_s1;
wire        imm_s2;
wire        en_read1;
wire        en_read2;
wire        en_write;
wire        is_flush;
wire [1:0]  new_status;
wire [31:0] wdata;
wire [31:0] npc_id;
wire [6:0]  opcode;
wire [4:0]  rd;
wire [2:0]  func3;
wire [31:0] rf_out_a;
wire [31:0] rf_out_b;
wire [4:0]  rs1;
wire [4:0]  rs2;
wire [6:0]  func7;
wire [31:0] imm;
wire [1:0]  predict_status_reg;
wire [31:0] pc_id;
/////////
wire        en_exe;
wire [31:0] mem_output;
wire [31:0] result_mem;
wire [4:0]  rd_mem;
wire        f_sel;
wire [1:0]  auipc_sel;
wire [1:0]  imm_rs2_sel;
wire [2:0]  aluop;
wire        jal_sel;
wire        pc_imm_sel;
wire [4:0]  rd_exe;
wire [31:0] result_exe;
wire [31:0] value_rs2;
/////
wire        en_mem;
//////
wire        sel_wb;
///////
wire start;
///////
wire S_FLUSH1;
///////
wire s_is_nop_rd;
/////////
wire [4:0] s_c_rs1;
wire [4:0] s_c_rs2;
wire [6:0] s_pre_opcode;
wire [31:0] S_PRE_PC;
IF if_stage(
    //input
    .CLK(CLK),
    .RSTn(RSTn),
	.basic_addr(basic_addr),
    .EN_IF((!is_stall) && start),
    .S0(s0),
    .S1(s1),
    .PC_EXE(pc_exe),
    .PC_PREDICT(pc_predict),
    .RDATA(rdata_if),
    .VALID(valid_if),
    //output
    .ADDR(addr),
    .NPC_IF(npc_if),
    .PC_IF(pc_if),
    .INST(inst),
	.PRE_PC(S_PRE_PC));
ID id_stage(
    //input
    .CLK(CLK),
    .RSTn(RSTn),
    .EN_ID((!is_stall) && start),
    .NPC(npc_if),
    .PC(pc_if),
    .INST(inst),
    .IS_J_TYPE(is_j_type),
    .IMM_S0(imm_s0),
    .IMM_S1(imm_s1),
    .IMM_S2(imm_s2),
    .EN_READ1(en_read1),
    .EN_READ2(en_read2),
    .EN_WRITE(en_write),
    .IS_FLUSH(is_flush),
    .PC_EXE(pc_exe),
    .NEW_STATUS(new_status),
    .RD_MEM(rd_mem),
    .WDATA(wdata),
	.is_nop_rd(is_stall || is_flush || S_FLUSH1),
	.PRE_PC(S_PRE_PC),
	.basic_sp(basic_sp),
	.basic_gp(basic_gp),
    //output
    .NPC_ID(npc_id),
    .OPCODE(opcode),
    .RD(rd),
    .FUNC3(func3),
    .RF_OUT_A(rf_out_a),
    .RF_OUT_B(rf_out_b),
    .RS1(rs1),
    .RS2(rs2),
	.C_RS1(s_c_rs1),
	.C_RS2(s_c_rs2),
	.PRE_OPCODE(s_pre_opcode),
    .FUNC7(func7),
    .IMM(imm),
    .PC_PREDICT(pc_predict),
    .PREDICT_STATUS_REG(predict_status_reg),
    .PC_ID(pc_id));
EXE exe_stage(
    .clk(CLK),
    .rst(RSTn),
    .EN_EXE(start),
    .MEM_OUTPUT(mem_output),
    .RESULT_MEM(result_mem),
    .RF_OUT_A(rf_out_a),
    .RF_OUT_B(rf_out_b),
    .IMM(imm),
    .PC_ID(pc_id),
    .NPC_ID(npc_id),
    .RS1(rs1),
    .RS2(rs2),
    .RD(rd),
    .RD_MEM(rd_mem),
    .FUNC3(func3),
    .FUNC7(func7),
    .PREDICT_STATUS_REG(predict_status_reg),
    /////
    .F_SEL(f_sel),
    .AUIPC_SEL(auipc_sel),
    .IMM_RS2_SEL(imm_rs2_sel),
    .ALUOP(aluop),
    .JAL_SEL(jal_sel),
    .PC_IMM_SEL(pc_imm_sel),
    //////
    .PC_EXE(pc_exe),
    .RD_EXE(rd_exe),
    .RESULT_EXE(result_exe),
    .IS_FLUSH(is_flush),
    .NEW_STATUS(new_status),
    .VALUE_RS2(value_rs2));

MEM mem_stage(
    .clk(CLK),
    .rst(RSTn),
    .EN_MEM(start),
    .RD_EXE(rd_exe),
    .RESULT_EXE(result_exe),
    .MEM_DATA(rdata_mem),
	.VALID(valid_mem),
    //////
    .RD_MEM(rd_mem),
    .RESULT_MEM(result_mem),
    .MEM_OUTPUT(mem_output));

WB wb_stage (
    .SEL_WB(sel_wb),
    .RESULT_MEM(result_mem),
    .MEM_OUTPUT(mem_output),
    .WB_DATA(wdata));

CU control_unit (
    .clk(CLK),
    .rst(RSTn),
    .OPCODE(opcode),
    .IS_FLUSH(is_flush),
    .IF_CU({s0,s1,en_if,proc_req_if,we_if}),
    .ID_CU({en_read1,en_read2,imm_s0,imm_s1,imm_s2,is_j_type,en_id}),
    .EXE_CU({f_sel,auipc_sel,imm_rs2_sel,aluop,jal_sel,pc_imm_sel,en_exe}),
    .MEM_CU({proc_req_mem,we_mem,en_mem}),
    .WB_CU({sel_wb,en_write}),
	.valid_if(valid_if),
	.valid_mem(valid_mem),
	.mem_rdy_mem(mem_rdy_mem),
	.mem_rdy_if(mem_rdy_if),
	.is_stall(is_stall),
	.is_give_up(predict_status_reg[1]),
	.START(start),
	.FLUSH1(S_FLUSH1));

STALL_DETECTOR u_STALL_DETECTOR(
	.OPCODE(s_pre_opcode),
	.RS1(s_c_rs1),
	.RS2(s_c_rs2),
	.RD(rd),
	.IS_STALL(is_stall) 
);
assign addr_mem = result_exe;
assign wdata_mem = value_rs2;

endmodule

