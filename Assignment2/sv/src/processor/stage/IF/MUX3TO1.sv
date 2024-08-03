module MUX3TO1 #(
	parameter BITS = 32)
(
	input logic [BITS-1:0] in1,
	input logic [BITS-1:0] in2,
	input logic [BITS-1:0] in3,
	input logic [1:0] sel,
	output logic [BITS-1:0] out
);

logic [BITS-1:0] out_temp;

always_comb begin
	case(sel) 
		2'b00 : out_temp <= in1;
		2'b01 : out_temp <= in2;
		2'b10 : out_temp <= in3;
		default : out_temp <= 32'b0;
	endcase
end

assign out = out_temp;

endmodule
		
