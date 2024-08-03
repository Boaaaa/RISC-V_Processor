module RegisterFile #(
	parameter BITS = 32)
(
	input logic clk,
	input logic rstn,
	input logic read1,
	input logic read2,
	input logic write,
	input logic [5-1:0] readaddr1,
	input logic [5-1:0] readaddr2,
	input logic [5-1:0] writeaddr,
	input logic [BITS-1:0] basic_sp,
	input logic [BITS-1:0] basic_gp,
	input logic [BITS-1:0] writedata,
	output logic [BITS-1:0] dataout1,
	output logic [BITS-1:0] dataout2
);

logic [31:0] RF [31:0];
logic [31:0] s_dataout1;
logic [31:0] s_dataout2;

always@(posedge clk) begin 
if(rstn) begin
	RF[0] = 0;
	RF[1] = 0;
	RF[2] = basic_sp;
	RF[3] = basic_gp;
	RF[4] = 0;
	RF[5] = 0;
	RF[6] = 0;
	RF[7] = 0;
	RF[8] = 0;
	RF[9] = 0;
	RF[10] = 0;
	RF[11] = 0;
	RF[12] = 0;
	RF[13] = 0;
	RF[14] = 0;
	RF[15] = 0;
	RF[16] = 0;
	RF[17] = 0;
	RF[18] = 0;
	RF[19] = 0;
	RF[20] = 0;
	RF[21] = 0;
	RF[22] = 0;
	RF[23] = 0;
	RF[24] = 0;
	RF[25] = 0;
	RF[26] = 0;
	RF[27] = 0;
	RF[28] = 0;
	RF[29] = 0;
	RF[30] = 0;
	RF[31] = 0;
end	
else if(write && writeaddr != 0) begin
	RF[writeaddr] = writedata;  //now it change from unblocking to blocking
	//when the read and write enable signal is actived at the same clock cycle, we need to do forwarding operations
		
	if(read1) begin  
		if(writeaddr == readaddr1) begin
			s_dataout1 <= writedata;  //if the write address and read1 address is the same, we can forwarding the writeback data to the output1 of register file 
		end
		else begin
			s_dataout1 <= RF[readaddr1];
		end
	end 
	else begin
			s_dataout1 <= dataout1;
	end
	if(read2) begin
		if(writeaddr == readaddr2) begin
			s_dataout2 <= writedata;  //if the write address and read2 address is the same, we can forwarding the writeback data to the output2 of register file
		end
		else begin
			s_dataout2 <= RF[readaddr2];
		end
	end 
	else begin
			s_dataout2 <= dataout2;
	end
end
else begin
	if(read1) begin
		s_dataout1 <= RF[readaddr1];
	end else begin
		s_dataout1 <= dataout1;
	end
	if(read2) begin
		s_dataout2 <= RF[readaddr2];
	end else begin
		s_dataout2 <= dataout2;
	end
end
end

assign dataout1 = s_dataout1;
assign dataout2 = s_dataout2;

endmodule

		

