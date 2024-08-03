module CSA(
	input [1:0] a0,
	input [1:0] b0,
	input       c_s,
	output [1:0] s
);

wire  s_s0;
wire  s_c0;
wire  s_s1;
wire  s_c1;
 
wire  [1:0]s_sel0;
wire  [1:0]s_sel1;

assign s_s0 = a0[0]^b0[0];
assign s_c0 = (a0[0]&b0[0]);

assign s_s1 = a0[0]~^b0[0];
assign s_c1 = (a0[0] | b0[0]);

assign s_sel0[0] = s_s0;
assign s_sel0[1] = a0[1]^b0[1]^s_c0;

assign s_sel1[0] = s_s1;
assign s_sel1[1] = a0[1]^b0[1]^s_c1;

assign s = (c_s == 1'b1) ? s_sel1 : s_sel0;

endmodule
