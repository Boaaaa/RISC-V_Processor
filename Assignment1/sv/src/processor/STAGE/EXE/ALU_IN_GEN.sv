module ALU_IN_GEN #(
	parameter BITS = 32)
(
	input logic [1:0] SEL,
	input logic [BITS-1:0] IN,
	output logic [BITS-1:0] OUT,
	output logic PRE_C
);

//00 A, 01 CA, 10 NA, 11 0
logic [BITS:0] S_OUT;

always_comb begin 
	case(SEL)
		2'b00:
			S_OUT<= {1'b0,IN};
		2'b01:
			S_OUT <= {1'b0,~IN}+1;
			
		2'b10:
			S_OUT[BITS-1:0] <= {1'b0,~IN};
		2'b11:
			S_OUT <= 33'b0;
	endcase;
end


assign OUT = S_OUT[BITS-1:0];
assign PRE_C = S_OUT[BITS];

endmodule
