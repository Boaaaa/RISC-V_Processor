module MUX31 #(
	parameter BITS = 32)
(
	input logic [1:0]SEL,
	input logic [BITS-1:0] A,
	input logic [BITS-1:0] B,
	input logic [BITS-1:0] C,
	output logic [BITS-1:0] OUT 
);

always_comb begin 
	case(SEL)
		2'b00:
			OUT <= A;
		2'b01:
			OUT <= B;
		2'b10:
			OUT <= C;
		2'b11:
			OUT <= C;
	endcase
end
endmodule
