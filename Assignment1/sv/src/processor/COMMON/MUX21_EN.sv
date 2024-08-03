module MUX21_EN #(
	parameter BITS = 32)
(
	input logic clk,
	input logic EN,
	input logic SEL,
	input logic [BITS-1:0] A,
	input logic [BITS-1:0] B,
	output logic [BITS-1:0] OUT 
);

logic [31:0] muxout;

always_ff@(posedge clk) begin
	if(EN) begin
		if(SEL == 1) begin
			muxout = B;
		end
		else begin
			muxout = A;
		end
	end
end

assign OUT = muxout;
endmodule
