 module ALU_CONTROLER
(
	input logic [2:0] ALUOP,  //000  R-type, 001 I-type, 010 S-type, 011 SB-type, 100 UJ-type, 101 U-type  110 JALR
	input logic [2:0] FUNCT3,
	input logic [6:0] FUNCT7,
	
	output logic [3:0] CMP_TYPE,
	output logic [1:0] OPT,  //SEL_A(A or CA or 0), SEL_B(B or CB or NB),  00 A, 01 CA, 10 NA, 11 0
	output logic IS_FORWARDING_RS1,
	output logic IS_FORWARDING_RS2,
	output logic IS_FORWARDING_RD,
	output logic IS_SIGNED
);

always_comb begin 
	case(ALUOP)
		3'b000:begin   //R-type
			case(FUNCT3)
				3'b000:
					case(FUNCT7)
						7'b0000000:begin
							OPT <= 2'b00;
							CMP_TYPE <= 4'b0000;
							IS_FORWARDING_RS1 <= 1'b1;
							IS_FORWARDING_RS2 <= 1'b1;
							IS_FORWARDING_RD <= 1'b1;
							IS_SIGNED <= 1'b0;
						end
						7'b0100000:begin
							OPT <= 2'b01;
							CMP_TYPE <= 4'b0000;
							IS_FORWARDING_RS1 <= 1'b1;
							IS_FORWARDING_RS2 <= 1'b1;
							IS_FORWARDING_RD <= 1'b1;
							IS_SIGNED <= 1'b0;
						end
						default: begin
							OPT <= 2'b00;
							CMP_TYPE <= 4'b0000;
							IS_FORWARDING_RS1 <= 1'b0;
							IS_FORWARDING_RS2 <= 1'b0;
							IS_FORWARDING_RD <= 1'b0;
							IS_SIGNED <= 1'b0;
						end
					endcase
				default: begin
					OPT <= 2'b00;
					CMP_TYPE <= 4'b0000;
					IS_FORWARDING_RS1 <= 1'b0;
					IS_FORWARDING_RS2 <= 1'b0;
					IS_FORWARDING_RD <= 1'b0;
					IS_SIGNED <= 1'b0;
				end
			endcase
		end
		3'b001: begin		//I-type
			case(FUNCT3)
				3'b000:begin
					OPT <= 2'b00;
					CMP_TYPE <= 4'b0000;
					IS_FORWARDING_RS1 <= 1'b1;
					IS_FORWARDING_RS2 <= 1'b0;
					IS_FORWARDING_RD <= 1'b1;
					IS_SIGNED <= 1'b0;
				end
				3'b010:begin
					OPT <= 2'b00;
					CMP_TYPE <= 4'b0000;
					IS_FORWARDING_RS1 <= 1'b1;
					IS_FORWARDING_RS2 <= 1'b0;
					IS_FORWARDING_RD <= 1'b1;
					IS_SIGNED <= 1'b0;
				end
				default: begin
					OPT <= 2'b00;
					CMP_TYPE <= 4'b0000;
					IS_FORWARDING_RS1 <= 1'b0;
					IS_FORWARDING_RS2 <= 1'b0;
					IS_FORWARDING_RD <= 1'b0;
					IS_SIGNED <= 1'b0;
				end
			endcase
		end
		3'b010: begin   //S-type
			case(FUNCT3)
				3'b010:begin
					OPT <= 2'b00;
					CMP_TYPE <= 4'b0000;
					IS_FORWARDING_RS1 <= 1'b1;
					IS_FORWARDING_RS2 <= 1'b1;
					IS_FORWARDING_RD <= 1'b0;
					IS_SIGNED <= 1'b0;
				end
				default: begin
					OPT <= 2'b00;
					CMP_TYPE <= 4'b0000;
					IS_FORWARDING_RS1 <= 1'b0;
					IS_FORWARDING_RS2 <= 1'b0;
					IS_FORWARDING_RD <= 1'b0;
					IS_SIGNED <= 1'b0;
				end
			endcase
		end
		3'b011: begin  //SB-type
			case(FUNCT3)
				3'b101:begin   		//bge
					OPT <= 2'b01;
					CMP_TYPE <= 4'b0001;
					IS_FORWARDING_RS1 <= 1'b1;
					IS_FORWARDING_RS2 <= 1'b1;
					IS_FORWARDING_RD <= 1'b0;
					IS_SIGNED <= 1'b1;
				end
				3'b110:begin        //bltu
					OPT <= 2'b10;
					CMP_TYPE <= 4'b0010;
					IS_FORWARDING_RS1 <= 1'b1;
					IS_FORWARDING_RS2 <= 1'b1;
					IS_FORWARDING_RD <= 1'b0;
					IS_SIGNED <= 1'b0;
				end
				default: begin
					OPT <= 2'b00;
					CMP_TYPE <= 4'b0000;
					IS_FORWARDING_RS1 <= 1'b0;
					IS_FORWARDING_RS2 <= 1'b0;
					IS_FORWARDING_RD <= 1'b0;
					IS_SIGNED <= 1'b0;
				end
			endcase
		end
		3'b100:begin  //UJ-type
			OPT <= 2'b00;
			CMP_TYPE <= 4'b1111;
			IS_FORWARDING_RS1 <= 1'b0;
			IS_FORWARDING_RS2 <= 1'b0;
			IS_FORWARDING_RD <= 1'b1;
			IS_SIGNED <= 1'b0;
		end
		3'b101:begin  //U-type
			OPT <= 2'b00;
			CMP_TYPE <= 4'b0000;
			IS_FORWARDING_RS1 <= 1'b0;
			IS_FORWARDING_RS2 <= 1'b0;
			IS_FORWARDING_RD <= 1'b1;
			IS_SIGNED <= 1'b0;
		end
		3'b110:begin  //JALR
			OPT <= 2'b00;
			CMP_TYPE <= 4'b1111;
			IS_FORWARDING_RS1 <= 1'b1;
			IS_FORWARDING_RS2 <= 1'b0;
			IS_FORWARDING_RD <= 1'b1;
			IS_SIGNED <= 1'b0;
		end
		default: begin
			OPT <= 2'b00;
			CMP_TYPE <= 4'b0000;
			IS_FORWARDING_RS1 <= 1'b0;
			IS_FORWARDING_RS2 <= 1'b0;
			IS_FORWARDING_RD <= 1'b0;
			IS_SIGNED <= 1'b0;
		end
	endcase
end
endmodule
