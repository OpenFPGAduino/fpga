module test_RegWaitRW32(
//Avalon System control signal.
input					rsi_MRST_reset,	// reset_n from MCU GPIO
input					csi_MCLK_clk,

//Avalon-MM Control.
input		[31:0]	avs_test_writedata,
output	[31:0]	avs_test_readdata,
input		[5:0]		avs_test_address,
input		[3:0]		avs_test_byteenable,
input					avs_test_write,
input					avs_test_read,
output				avs_test_readdatavalid,
output				avs_test_waitrequest
);

reg		[31:0]	out_data = 0;
reg		[31:0]	r_data = 0;
reg					r_wait = 0;
reg		[3:0]		r_wait_cnt = 0;
reg					r_valid = 0;

assign	avs_test_readdata = out_data;
assign	avs_test_waitrequest = r_wait;
assign	avs_test_readdatavalid = r_valid;

always@(posedge csi_MCLK_clk or posedge rsi_MRST_reset)
begin
	if(rsi_MRST_reset) begin
		out_data <= 0;
		r_data <= 0;
		r_wait <= 0;
		r_wait_cnt <= 0;
		r_valid <= 0;
	end
	else begin
		if(r_wait_cnt == 15) r_valid <= 1; else r_valid <= 0;
		if(((r_wait_cnt > 0)&&(r_wait_cnt < 15))||(avs_test_read)||(avs_test_write)) r_wait <= 1; else r_wait <= 0;
		if(avs_test_read) begin
			r_wait_cnt <= r_wait_cnt + 1;
			out_data <= r_data + avs_test_address;
		end
		else if(avs_test_write) begin
			r_wait_cnt <= r_wait_cnt + 1;
			case(avs_test_address)
				0: begin
					if(avs_test_byteenable[3]) r_data[31:24] <= avs_test_writedata[31:24];
					if(avs_test_byteenable[2]) r_data[23:16] <= avs_test_writedata[23:16];
					if(avs_test_byteenable[1]) r_data[15:8] <= avs_test_writedata[15:8];
					if(avs_test_byteenable[0]) r_data[7:0] <= avs_test_writedata[7:0];
				end
				1: begin
					if(avs_test_byteenable[3]) r_data[31:24] <= ~avs_test_writedata[31:24];
					if(avs_test_byteenable[2]) r_data[23:16] <= ~avs_test_writedata[23:16];
					if(avs_test_byteenable[1]) r_data[15:8] <= ~avs_test_writedata[15:8];
					if(avs_test_byteenable[0]) r_data[7:0] <= ~avs_test_writedata[7:0];				
				end
				default: begin
					r_data <= 0;				
				end
			endcase
		end
		else begin
			if(r_wait_cnt > 0) r_wait_cnt <= r_wait_cnt + 1; else r_wait_cnt <= 0;
		end
	end
end

endmodule
