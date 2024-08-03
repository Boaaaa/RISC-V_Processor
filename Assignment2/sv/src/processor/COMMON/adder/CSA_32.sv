module CSA_32(
	input logic  exist_carry,
	input logic  pre_carry,
	input logic [31:0] a_in,
	input logic [31:0] b_in,
	output logic [31:0] s_out,
	output  logic carry
);

logic [16:0] s_carry;

CLG u_CLG(
	.a(a_in),
	.b(b_in),
	.c(s_carry[16:1])
);

assign carry = (s_carry[16] | exist_carry);

assign s_out[0] = a_in[0] ^ b_in[0] ^ pre_carry;
assign s_carry[0] = (a_in[0] & b_in[0]) | (a_in[0] & pre_carry) | (b_in[0] & pre_carry);

assign s_out[31] = a_in[31] ^ b_in[31] ^ s_carry[15];

genvar i;

generate
	for(i=1;i<16;i=i+1)begin:BLOCK_CSA
		CSA u_CSA(
				.a0(a_in[2*i : 2*i-1]),
				.b0(b_in[2*i : 2*i-1]),
				.c_s(s_carry[i-1]),
				.s(s_out[2*i : 2*i-1])
		);
	end
endgenerate

endmodule
