module ADDER32 #( parameter BITS = 32)
(
	input logic [BITS-1:0] in1,
	input logic [BITS-1:0] in2,
	output logic [BITS-1:0] out
);

logic [32:0] result;
always_comb begin
	result <= in1 + in2;
end

assign out = result[31:0];

endmodule
	
