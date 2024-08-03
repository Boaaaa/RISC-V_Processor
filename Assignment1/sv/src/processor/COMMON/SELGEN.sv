module SELGEN #(
	parameter BITS = 5)
(
	input logic [BITS-1:0] A,
	input logic [BITS-1:0] B,
	output logic OUT 
);

always_comb begin 
	if(A == B && A != 5'b00000 && B != 5'b00000) begin
		OUT <= 1'b1;
	end
	else begin
		OUT <= 1'b0;
	end
end
endmodule
