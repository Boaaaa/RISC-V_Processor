module mem_wrap_fake (
	input logic RSTn,
	input logic CLK,
	input logic PROC_REQ,
	input logic WE,
	input logic [31:0] ADDR,
	input logic [31:0] WDATA,
	output logic MEM_RDY,
	output logic [31:0] RDATA,
	output logic VALID
);

logic web;
logic [31:0] ADDR_i;
logic [31:0] ADDR_ii;
logic [31:0] RDATA_ii;
logic [31:0] RDATA_iii;
logic [31:0] WDATA_i;
logic [31:0] RDATA_i;
logic VALID_i;
logic proc; 
logic mrdy;
logic write_finish;
logic [3:0] mem_rdy;
logic csb;
logic mem_rdy_i;
logic [1:0] same_addr;
logic [1:0] same_rdata;
logic [31:0] addr_reg;
logic not_first;
logic same;
LFSR lfsr_memrdy(
		.CLK(CLK),
		.rst(RSTn),
		.op(mem_rdy));

sram_32_1024_freepdk45 sram(
    .clk0(CLK),
	.csb0(csb),
	.web0(web),
	.addr0(ADDR[11:2]),
	.din0(WDATA),
	.dout0(RDATA));

always @(posedge CLK) begin
	if(RSTn == 1) begin
		VALID_i <= 0;
		MEM_RDY <= 0;
		csb = 1;
		web = 1;
		VALID <= 0;
		mrdy <= 0;
		proc <= 0;
		ADDR_i <= 0;
		RDATA_i <= 0;
		ADDR_ii <= 0;
		RDATA_ii <= 0;
		not_first <= 0;
	end else begin
		MEM_RDY <= mem_rdy[0] & PROC_REQ;
		if(PROC_REQ) begin
			csb = 0;
			proc <= 1;
			if(WE == 0) begin
				web = 1;
			end else begin
				web = 0;
			end
			same <= 1;
		end
		if(MEM_RDY) begin
			csb = 1;
			mrdy <= 1;
			if(not_first) begin
				ADDR_i <= ADDR;
			end
		end
		ADDR_ii <= ADDR_i;
		RDATA_ii <= RDATA_i;
		if(proc == 1 && mrdy == 1) begin
			if(ADDR_ii != ADDR || RDATA_ii != RDATA) begin
				VALID_i <= 1;
				VALID <= VALID_i;
				not_first <= 1;
				same <= 0;
				RDATA_i <= RDATA;
			end
			if(same) begin
				VALID <= 1;
				not_first <= 1;
				same <= 0;
				RDATA_i <= RDATA;
			end
		end
		if(VALID) begin
			VALID_i <= 0;
			VALID <= 0;
			proc <= 0;
			mrdy <= 0;
		end
	end
end
endmodule


