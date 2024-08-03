module MEM #(
	parameter BITS = 32)
(
    //DATA
    input logic clk,
	input logic rst,
	input logic EN_MEM,
	input logic [4:0] RD_EXE,
	input logic [BITS-1:0] RESULT_EXE,
	input logic [BITS-1:0] MEM_DATA,
	input logic VALID,
	output logic [4:0] RD_MEM,
	output logic [BITS-1:0] RESULT_MEM,
	output logic [BITS-1:0] MEM_OUTPUT
);
logic [31:0] S_RDATA;
always@(posedge clk) begin
	if(VALID) begin
		S_RDATA = MEM_DATA;
	end else begin
		S_RDATA = S_RDATA;
	end
end										

reg32 #(5) u_RD_REG(
	.clk(clk),
	.rst(rst),
	.en(EN_MEM),
	.regin(RD_EXE),
	.regout(RD_MEM)
);

reg32 #(32) u_RESULT_MEM_REG(
	.clk(clk),
	.rst(rst),
	.en(EN_MEM),
	.regin(RESULT_EXE),
	.regout(RESULT_MEM)
);

reg32 #(32) u_MEM_OUTPUT_REG(
	.clk(clk),
	.rst(rst),
	.en(EN_MEM),
	.regin(S_RDATA),
	.regout(MEM_OUTPUT)
);
endmodule
