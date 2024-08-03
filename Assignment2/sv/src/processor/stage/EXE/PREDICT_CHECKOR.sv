module PREDICT_CHECKOR #(
	parameter BITS = 4)
(
	input logic [1:0] PREDICT_STATUS,
	input logic [BITS-1:0] CMP_FLAG,
	input logic [BITS-1:0] CMP_TYPE,
	output logic IS_BRANCH,
	output logic PREDICT_RESULT
);
	parameter NORMAL = 4'b0000;
	parameter EQ = 4'b0001;
	parameter G  = 4'b0010;
	parameter L =  4'b0011;
	
	parameter JAL = 4'b1111;
	parameter TYPE_EQ = 4'b1001;
	parameter TYPE_G = 4'b1010;
	parameter TYPE_L = 4'b1011;
	parameter TYPE_NE = 4'b1100;
	parameter TYPE_GE_SIGNED = 4'b0001;
	parameter TYPE_LTU_UNSIGNED = 4'b0010;
	
	
	parameter LOW = 2'b00;
	parameter WEAK_LOW = 2'b01;
	parameter WEAK_HIGH = 2'b10;
	parameter HIGH = 2'b11;
	
always_comb begin 
	case(CMP_TYPE)
		NORMAL: begin
			IS_BRANCH <= 1'b1;
			PREDICT_RESULT <= 1'b1;
		end
		TYPE_EQ: begin
			if(EQ == CMP_FLAG) begin
				IS_BRANCH <= 1'b0;
				if((WEAK_HIGH == PREDICT_STATUS) ||(HIGH == PREDICT_STATUS)) begin
					PREDICT_RESULT <= 1'b1;
				end
				else begin
					PREDICT_RESULT <= 1'b0;
				end
			end
			else begin
				IS_BRANCH <= 1'b1;
				PREDICT_RESULT <= 1'b0;
			end
		end
		TYPE_G:begin
			if(G == CMP_FLAG) begin
				IS_BRANCH <= 1'b0;
				if((WEAK_HIGH == PREDICT_STATUS) ||(HIGH == PREDICT_STATUS)) begin
					PREDICT_RESULT <= 1'b1;
				end
				else begin
					PREDICT_RESULT <= 1'b0;
				end
			end
			else begin
				IS_BRANCH <= 1'b1;
				PREDICT_RESULT <= 1'b0;
			end
		end
		TYPE_L:begin
			if(L == CMP_FLAG) begin
				IS_BRANCH <= 1'b0;
				if((WEAK_HIGH == PREDICT_STATUS) ||(HIGH == PREDICT_STATUS)) begin
					PREDICT_RESULT <= 1'b1;
				end
				else begin
					PREDICT_RESULT <= 1'b0;
				end
			end
			else begin
				IS_BRANCH <= 1'b1;
				PREDICT_RESULT <= 1'b0;
			end
		end
		TYPE_NE:begin
			if(L == CMP_FLAG || G == CMP_FLAG) begin
				IS_BRANCH <= 1'b0;
				if((WEAK_HIGH == PREDICT_STATUS) ||(HIGH == PREDICT_STATUS)) begin
					PREDICT_RESULT <= 1'b1;
				end
				else begin
					PREDICT_RESULT <= 1'b0;
				end
			end
			else begin
				IS_BRANCH <= 1'b1;
				PREDICT_RESULT <= 1'b0;
			end
		end
		TYPE_GE_SIGNED:begin
			if((EQ == CMP_FLAG) || (G == CMP_FLAG)) begin
				IS_BRANCH <= 1'b0;
				if((WEAK_HIGH == PREDICT_STATUS) ||(HIGH == PREDICT_STATUS)) begin
					PREDICT_RESULT <= 1'b1;
				end
				else begin
					PREDICT_RESULT <= 1'b0;
				end
			end
			else begin
				IS_BRANCH <= 1'b1;
				PREDICT_RESULT <= 1'b0;
			end
		end
		TYPE_LTU_UNSIGNED:begin
			if(L == CMP_FLAG) begin
				IS_BRANCH <= 1'b0;
				if((WEAK_HIGH == PREDICT_STATUS) ||(HIGH == PREDICT_STATUS)) begin
					PREDICT_RESULT <= 1'b1;
				end
				else begin
					PREDICT_RESULT <= 1'b0;
				end
			end
			else begin
				IS_BRANCH <= 1'b1;
				PREDICT_RESULT <= 1'b0;
			end
		end
		JAL:begin
			IS_BRANCH <= 1'b0;
			PREDICT_RESULT <= 1'b0;
		end
		default: begin
			IS_BRANCH <= 1'b1;
			PREDICT_RESULT <= 1'b1;
		end
	endcase
end
endmodule
