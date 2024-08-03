module BTB #(
	parameter BITS = 32)
(
	input logic rst,
	input logic [BITS-1:0] LOOK_UP_ADDR,
	input logic IS_J_TYPE,
	input logic IS_J_TYPE_WRITE,
	input logic EN_WRITE,
	input logic [BITS-1:0] W_ADDR,
	input logic [BITS-1:0] TARGET_ADDR,
	input logic [1:0] NEW_STATUS,
	input logic [1:0] INDEX_BTB,
	output logic [1:0] STATUS,
	output logic [BITS-1:0] TARGET,
	output logic [1:0] INDEX_OUT_BTB 
);

logic [BITS-1:0] LOOK_UP_ADDR_ARRAY [7:0][3:0];
logic [BITS-1:0] TARGET_ADDR_ARRAY  [7:0][3:0];
logic [1:0] STATUS_ADDR_ARRAY [7:0][3:0];

logic [3:0] i;

always_comb begin 
	if (rst) begin
		for (i=0; i<8; i++) begin
			for (int j=0; j<4; j++) begin
				LOOK_UP_ADDR_ARRAY[i][j] = 32'b0;
				TARGET_ADDR_ARRAY[i][j] = 32'b0;
				STATUS_ADDR_ARRAY[i][j] = 2'b0;
			end
		end
	end
	else if(IS_J_TYPE) begin
		case(LOOK_UP_ADDR[4:2]) 
			3'b000:begin
				if (LOOK_UP_ADDR_ARRAY[0][0] == 32'b0) begin
					TARGET = 0;
					STATUS = 0;
					INDEX_OUT_BTB = 0;
				end
				else if (LOOK_UP_ADDR == LOOK_UP_ADDR_ARRAY[0][0]) begin
					TARGET = TARGET_ADDR_ARRAY[0][0];
					STATUS = STATUS_ADDR_ARRAY[0][0];
					INDEX_OUT_BTB = 0;
				end else if (LOOK_UP_ADDR_ARRAY[0][1] == 32'b0) begin
					TARGET = 0;
					STATUS = 0;
					INDEX_OUT_BTB = 1;
				end else if (LOOK_UP_ADDR == LOOK_UP_ADDR_ARRAY[0][1]) begin
					TARGET = TARGET_ADDR_ARRAY[0][1];
					STATUS = STATUS_ADDR_ARRAY[0][1];
					INDEX_OUT_BTB = 1;
				end else if (LOOK_UP_ADDR_ARRAY[0][2] == 32'b0) begin
					TARGET = 0;
					STATUS = 0;
					INDEX_OUT_BTB = 2;
				end else if (LOOK_UP_ADDR == LOOK_UP_ADDR_ARRAY[0][2]) begin
					TARGET = TARGET_ADDR_ARRAY[0][2];
					STATUS = STATUS_ADDR_ARRAY[0][2];
					INDEX_OUT_BTB = 2;
				end else if (LOOK_UP_ADDR_ARRAY[0][3] == 32'b0) begin
					TARGET = 0;
					STATUS = 0;
					INDEX_OUT_BTB = 3;
				end else if (LOOK_UP_ADDR == LOOK_UP_ADDR_ARRAY[0][3]) begin
					TARGET = TARGET_ADDR_ARRAY[0][3];
					STATUS = STATUS_ADDR_ARRAY[0][3];
					INDEX_OUT_BTB = 3;
				end else begin
					TARGET = 0;
					STATUS = 0;
					INDEX_OUT_BTB = 0;
				end
			end
			3'b001:begin
				if (LOOK_UP_ADDR_ARRAY[1][0] == 32'b0) begin
					TARGET = 0;
					STATUS = 0;
					INDEX_OUT_BTB = 0;
				end
				else if (LOOK_UP_ADDR == LOOK_UP_ADDR_ARRAY[1][0]) begin
					TARGET = TARGET_ADDR_ARRAY[1][0];
					STATUS = STATUS_ADDR_ARRAY[1][0];
					INDEX_OUT_BTB = 0;
				end else if (LOOK_UP_ADDR_ARRAY[1][1] == 32'b0) begin
					TARGET = 0;
					STATUS = 0;
					INDEX_OUT_BTB = 1;
				end else if (LOOK_UP_ADDR == LOOK_UP_ADDR_ARRAY[1][1]) begin
					TARGET = TARGET_ADDR_ARRAY[1][1];
					STATUS = STATUS_ADDR_ARRAY[1][1];
					INDEX_OUT_BTB = 1;
				end else if (LOOK_UP_ADDR_ARRAY[1][2] == 32'b0) begin
					TARGET = 0;
					STATUS = 0;
					INDEX_OUT_BTB = 2;
				end else if (LOOK_UP_ADDR == LOOK_UP_ADDR_ARRAY[1][2]) begin
					TARGET = TARGET_ADDR_ARRAY[1][2];
					STATUS = STATUS_ADDR_ARRAY[1][2];
					INDEX_OUT_BTB = 2;
				end else if (LOOK_UP_ADDR_ARRAY[1][3] == 32'b0) begin
					TARGET = 0;
					STATUS = 0;
					INDEX_OUT_BTB = 3;
				end else if (LOOK_UP_ADDR == LOOK_UP_ADDR_ARRAY[1][3]) begin
					TARGET = TARGET_ADDR_ARRAY[1][3];
					STATUS = STATUS_ADDR_ARRAY[1][3];
					INDEX_OUT_BTB = 3;
				end else begin
					TARGET = 0;
					STATUS = 0;
					INDEX_OUT_BTB = 0;
				end
			end
			3'b010:begin 
				if (LOOK_UP_ADDR_ARRAY[2][0] == 32'b0) begin
					TARGET = 0;
					STATUS = 0;
					INDEX_OUT_BTB = 0;
				end
				else if (LOOK_UP_ADDR == LOOK_UP_ADDR_ARRAY[2][0]) begin
					TARGET = TARGET_ADDR_ARRAY[2][0];
					STATUS = STATUS_ADDR_ARRAY[2][0];
					INDEX_OUT_BTB = 0;
				end else if (LOOK_UP_ADDR_ARRAY[2][1] == 32'b0) begin
					TARGET = 0;
					STATUS = 0;
					INDEX_OUT_BTB = 1;
				end else if (LOOK_UP_ADDR == LOOK_UP_ADDR_ARRAY[2][1]) begin
					TARGET = TARGET_ADDR_ARRAY[2][1];
					STATUS = STATUS_ADDR_ARRAY[2][1];
					INDEX_OUT_BTB = 1;
				end else if (LOOK_UP_ADDR_ARRAY[2][2] == 32'b0) begin
					TARGET = 0;
					STATUS = 0;
					INDEX_OUT_BTB = 2;
				end else if (LOOK_UP_ADDR == LOOK_UP_ADDR_ARRAY[2][2]) begin
					TARGET = TARGET_ADDR_ARRAY[2][2];
					STATUS = STATUS_ADDR_ARRAY[2][2];
					INDEX_OUT_BTB = 2;
				end else if (LOOK_UP_ADDR_ARRAY[2][3] == 32'b0) begin
					TARGET = 0;
					STATUS = 0;
					INDEX_OUT_BTB = 3;
				end else if (LOOK_UP_ADDR == LOOK_UP_ADDR_ARRAY[2][3]) begin
					TARGET = TARGET_ADDR_ARRAY[2][3];
					STATUS = STATUS_ADDR_ARRAY[2][3];
					INDEX_OUT_BTB = 3;
				end else begin
					TARGET = 0;
					STATUS = 0;
					INDEX_OUT_BTB = 0;
				end
			end
			3'b011:begin
				if (LOOK_UP_ADDR_ARRAY[3][0] == 32'b0) begin
					TARGET = 0;
					STATUS = 0;
					INDEX_OUT_BTB = 0;
				end
				else if (LOOK_UP_ADDR == LOOK_UP_ADDR_ARRAY[3][0]) begin
					TARGET = TARGET_ADDR_ARRAY[3][0];
					STATUS = STATUS_ADDR_ARRAY[3][0];
					INDEX_OUT_BTB = 0;
				end else if (LOOK_UP_ADDR_ARRAY[3][1] == 32'b0) begin
					TARGET = 0;
					STATUS = 0;
					INDEX_OUT_BTB = 1;
				end else if (LOOK_UP_ADDR == LOOK_UP_ADDR_ARRAY[3][1]) begin
					TARGET = TARGET_ADDR_ARRAY[3][1];
					STATUS = STATUS_ADDR_ARRAY[3][1];
					INDEX_OUT_BTB = 1;
				end else if (LOOK_UP_ADDR_ARRAY[3][2] == 32'b0) begin
					TARGET = 0;
					STATUS = 0;
					INDEX_OUT_BTB = 2;
				end else if (LOOK_UP_ADDR == LOOK_UP_ADDR_ARRAY[3][2]) begin
					TARGET = TARGET_ADDR_ARRAY[3][2];
					STATUS = STATUS_ADDR_ARRAY[3][2];
					INDEX_OUT_BTB = 2;
				end else if (LOOK_UP_ADDR_ARRAY[3][3] == 32'b0) begin
					TARGET = 0;
					STATUS = 0;
					INDEX_OUT_BTB = 3;
				end else if (LOOK_UP_ADDR == LOOK_UP_ADDR_ARRAY[3][3]) begin
					TARGET = TARGET_ADDR_ARRAY[3][3];
					STATUS = STATUS_ADDR_ARRAY[3][3];
					INDEX_OUT_BTB = 3;
				end else begin
					TARGET = 0;
					STATUS = 0;
					INDEX_OUT_BTB = 0;
				end
			end
			3'b100:begin
				if (LOOK_UP_ADDR_ARRAY[4][0] == 32'b0) begin
					TARGET = 0;
					STATUS = 0;
					INDEX_OUT_BTB = 0;
				end
				else if (LOOK_UP_ADDR == LOOK_UP_ADDR_ARRAY[4][0]) begin
					TARGET = TARGET_ADDR_ARRAY[4][0];
					STATUS = STATUS_ADDR_ARRAY[4][0];
					INDEX_OUT_BTB = 0;
				end else if (LOOK_UP_ADDR_ARRAY[4][1] == 32'b0) begin
					TARGET = 0;
					STATUS = 0;
					INDEX_OUT_BTB = 1;
				end else if (LOOK_UP_ADDR == LOOK_UP_ADDR_ARRAY[4][1]) begin
					TARGET = TARGET_ADDR_ARRAY[4][1];
					STATUS = STATUS_ADDR_ARRAY[4][1];
					INDEX_OUT_BTB = 1;
				end else if (LOOK_UP_ADDR_ARRAY[4][2] == 32'b0) begin
					TARGET = 0;
					STATUS = 0;
					INDEX_OUT_BTB = 2;
				end else if (LOOK_UP_ADDR == LOOK_UP_ADDR_ARRAY[4][2]) begin
					TARGET = TARGET_ADDR_ARRAY[4][2];
					STATUS = STATUS_ADDR_ARRAY[4][2];
					INDEX_OUT_BTB = 2;
				end else if (LOOK_UP_ADDR_ARRAY[4][3] == 32'b0) begin
					TARGET = 0;
					STATUS = 0;
					INDEX_OUT_BTB = 3;
				end else if (LOOK_UP_ADDR == LOOK_UP_ADDR_ARRAY[4][3]) begin
					TARGET = TARGET_ADDR_ARRAY[4][3];
					STATUS = STATUS_ADDR_ARRAY[4][3];
					INDEX_OUT_BTB = 3;
				end else begin
					TARGET = 0;
					STATUS = 0;
					INDEX_OUT_BTB = 0;
				end
			end
			3'b101:begin 
				if (LOOK_UP_ADDR_ARRAY[5][0] == 32'b0) begin
					TARGET = 0;
					STATUS = 0;
					INDEX_OUT_BTB = 0;
				end
				else if (LOOK_UP_ADDR == LOOK_UP_ADDR_ARRAY[5][0]) begin
					TARGET = TARGET_ADDR_ARRAY[5][0];
					STATUS = STATUS_ADDR_ARRAY[5][0];
					INDEX_OUT_BTB = 0;
				end else if (LOOK_UP_ADDR_ARRAY[5][1] == 32'b0) begin
					TARGET = 0;
					STATUS = 0;
					INDEX_OUT_BTB = 1;
				end else if (LOOK_UP_ADDR == LOOK_UP_ADDR_ARRAY[5][1]) begin
					TARGET = TARGET_ADDR_ARRAY[5][1];
					STATUS = STATUS_ADDR_ARRAY[5][1];
					INDEX_OUT_BTB = 1;
				end else if (LOOK_UP_ADDR_ARRAY[5][2] == 32'b0) begin
					TARGET = 0;
					STATUS = 0;
					INDEX_OUT_BTB = 2;
				end else if (LOOK_UP_ADDR == LOOK_UP_ADDR_ARRAY[5][2]) begin
					TARGET = TARGET_ADDR_ARRAY[5][2];
					STATUS = STATUS_ADDR_ARRAY[5][2];
					INDEX_OUT_BTB = 2;
				end else if (LOOK_UP_ADDR_ARRAY[5][3] == 32'b0) begin
					TARGET = 0;
					STATUS = 0;
					INDEX_OUT_BTB = 3;
				end else if (LOOK_UP_ADDR == LOOK_UP_ADDR_ARRAY[5][3]) begin
					TARGET = TARGET_ADDR_ARRAY[5][3];
					STATUS = STATUS_ADDR_ARRAY[5][3];
					INDEX_OUT_BTB = 3;
				end else begin
					TARGET = 0;
					STATUS = 0;
					INDEX_OUT_BTB = 0;
				end
			end
			3'b110:begin
				if (LOOK_UP_ADDR_ARRAY[6][0] == 32'b0) begin
					TARGET = 0;
					STATUS = 0;
					INDEX_OUT_BTB = 0;
				end
				else if (LOOK_UP_ADDR == LOOK_UP_ADDR_ARRAY[6][0]) begin
					TARGET = TARGET_ADDR_ARRAY[6][0];
					STATUS = STATUS_ADDR_ARRAY[6][0];
					INDEX_OUT_BTB = 0;
				end else if (LOOK_UP_ADDR_ARRAY[6][1] == 32'b0) begin
					TARGET = 0;
					STATUS = 0;
					INDEX_OUT_BTB = 1;
				end else if (LOOK_UP_ADDR == LOOK_UP_ADDR_ARRAY[6][1]) begin
					TARGET = TARGET_ADDR_ARRAY[6][1];
					STATUS = STATUS_ADDR_ARRAY[6][1];
					INDEX_OUT_BTB = 1;
				end else if (LOOK_UP_ADDR_ARRAY[6][2] == 32'b0) begin
					TARGET = 0;
					STATUS = 0;
					INDEX_OUT_BTB = 2;
				end else if (LOOK_UP_ADDR == LOOK_UP_ADDR_ARRAY[6][2]) begin
					TARGET = TARGET_ADDR_ARRAY[6][2];
					STATUS = STATUS_ADDR_ARRAY[6][2];
					INDEX_OUT_BTB = 2;
				end else if (LOOK_UP_ADDR_ARRAY[6][3] == 32'b0) begin
					TARGET = 0;
					STATUS = 0;
					INDEX_OUT_BTB = 3;
				end else if (LOOK_UP_ADDR == LOOK_UP_ADDR_ARRAY[6][3]) begin
					TARGET = TARGET_ADDR_ARRAY[6][3];
					STATUS = STATUS_ADDR_ARRAY[6][3];
					INDEX_OUT_BTB = 3;
				end else begin
					TARGET = 0;
					STATUS = 0;
					INDEX_OUT_BTB = 0;
				end
			end
			3'b111:begin 
				if (LOOK_UP_ADDR_ARRAY[7][0] == 32'b0) begin
					TARGET = 0;
					STATUS = 0;
					INDEX_OUT_BTB = 0;
				end
				else if (LOOK_UP_ADDR == LOOK_UP_ADDR_ARRAY[7][0]) begin
					TARGET = TARGET_ADDR_ARRAY[7][0];
					STATUS = STATUS_ADDR_ARRAY[7][0];
					INDEX_OUT_BTB = 0;
				end else if (LOOK_UP_ADDR_ARRAY[7][1] == 32'b0) begin
					TARGET = 0;
					STATUS = 0;
					INDEX_OUT_BTB = 1;
				end else if (LOOK_UP_ADDR == LOOK_UP_ADDR_ARRAY[7][1]) begin
					TARGET = TARGET_ADDR_ARRAY[7][1];
					STATUS = STATUS_ADDR_ARRAY[7][1];
					INDEX_OUT_BTB = 1;
				end else if (LOOK_UP_ADDR_ARRAY[7][2] == 32'b0) begin
					TARGET = 0;
					STATUS = 0;
					INDEX_OUT_BTB = 2;
				end else if (LOOK_UP_ADDR == LOOK_UP_ADDR_ARRAY[7][2]) begin
					TARGET = TARGET_ADDR_ARRAY[7][2];
					STATUS = STATUS_ADDR_ARRAY[7][2];
					INDEX_OUT_BTB = 2;
				end else if (LOOK_UP_ADDR_ARRAY[7][3] == 32'b0) begin
					TARGET = 0;
					STATUS = 0;
					INDEX_OUT_BTB = 3;
				end else if (LOOK_UP_ADDR == LOOK_UP_ADDR_ARRAY[7][3]) begin
					TARGET = TARGET_ADDR_ARRAY[7][3];
					STATUS = STATUS_ADDR_ARRAY[7][3];
					INDEX_OUT_BTB = 3;
				end else begin
					TARGET = 0;
					STATUS = 0;
					INDEX_OUT_BTB = 0;
				end
			end
		endcase
	end
	else begin
		TARGET = 0;
		STATUS = 0;
	end
	if(IS_J_TYPE_WRITE) begin
		case(W_ADDR[4:2])
			3'b000: STATUS_ADDR_ARRAY[0][INDEX_BTB] = NEW_STATUS;
			3'b001: STATUS_ADDR_ARRAY[1][INDEX_BTB] = NEW_STATUS;  
			3'b010: STATUS_ADDR_ARRAY[2][INDEX_BTB] = NEW_STATUS;
			3'b011: STATUS_ADDR_ARRAY[3][INDEX_BTB] = NEW_STATUS;
			3'b100: STATUS_ADDR_ARRAY[4][INDEX_BTB] = NEW_STATUS;
			3'b101: STATUS_ADDR_ARRAY[5][INDEX_BTB] = NEW_STATUS;
			3'b110: STATUS_ADDR_ARRAY[6][INDEX_BTB] = NEW_STATUS;
			3'b111: STATUS_ADDR_ARRAY[7][INDEX_BTB] = NEW_STATUS;
		endcase
		if(EN_WRITE) begin
			case(W_ADDR[4:2])
				3'b000:begin
					LOOK_UP_ADDR_ARRAY[0][INDEX_BTB] = W_ADDR;
					TARGET_ADDR_ARRAY[0][INDEX_BTB] = TARGET_ADDR;
				end
				3'b001:begin
					LOOK_UP_ADDR_ARRAY[1][INDEX_BTB] = W_ADDR;
					TARGET_ADDR_ARRAY[1][INDEX_BTB] = TARGET_ADDR;
				end
				3'b010:begin
					LOOK_UP_ADDR_ARRAY[2][INDEX_BTB] = W_ADDR;
					TARGET_ADDR_ARRAY[2][INDEX_BTB] = TARGET_ADDR;
				end
				3'b011:begin  //unblocking to blocking here
					LOOK_UP_ADDR_ARRAY[3][INDEX_BTB] = W_ADDR;
					TARGET_ADDR_ARRAY[3][INDEX_BTB] = TARGET_ADDR;
				end
				3'b100:begin
					LOOK_UP_ADDR_ARRAY[4][INDEX_BTB] = W_ADDR;
					TARGET_ADDR_ARRAY[4][INDEX_BTB] = TARGET_ADDR;
				end
				3'b101:begin
					LOOK_UP_ADDR_ARRAY[5][INDEX_BTB] = W_ADDR;
					TARGET_ADDR_ARRAY[5][INDEX_BTB] = TARGET_ADDR;
				end
				3'b110:begin
					LOOK_UP_ADDR_ARRAY[6][INDEX_BTB] = W_ADDR;
					TARGET_ADDR_ARRAY[6][INDEX_BTB] = TARGET_ADDR;
				end
				3'b111:begin
					LOOK_UP_ADDR_ARRAY[7][INDEX_BTB] = W_ADDR;
					TARGET_ADDR_ARRAY[7][INDEX_BTB] = TARGET_ADDR;
				end
			endcase
		end
	end
end
endmodule

		

