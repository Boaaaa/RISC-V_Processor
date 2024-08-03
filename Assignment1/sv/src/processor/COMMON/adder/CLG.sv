module CLG(
	input [31:0] a,
	input [31:0] b,
	output [16:1] c
);

wire [31:0] s_p;
wire [31:0] s_g;

wire [15:0] s_p0;
wire [15:0] s_g0;
wire [15:1] s_p1;
wire [15:1] s_g1;
wire [15:2] s_p2;
wire [15:2] s_g2;
wire [15:4] s_p3;
wire [15:4] s_g3;
wire [15:8] s_p4;
wire [15:8] s_g4;
wire [15:16] s_p5;
wire [15:16] s_g5;


genvar i;
generate
	for(i=0; i<32; i=i+1) begin:BlockPG
		PG u_PG(
			.a0(a[i]),
			.b0(b[i]),
			.P(s_p[i]),
			.G(s_g[i])
		);
	end
endgenerate

generate
	for(i=0; i<16; i=i+1) begin:BlockPG0
		PG_NET u_PG_NET0(
			.p0(s_p[2*i]),
			.g0(s_g[2*i]),
			.p1(s_p[2*i+1]),
			.g1(s_g[2*i+1]),
			.p_o(s_p0[i]),
			.g_o(s_g0[i])
		);
	end
endgenerate

generate
	for(i=1; i<16; i=i+1) begin:BlockPG1
		PG_NET u_PG_NET1(
			.p0(s_p0[i-1]),
			.g0(s_g0[i-1]),
			.p1(s_p0[i]),
			.g1(s_g0[i]),
			.p_o(s_p1[i]),
			.g_o(s_g1[i])
		);
	end
endgenerate

PG_NET u_PG_NET2_0(
			.p0(s_p0[0]),
			.g0(s_g0[0]),
			.p1(s_p1[2]),
			.g1(s_g1[2]),
			.p_o(s_p2[2]),
			.g_o(s_g2[2])
		);
		
generate
	for(i=3; i<16; i=i+1) begin:BlockPG2
		PG_NET u_PG_NET2(
			.p0(s_p1[i-2]),
			.g0(s_g1[i-2]),
			.p1(s_p1[i]),
			.g1(s_g1[i]),
			.p_o(s_p2[i]),
			.g_o(s_g2[i])
		);
	end
endgenerate

PG_NET u_PG_NET3_0(
			.p0(s_p0[0]),
			.g0(s_g0[0]),
			.p1(s_p2[4]),
			.g1(s_g2[4]),
			.p_o(s_p3[4]),
			.g_o(s_g3[4])
		);
		
PG_NET u_PG_NET3_1(
			.p0(s_p1[1]),
			.g0(s_g1[1]),
			.p1(s_p2[5]),
			.g1(s_g2[5]),
			.p_o(s_p3[5]),
			.g_o(s_g3[5])
		);
		
generate
	for(i=6; i<16; i=i+1) begin:BlockPG3
		PG_NET u_PG_NET2(
			.p0(s_p2[i-4]),
			.g0(s_g2[i-4]),
			.p1(s_p2[i]),
			.g1(s_g2[i]),
			.p_o(s_p3[i]),
			.g_o(s_g3[i])
		);
	end
endgenerate

PG_NET u_PG_NET4_0(
			.p0(s_p0[0]),
			.g0(s_g0[0]),
			.p1(s_p3[8]),
			.g1(s_g3[8]),
			.p_o(s_p4[8]),
			.g_o(s_g4[8])
		);

PG_NET u_PG_NET4_1(
			.p0(s_p1[1]),
			.g0(s_g1[1]),
			.p1(s_p3[9]),
			.g1(s_g3[9]),
			.p_o(s_p4[9]),
			.g_o(s_g4[9])
		);
		
PG_NET u_PG_NET4_2(
			.p0(s_p2[2]),
			.g0(s_g2[2]),
			.p1(s_p3[10]),
			.g1(s_g3[10]),
			.p_o(s_p4[10]),
			.g_o(s_g4[10])
		);
		
PG_NET u_PG_NET4_3(
			.p0(s_p2[3]),
			.g0(s_g2[3]),
			.p1(s_p3[11]),
			.g1(s_g3[11]),
			.p_o(s_p4[11]),
			.g_o(s_g4[11])
		);
		
generate
	for(i=12; i<16; i=i+1) begin:BlockPG4
		PG_NET u_PG_NET2(
			.p0(s_p3[i-8]),
			.g0(s_g3[i-8]),
			.p1(s_p3[i]),
			.g1(s_g3[i]),
			.p_o(s_p4[i]),
			.g_o(s_g4[i])
		);
	end
endgenerate		
				

G_NET u_G_C0(
			.g0(s_g0[0]),
			.p1(s_p[2]),
			.g1(s_g[2]),
			.g_o(c[1])
		);

G_NET u_G_C1(
			.g0(s_g1[1]),
			.p1(s_p[4]),
			.g1(s_g[4]),
			.g_o(c[2])
		);
		
G_NET u_G_C2(
			.g0(s_g2[2]),
			.p1(s_p[6]),
			.g1(s_g[6]),
			.g_o(c[3])
		);

G_NET u_G_C3(
			.g0(s_g2[3]),
			.p1(s_p[8]),
			.g1(s_g[8]),
			.g_o(c[4])
		);

generate 
	for(i=4;i<8;i=i+1) begin:C_BLOCK_0
		G_NET u_G_C47(
			.g0(s_g3[i]),
			.p1(s_p[2+2*i]),
			.g1(s_g[2+2*i]),
			.g_o(c[i+1])
		);
	end
endgenerate

generate 
	for(i=8;i<15;i=i+1) begin:C_BLOCK_1
		G_NET u_G_C47(
			.g0(s_g4[i]),
			.p1(s_p[2+2*i]),
			.g1(s_g[2+2*i]),
			.g_o(c[i+1])
		);
	end
endgenerate

assign c[16] = s_g4[15];
endmodule
