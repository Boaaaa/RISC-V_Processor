module reg32 #(
	parameter BITS = 32)
(
	input logic clk,
	input logic rst,
	input logic en,
	input logic [BITS-1:0] regin,
	output logic [BITS-1:0] regout
);

logic [31:0] dataout;

always@(posedge clk) begin
		if(rst) 
			dataout <= 32'b0;
		else if(en)
			dataout <= regin;
end

assign regout = dataout;

endmodule 
