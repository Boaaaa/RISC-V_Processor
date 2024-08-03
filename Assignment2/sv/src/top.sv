module top (
input   logic   CLK,
input   logic   RSTn,
input 	logic	ini_PROC_REQ_ins,
input 	logic	ini_PROC_REQ_mem,
input 	logic	ini_WE_ins,
input 	logic	ini_WE_mem,
input 	logic [31:0]	ini_ADDR_ins,
input 	logic [31:0]	ini_ADDR_mem,
input 	logic [31:0]	ini_WDATA_ins,
input 	logic [31:0]	ini_WDATA_mem,
input   logic [31:0] basic_addr,
input 	logic [31:0] basic_sp,
input 	logic [31:0] basic_gp,
input 	logic	ini,
output 	logic	ini_MEM_RDY_ins,
output 	logic	ini_MEM_RDY_mem);

wire valid_if;
wire mem_rdy_if;
wire mem_rdy_mem;
wire valid_mem;
wire proc_req_if;
wire we_if;
logic [31:0] addr;
wire proc_req_mem;
wire we_mem;
wire [31:0] addr_mem;
wire [31:0] wdata_mem;
wire [31:0] rdata_if;
wire [31:0] rdata_mem;
wire [31:0] result_exe;
wire s_mem_rdy;
logic rstn_mux;
logic CLK_mux_if;
logic proc_req_mux_if;
logic [31:0] addr_mux_if;
logic [31:0] WDATA_mux_if;
logic we_if_mux_if;

logic CLK_mux_mem;
logic proc_req_mux_mem;
logic [31:0] addr_mux_mem;
logic [31:0] WDATA_mux_mem;
logic we_mem_mux_mem;
logic CLK_i;

localparam instmem = 0;
localparam datamem = 1;

always_comb begin
if(ini == 1) begin
	CLK_i = 0;
	CLK_mux_if = CLK;
	proc_req_mux_if = ini_PROC_REQ_ins;
	we_if_mux_if = ini_WE_ins;
	addr_mux_if = ini_ADDR_ins;
	WDATA_mux_if = ini_WDATA_ins;

	CLK_mux_mem = CLK;
	proc_req_mux_mem = ini_PROC_REQ_mem;
	we_mem_mux_mem = ini_WE_mem;
	addr_mux_mem = ini_ADDR_mem;
	WDATA_mux_mem = ini_WDATA_mem;

end else begin	
	CLK_i = CLK;
	CLK_mux_if = CLK;
	proc_req_mux_if = proc_req_if;
	we_if_mux_if = we_if;
	addr_mux_if = addr;
	WDATA_mux_if = 32'b0;

	CLK_mux_mem = CLK;
	proc_req_mux_mem = proc_req_mem;
	we_mem_mux_mem = we_mem;
	addr_mux_mem = addr_mem;
	WDATA_mux_mem = wdata_mem;
	
end
end

PROCESSOR u_PROCESSOR(
	.CLK(CLK_i),
	.RSTn(RSTn),
	.basic_addr(basic_addr),
	.basic_sp(basic_sp),
	.basic_gp(basic_gp),
	.valid_if(valid_if),
	.mem_rdy_mem(mem_rdy_mem),
	.mem_rdy_if(mem_rdy_if),
	.valid_mem(valid_mem),
	.rdata_if(rdata_if),
	.rdata_mem(rdata_mem),
	.proc_req_if(proc_req_if),
	.we_if(we_if),
	.addr(addr),
	.proc_req_mem(proc_req_mem),
	.we_mem(we_mem),
	.addr_mem(addr_mem),
	.wdata_mem(wdata_mem)
);

	
mem_wrap_fake mem_inst (
    .RSTn(RSTn),
    .CLK(CLK_mux_if),
	.PROC_REQ(proc_req_mux_if),
    .WE(we_if_mux_if),
    .ADDR(addr_mux_if),
    .WDATA(WDATA_mux_if),
    .MEM_RDY(mem_rdy_if),
    .RDATA(rdata_if),
    .VALID(valid_if)
);

mem_wrap_fake u_mem_data (
    .RSTn(RSTn),
    .CLK(CLK_mux_mem),
	.PROC_REQ(proc_req_mux_mem),
    .WE(we_mem_mux_mem),
    .ADDR(addr_mux_mem),
    .WDATA(WDATA_mux_mem),
    .MEM_RDY(mem_rdy_mem),
    .RDATA(rdata_mem),
    .VALID(valid_mem)
);
assign  ini_MEM_RDY_mem = mem_rdy_mem;
assign  ini_MEM_RDY_ins = mem_rdy_if;
endmodule
