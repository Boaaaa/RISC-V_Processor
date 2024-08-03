module FSM #(
	parameter BITS = 2)
(
	input logic [BITS-1:0] OLD,
	input logic  FLAG,
	output logic [BITS-1:0] NEW_STATE 
);

	parameter LOW = 2'b00;
	parameter WEAK_LOW = 2'b01;
	parameter WEAK_HIGH = 2'b10;
	parameter HIGH = 2'b11;

always_comb begin
	case(OLD)
		LOW:
			case(FLAG)
				1'b0: NEW_STATE <= LOW;
				1'b1: NEW_STATE <= WEAK_LOW;
			endcase
		WEAK_LOW:
			case(FLAG)
				1'b0: NEW_STATE <= LOW;
				1'b1: NEW_STATE <= WEAK_HIGH;
			endcase
		WEAK_HIGH:
			case(FLAG)
				1'b0: NEW_STATE <= WEAK_LOW;
				1'b1: NEW_STATE <= HIGH;
			endcase
		HIGH:
			case(FLAG)
				1'b0: NEW_STATE <= WEAK_HIGH;
				1'b1: NEW_STATE <= HIGH;
			endcase
	endcase
end
endmodule
