module STALL_DETECTOR #(
	parameter BITS = 5)
(
	input logic [6:0] OPCODE,
	input logic [BITS-1:0] RS1,
	input logic [BITS-1:0] RS2,
	input logic [BITS-1:0] RD,
	output logic IS_STALL 
);

always_comb begin 
	if(OPCODE == 7'b0000011) begin
		if((RS1 == RD || RS2 == RD) && (RD != 5'b0)) begin
			IS_STALL = 1'b1;
		end
		else begin
			IS_STALL = 1'b0;
		end
	end
	else begin
		IS_STALL = 1'b0;
	end
end
endmodule
