module PG_NET(
	input p0,
	input g0,
	input p1,
	input g1,
	output p_o,
	output g_o
);

assign g_o = g1 | (p1 & g0);
assign p_o = p1 & p0;
endmodule
