module G_NET(
	input g0,
	input p1,
	input g1,
	output g_o
);

assign g_o = g1 | (p1 & g0);
endmodule
