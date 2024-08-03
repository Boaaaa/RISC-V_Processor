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
logic [31:0] RDATA_ii;
logic [31:0] RDATA_iii;
logic [31:0] WDATA_i;
logic [31:0] RDATA_i;
logic proc; 
logic mrdy;
logic write_finish;
logic [3:0] mem_rdy;
logic csb;
logic mem_rdy_i;
logic [1:0] same_addr;
logic [1:0] same_rdata;
logic [31:0] addr_reg;
logic state;
logic read_flag;
logic flag1;
logic cyc_count;
logic tencycs_flag;
logic flag2cycs;
logic cyc2count;
logic cyc1count;

LFSR lfsr_memrdy(
		.CLK(CLK),
		.rst(RSTn),
		.op(mem_rdy)
);

sram_32_1024_freepdk45 sram(
    .clk0(CLK),
	.csb0(csb),
	.web0(web),
	.addr0(ADDR_i[11:2]),
	.din0(WDATA_i),
	.dout0(RDATA_i));


always_comb begin
	if(ADDR[22] == 1 || ADDR[28] == 1) begin
		csb = 0;
	end else begin
		csb = 1;
	end
end
always @(posedge CLK) begin
	if(RSTn == 1) begin
		WDATA_i = 32'h00000000;
		VALID 	= 0;
		proc	= 0;
		mrdy	= 0;
		write_finish = 0;
		same_addr = 0;
		same_rdata = 0;
		ADDR_i = ADDR;
		RDATA_ii = 1;
		state = 0;
	end else begin
		if(PROC_REQ) begin
			proc = 1;
			if(MEM_RDY) begin
				mrdy = 1;
				state = 1;
				if(same_addr == 1) begin
					same_addr = 2;	
				end	
			end
		end
		if(proc == 1 && mrdy == 1) begin
			if(WE == 0) begin
			end else if(WE == 1) begin
				write_finish = 1;
			end
		end
	end
	if(flag1 == 1 && ADDR_i == ADDR && WE == 0) begin
		same_addr = 1;
		flag1 = 0;
	end
//////////////////////////////////////////////////
	if(write_finish) begin
		write_finish = 0;
		@(posedge CLK)
		VALID = 1;
		@(posedge CLK)
		VALID = 0;
		proc = 0;
		mrdy = 0;
	end
//////////////////////////////////////////////////
	if(read_flag == 1'b1 && cyc1count == 1'b0) begin
		RDATA = 32'hzzzzzzzz;
		VALID = 0;
		proc = 0;
		mrdy = 0;
		state = 0;
		read_flag = 0;	
		cyc1count = 0;
	end
//////////////////////////////////////////////////
	if(tencycs_flag == 1 && cyc_count < 4'h9) begin
		cyc_count = cyc_count + 1;
	end else if(cyc_count == 4'h9) begin
		if(state == 1 && proc == 1 && mrdy == 1 && VALID == 0) begin
			RDATA = RDATA_i;
			VALID = 1;
			@(posedge CLK);
			@(posedge CLK);
			RDATA = 32'hzzzzzzzz;
			VALID = 0;
			proc = 0;
			mrdy = 0;
			state = 0;
			cyc_count = 0;
			tencycs_flag = 0;
		end
	end
//////////////////////////////////////////////////
	if(state == 1 && proc == 1 && mrdy == 1 && VALID == 0) begin
		RDATA = RDATA_i;
		VALID = 1;
		flag2cycs = 1;
	end
//////////////////////////////////////////////////
	if(flag2cycs == 1'b1 && cyc2count < 1) begin
		cyc2count = cyc2count + 1;
	end
	else if(cyc2count == 1'b1) begin
		RDATA = 32'hzzzzzzzz;
		VALID = 0;
		proc = 0;
		mrdy = 0;
		state = 0;
		flag2cycs = 0;
		cyc2count = 0;
	end
//////////////////////////////////////////////////
end

always @(posedge PROC_REQ) begin
	flag1 = 1;
end

always @(RDATA_i or same_addr) begin
	if(same_addr == 0 && proc == 1 && mrdy == 1) begin
		RDATA_ii = RDATA_i;
		VALID = 1;
		read_flag = 1'b1;
	end else if(same_addr == 2 && proc == 1 && mrdy == 1) begin
		same_addr = 0;
		RDATA_ii = RDATA_i;
		VALID = 1;
		read_flag = 1'b1;		
	end
end
assign RDATA = RDATA_ii;
always @(negedge MEM_RDY) begin
	tencycs_flag = 1;		
end

always@(posedge CLK) begin
MEM_RDY <= mem_rdy[0] & PROC_REQ;
end
always@(posedge MEM_RDY) begin
	ADDR_i  = ADDR;
	WDATA_i = WDATA;
	web = ~WE;
end
endmodule


