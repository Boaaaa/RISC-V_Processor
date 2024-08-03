module MUX21 #(
	parameter BITS = 32)
(
	input logic SEL,
	input logic [BITS-1:0] A,
	input logic [BITS-1:0] B,
	output logic [BITS-1:0] OUT 
);

always_comb begin 
	if(SEL == 1) begin
		OUT <= B;
	end
	else begin
		OUT <= A;
	end
end
endmodule
