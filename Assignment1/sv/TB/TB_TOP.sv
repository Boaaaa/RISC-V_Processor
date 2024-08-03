module TB_TOP();

reg  CLK_i;
reg  RSTn_i;
logic [31:0] basic_addr;
logic [31:0] basic_sp;
logic [31:0] basic_gp;

initial begin
CLK_i = 1'b0;
forever #5 CLK_i = ~CLK_i;
end


initial begin
	basic_addr <= 32'h003ffffc;
	basic_sp <=   32'h7fffeffc;
	basic_gp <=   32'h10008000;
	#5
	RSTn_i <= 1'b1;
	#10 
	RSTn_i <= 1'b0;
end

top u_tb_top(
	.CLK(CLK_i),
	.RSTn(RSTn_i),
	.basic_addr(basic_addr),
	.basic_sp(basic_sp),
	.basic_gp(basic_gp)
	);

endmodule
