module PG(
	input a0,
	input b0,
	output P,
	output G
);
assign P = a0 ^ b0;
assign G = a0 & b0;
endmodule
