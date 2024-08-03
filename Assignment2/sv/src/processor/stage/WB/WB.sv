module WB #(
	parameter BITS = 32)
(
    //DATA
    input logic SEL_WB,
	input logic [BITS-1:0] RESULT_MEM,
	input logic [BITS-1:0] MEM_OUTPUT,
	
	output logic [BITS-1:0] WB_DATA
);
										

MUX21 #(32) u_MUX_WB(
	.SEL(SEL_WB),
	.A(RESULT_MEM),
	.B(MEM_OUTPUT),
	.OUT(WB_DATA)
);
endmodule
