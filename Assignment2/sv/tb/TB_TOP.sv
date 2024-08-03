module TB_TOP();

logic  CLK_i;
logic  RSTn_i;
logic  ini_clk_i;
logic  ini_proc_req_ins_i;
logic  ini_proc_req_mem_i;
logic  ini_we_ins_i;
logic  ini_we_mem_i;
logic [31:0] ini_addr_ins_i;
logic [31:0] ini_addr_mem_i;
logic [31:0] ini_wdata_ins_i;
logic [31:0] ini_wdata_mem_i;
logic  ini_mem_rdy_ins;
logic  ini_mem_rdy_mem;
logic  ini_i;
integer fd_ins;
integer fd_mem;
integer code;
logic [31:0] addr;
logic [31:0] data;
logic [31:0] basic_addr;
logic [31:0] basic_sp;
logic [31:0] basic_gp;

initial begin
	basic_addr = 32'h003ffffc;
	basic_sp =   32'h7fffeffc;
	basic_gp =   32'h10008000;
	CLK_i = 1'b0;
	ini_i = 1'b1;
	#5
	RSTn_i = 1'b1;
	CLK_i  = 1'b1;
	#5
	CLK_i  = 1'b0;
	#5 
	RSTn_i = 1'b0;
	CLK_i  = 1'b1;
	#5
	CLK_i  = 1'b0;
	ini_we_ins_i = 1'b1;
	ini_we_mem_i = 1'b1;
	ini_proc_req_ins_i = 1'b1;
	ini_proc_req_mem_i = 1'b1;
	fd_ins = $fopen("./main.txt","r");
	fd_mem = $fopen("./data.txt","r");
	while(!$feof(fd_ins)) begin
		#5
		CLK_i = 1'b1;
		if(ini_mem_rdy_ins) begin
			code = $fscanf(fd_ins,"%h: %h",addr,data);
			ini_addr_ins_i = addr;
			ini_wdata_ins_i = data;
		end
		#5
		CLK_i = 1'b0;
		#5
		CLK_i = 1'b1;
		#5
		CLK_i = 1'b0;
		#5
		CLK_i = 1'b1;
		#5
		CLK_i = 1'b0;
		#5
		CLK_i = 1'b1;
		#5
		CLK_i = 1'b0;
	end
	#5
	CLK_i = 1'b1;
	ini_addr_ins_i = addr + 32'h4;
	ini_wdata_ins_i = 32'h0;
	#5
	CLK_i = 1'b0;
	#5
	CLK_i = 1'b1;
	#5
	CLK_i = 1'b0;
	#5
	CLK_i = 1'b1;
	#5
	CLK_i = 1'b0;
	#5
	CLK_i = 1'b1;
	#5
	CLK_i = 1'b0;
	#5
	CLK_i = 1'b1;
	#5
	CLK_i = 1'b0;
	#5
	CLK_i = 1'b1;
	#5
	CLK_i = 1'b0;
	#5
	CLK_i = 1'b1;
	ini_addr_ins_i = addr + 32'h8;
	ini_wdata_ins_i = 32'h0;
	#5
	CLK_i = 1'b0;
	while(!$feof(fd_mem)) begin
		#5
		CLK_i = 1'b1;
		if(ini_mem_rdy_mem) begin
			code = $fscanf(fd_mem,"%h:%h",addr,data);
			ini_addr_mem_i = addr;
			ini_wdata_mem_i = data;
		end
		#5
		CLK_i = 1'b0;
		#5
		CLK_i = 1'b1;
		#5
		CLK_i = 1'b0;
		#5
		CLK_i = 1'b1;
		#5
		CLK_i = 1'b0;
		#5
		CLK_i = 1'b1;
		#5
		CLK_i = 1'b0;
	end
	$fclose(fd_ins);
	$fclose(fd_mem);
	ini_i = 1'b0;

CLK_i = 1'b0;
#5
CLK_i = 1'b1;
RSTn_i = 1'b1;
#5
CLK_i = 1'b0;
#5
CLK_i = 1'b1;
RSTn_i = 1'b0;
forever #5 CLK_i = ~CLK_i;

end

top u_tb_top(
	.CLK(CLK_i),
	.RSTn(RSTn_i),
	.ini_PROC_REQ_ins(ini_proc_req_ins_i),
	.ini_PROC_REQ_mem(ini_proc_req_mem_i),
	.ini_WE_ins(ini_we_ins_i),
	.ini_WE_mem(ini_we_mem_i),
	.ini_ADDR_ins(ini_addr_ins_i),
	.ini_ADDR_mem(ini_addr_mem_i),
	.ini_WDATA_ins(ini_wdata_ins_i),
	.ini_WDATA_mem(ini_wdata_mem_i),
	.basic_addr(basic_addr),
	.basic_sp(basic_sp),
	.basic_gp(basic_gp),
	.ini_MEM_RDY_ins(ini_mem_rdy_ins),
	.ini_MEM_RDY_mem(ini_mem_rdy_mem),
	.ini(ini_i)
	);

endmodule
