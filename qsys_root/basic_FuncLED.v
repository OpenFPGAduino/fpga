module basic_FuncLED(
//Avalon System control signal.
input					rsi_MRST_reset,	// reset_n from MCU GPIO
input					csi_MCLK_clk,

//Avalon-MM LED Control.
input		[31:0]	avs_ctrl_writedata,
output	[31:0]	avs_ctrl_readdata,
input		[3:0]		avs_ctrl_byteenable,
input					avs_ctrl_write,
input					avs_ctrl_read,
output				avs_ctrl_waitrequest,

//Avalon-ST LED Control.
input		[23:0]	asi_ledf_data,
input					asi_ledf_valid,

//LED pin-out.
output				coe_LED_R,
output				coe_LED_G,
output				coe_LED_B
);

assign	avs_ctrl_readdata = {led_asi_en, 7'b0, led_r_data, led_g_data, led_b_data};
assign	avs_ctrl_waitrequest = 1'b0;

reg		[7:0]		led_r_data, led_g_data, led_b_data;
reg		[7:0]		led_r_cnt, led_g_cnt, led_b_cnt;
reg					led_r, led_g, led_b;
reg					led_asi_en;

assign	coe_LED_R = led_r;
assign	coe_LED_G = led_g;
assign	coe_LED_B = led_b;

always@(posedge csi_MCLK_clk or posedge rsi_MRST_reset)
begin
	if(rsi_MRST_reset) begin
		led_r_data <= 0;
		led_g_data <= 0;
		led_b_data <= 0;
		led_asi_en <= 0;
	end
	else begin
		if(avs_ctrl_write) begin
			if(avs_ctrl_byteenable[3]) led_asi_en <= avs_ctrl_writedata[31];
		end
		if(led_asi_en) begin
			if(asi_ledf_valid) begin
				led_r_data <= asi_ledf_data[23:16];
				led_g_data <= asi_ledf_data[15:8];
				led_b_data <= asi_ledf_data[7:0];
			end
		end
		else if(avs_ctrl_write) begin
			if(avs_ctrl_byteenable[2]) led_r_data <= avs_ctrl_writedata[23:16];
			if(avs_ctrl_byteenable[1]) led_g_data <= avs_ctrl_writedata[15:8];
			if(avs_ctrl_byteenable[0]) led_b_data <= avs_ctrl_writedata[7:0];
		end
	end
end

always@(posedge csi_MCLK_clk or posedge rsi_MRST_reset)
begin
	if(rsi_MRST_reset) begin
		led_r_cnt <= 0;
		led_g_cnt <= 0;
		led_b_cnt <= 0;
		led_r <= 1'b1;
		led_g <= 1'b1;
		led_b <= 1'b1;
	end
	else begin
		led_r_cnt <= led_r_cnt + 1;
		led_g_cnt <= led_g_cnt + 1;
		led_b_cnt <= led_b_cnt + 1;
		if(led_r_cnt < led_r_data) led_r <= 1'b0; else led_r <= 1'b1;
		if(led_g_cnt < led_g_data) led_g <= 1'b0; else led_g <= 1'b1;
		if(led_b_cnt < led_b_data) led_b <= 1'b0; else led_b <= 1'b1;
	end
end

endmodule
