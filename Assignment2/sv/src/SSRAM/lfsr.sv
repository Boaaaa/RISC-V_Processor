module LFSR(
	input CLK,
	input rst,
	output reg [3:0] op);
always@(posedge CLK) begin
	if(rst) begin
		op <= 4'hf;
	end else begin
		op <= {op[2:0],(op[3]^op[2])};
	end
end
endmodule
