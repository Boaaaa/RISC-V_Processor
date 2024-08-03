module REG32_INNER_IF #(
	parameter BITS = 32)
(
	input logic clk,
	input logic rst,
	input logic en,
	input logic [BITS-1:0] regin,
	input logic [BITS-1:0] basic_addr,
	output logic [BITS-1:0] regout
);

logic [31:0] dataout;

always_ff@(posedge clk) begin
		if(rst) 
			dataout <= basic_addr;
		else if(en)
			dataout <= regin;
end

assign regout = dataout;

endmodule 
