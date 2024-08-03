module top (
input   logic   CLK,
input   logic   RSTn,
input   logic [31:0] basic_addr,
input 	logic [31:0] basic_sp,
input 	logic [31:0] basic_gp);

wire valid_if;
wire mem_rdy_if;
wire mem_rdy_mem;
wire valid_mem;
wire proc_req_if;
wire we_if;
wire [31:0] addr;
wire proc_req_mem;
wire we_mem;
wire [31:0] addr_mem;
wire [31:0] wdata_mem;
wire [31:0] rdata_if;
wire [31:0] rdata_mem;
wire [31:0] result_exe;
wire s_mem_rdy;
logic s_proc_req_if;
logic s_proc_req_mem;
localparam instmem = 0;
localparam datamem = 1;

PROCESSOR u_PROCESSOR(
	.CLK(CLK),
	.RSTn(RSTn),
	.basic_addr(basic_addr),
	.valid_if(valid_if),
	.mem_rdy_mem(mem_rdy_mem),
	.mem_rdy_if(mem_rdy_if),
	.valid_mem(valid_mem),
	.rdata_if(rdata_if),
	.rdata_mem(rdata_mem),
	.basic_sp(basic_sp),
	.basic_gp(basic_gp),
	.proc_req_if(proc_req_if),
	.we_if(we_if),
	.addr(addr),
	.proc_req_mem(proc_req_mem),
	.we_mem(we_mem),
	.addr_mem(addr_mem),
	.wdata_mem(wdata_mem)
);

mem_wrap_fake #(
	.CONTENT_TYPE(instmem)
) mem_inst (
    .RSTn(!RSTn),
    .CLK(CLK),
    //.PROC_REQ(proc_req_if & (!valid_if) ),
	.PROC_REQ(proc_req_if),
	//.PROC_REQ(s_proc_req_if),
    .WE(we_if),
    .ADDR(addr),
    .WDATA(32'b0),
    .MEM_RDY(mem_rdy_if),
    .RDATA(rdata_if),
    .VALID(valid_if)
);

//always@(posedge CLK) begin
//	if(proc_req_mem && (!valid_mem)) begin
//		s_proc_req_mem = 1'b1;
//	end
//	else begin
//		s_proc_req_mem = 1'b0;
//	end
//end

mem_wrap_fake #(
	.CONTENT_TYPE(datamem)
) u_mem_data (
    .RSTn(!RSTn),
    .CLK(CLK),
    //.PROC_REQ(proc_req_mem & (!valid_mem)),
	.PROC_REQ(proc_req_mem),
	//.PROC_REQ(s_proc_req_mem),
    .WE(we_mem),
    .ADDR(addr_mem),
    .WDATA(wdata_mem),
    .MEM_RDY(mem_rdy_mem),
    .RDATA(rdata_mem),
    .VALID(valid_mem)
);

//data_dumper u_dump(
	//.CLK(CLK),
	//.RSTn(!RSTn),
	//.RDATA(wdata_mem),
	//.VALID(valid_mem));
endmodule
