module CMP_ALU #(
	parameter BITS = 32)
(
	input logic SIGNED_OR_UNSIGNED,   //0-unsigned, 1-signed
	input logic [BITS-1:0] A,
	input logic [BITS-1:0] B,
	output logic [3:0] OUT 
);

logic [BITS-1:0] CMP_RST;
logic signed [BITS-1:0] S_A;
logic signed [BITS-1:0] S_B;
logic [BITS-1:0] UN_S_A;
logic [BITS-1:0] UN_S_B;
always_comb begin 
	if(SIGNED_OR_UNSIGNED) begin
		S_A = A;
		S_B = B;
		if(S_A > S_B) begin
			OUT = 4'b0010;
		end
		else if(S_A < S_B) begin
			OUT = 4'b0011;
		end
		else begin
			OUT = 4'b0001;
		end
	end else begin
		UN_S_A = A;
		UN_S_B = B;
		if(UN_S_A > UN_S_B) begin
			OUT = 4'b0010;
		end
		else if(UN_S_A < UN_S_B) begin
			OUT = 4'b0011;
		end
		else begin
			OUT = 4'b0001;
		end
	end
end	
endmodule
