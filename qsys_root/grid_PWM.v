module grid_PWM(
input					rsi_MRST_reset,
input					csi_MCLK_clk,

input		[31:0]	avs_pwm_writedata,
output	[31:0]	avs_pwm_readdata,
input		[2:0]		avs_pwm_address,
input		[3:0]		avs_pwm_byteenable,
input					avs_pwm_write,
input					avs_pwm_read,
output				avs_pwm_waitrequest,

input					rsi_PWMRST_reset,
input					csi_PWMCLK_clk,

input		[31:0]	asi_fm_data,
input					asi_fm_valid,
output				asi_fm_ready,

input		[31:0]	asi_pm_data,
input					asi_pm_valid,
output				asi_pm_ready,

output				coe_PWMOUT
);

assign	avs_pwm_readdata = read_data;
assign	avs_pwm_waitrequest = 1'b0;
assign	asi_fm_ready = fm_ready;
assign	asi_pm_ready = pm_ready;
assign	coe_PWMOUT = (out_inv) ? ~pwm_out : pwm_out;

reg		[31:0]	read_data = 0;

reg					out_inv = 0;
reg					asi_gate_en = 0;
reg					asi_dtyc_en = 0;
reg					r_reset = 1;
reg		[31:0]	r_gate = 0;
reg		[31:0]	r_dtyc = 0;

/*
 * GRID_MOD_SIZE		0x0
 * GRID_MOD_ID			0x4
 * PWM_CTRL				0x8
 * PWM_PRD				0xC
 * PWM_DTYC				0x10
 */

always@(posedge csi_MCLK_clk or posedge rsi_MRST_reset)
begin
	if(rsi_MRST_reset) begin
		read_data <= 0;
	end
	else begin
		case(avs_pwm_address)
			0: read_data <= 32;
			1: read_data <= 32'hEA680002;
			2: read_data <= {7'b0, asi_gate_en, 7'b0, asi_dtyc_en, 7'b0, out_inv, 7'b0, r_reset};
			3: read_data <= r_gate;
			4: read_data <= r_dtyc;
			default: read_data <= 0;
		endcase
	end
end

always@(posedge csi_MCLK_clk or posedge rsi_MRST_reset)
begin
	if(rsi_MRST_reset) begin
		out_inv <= 0;
		asi_gate_en <= 0;
		asi_dtyc_en <= 0;
		r_reset <= 1;
		r_gate <= 0;
		r_dtyc <= 0;
	end
	else begin
		if(avs_pwm_write) begin
			case(avs_pwm_address)
				2: begin 
					if(avs_pwm_byteenable[3]) asi_gate_en <= avs_pwm_writedata[24];
					if(avs_pwm_byteenable[2]) asi_dtyc_en <= avs_pwm_writedata[16];
					if(avs_pwm_byteenable[1]) out_inv <= avs_pwm_writedata[8];
					if(avs_pwm_byteenable[0]) r_reset <= avs_pwm_writedata[0];
				end
				
				3: begin
					if(avs_pwm_byteenable[3]) r_gate[31:24] <= avs_pwm_writedata[31:24];
					if(avs_pwm_byteenable[2]) r_gate[23:16] <= avs_pwm_writedata[23:16];
					if(avs_pwm_byteenable[1]) r_gate[15:8] <= avs_pwm_writedata[15:8];
					if(avs_pwm_byteenable[0]) r_gate[7:0] <= avs_pwm_writedata[7:0];
				end
				
				4: begin
					if(avs_pwm_byteenable[3]) r_dtyc[31:24] <= avs_pwm_writedata[31:24];
					if(avs_pwm_byteenable[2]) r_dtyc[23:16] <= avs_pwm_writedata[23:16];
					if(avs_pwm_byteenable[1]) r_dtyc[15:8] <= avs_pwm_writedata[15:8];
					if(avs_pwm_byteenable[0]) r_dtyc[7:0] <= avs_pwm_writedata[7:0];
				end
	
				default: begin end
			endcase
		end
	end
end

wire					pwm_reset, pwm_gate_reset, pwm_dtyc_reset;

reg		[31:0]	pwm_gate = 0;
reg		[31:0]	pwm_dtyc = 0;
reg		[31:0]	pwm_cnt = 0;
reg					pwm_out = 0;

reg					fm_ready = 0;
reg					pm_ready = 0;

assign	pwm_reset = rsi_PWMRST_reset | r_reset;
assign	pwm_gate_reset = (asi_gate_en) ? rsi_PWMRST_reset : r_reset;
assign	pwm_dtyc_reset = (asi_dtyc_en) ? rsi_PWMRST_reset : r_reset;

always@(posedge csi_PWMCLK_clk or posedge pwm_reset)
begin
	if(pwm_reset) begin
		pwm_cnt <= 0;
		pwm_out <= 0;
	end
	else begin
		if(pwm_cnt != pwm_gate) pwm_cnt <= pwm_cnt + 1; else pwm_cnt <= 0;
		if(pwm_cnt < pwm_dtyc) pwm_out <= 0; else pwm_out <= 1;
	end
end

always@(posedge csi_PWMCLK_clk or posedge pwm_gate_reset)
begin
	if(pwm_gate_reset) begin
		pwm_gate <= 0;
		fm_ready <= 0;
	end
	else begin
		if(asi_gate_en) begin
			fm_ready <= 1;
			if(asi_fm_valid) pwm_gate <= asi_fm_data;
		end
		else begin
			fm_ready <= 0;
			pwm_gate <= r_gate;
		end
	end
end

always@(posedge csi_PWMCLK_clk or posedge pwm_dtyc_reset)
begin
	if(pwm_dtyc_reset) begin
		pwm_dtyc <= 0;
		pm_ready <= 0;
	end
	else begin
		if(asi_dtyc_en) begin
			pm_ready <= 1;
			if(asi_pm_valid) pwm_dtyc <= asi_pm_data;
		end
		else begin
			pm_ready <= 0;
			pwm_dtyc <= r_dtyc;
		end
	end
end

endmodule
