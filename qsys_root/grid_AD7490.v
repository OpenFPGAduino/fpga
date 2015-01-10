module grid_AD7490(
// Qsys interface
input					rsi_MRST_reset,
input					csi_MCLK_clk,

input		[31:0]	avs_ctrl_writedata,
output	[31:0]	avs_ctrl_readdata,
input		[3:0]		avs_ctrl_address,
input		[3:0]		avs_ctrl_byteenable,
input					avs_ctrl_write,
input					avs_ctrl_read,
output				avs_ctrl_waitrequest,

input					csi_ADCCLK_clk,

// debug interface
//output	[3:0]		aso_adc_channel,
//output	[15:0]	aso_adc_data,
//output				aso_adc_valid,
//input				aso_adc_ready,

//ADC interface
output				coe_DIN,
input					coe_DOUT,
output				coe_SCLK,
output				coe_CSN
);

assign	avs_ctrl_readdata = read_data;
assign	avs_ctrl_waitrequest = 1'b0;

//assign	aso_adc_channel = adc_aso_ch;
//assign	aso_adc_data = {adc_aso_data, 4'b0};
//assign	aso_adc_valid = adc_aso_valid;

assign	coe_DIN = spi_din;
assign	spi_dout = coe_DOUT;
assign	coe_SCLK = spi_clk;
assign	coe_CSN = spi_cs;

reg		[31:0]	read_data = 0;

reg					spi_din = 0, spi_cs = 1, spi_clk = 1;
wire					spi_dout;

reg		[7:0]		state = 0;
reg		[7:0]		delay = 0;

reg					adc_range = 0;
reg					adc_coding = 1;
reg					adc_reset = 1;
reg		[7:0]		cnv_delay = 255;

reg		[11:0]	adc_ch[0:15];

reg		[3:0]		adc_addr = 0;
reg		[3:0]		adc_aso_ch = 0;
reg		[11:0]	adc_aso_data = 0;
reg					adc_aso_valid = 0;

/*
 * GRID_MOD_SIZE		0x0
 * GRID_MOD_ID			0x4
 * ADC_CTRL				0x8
 * CNV_DELAY			0xC 
 * ADC_CH0				0x20
 * ADC_CH1				0x22
 * ADC_CH2				0x24
 * ADC_CH3				0x26
 * ADC_CH4				0x28
 * ADC_CH5				0x2A
 * ADC_CH6				0x2C
 * ADC_CH7				0x2E
 * ADC_CH8				0x30
 * ADC_CH9				0x32
 * ADC_CH10				0x34
 * ADC_CH11				0x36
 * ADC_CH12				0x38
 * ADC_CH13				0x3A
 * ADC_CH14				0x3C
 * ADC_CH15				0x3E
 */

always@(posedge csi_MCLK_clk or posedge rsi_MRST_reset)
begin
	if(rsi_MRST_reset) begin
		read_data <= 0;
	end
	else begin
		case(avs_ctrl_address)
			0: read_data <= 64;
			1: read_data <= 32'hEA680003;
			2: read_data <= {4'b0, adc_addr, 7'b0, adc_range, 7'b0, adc_coding, 7'b0, adc_reset};
			3: read_data <= {24'b0, cnv_delay};
			8: read_data <= {adc_ch[1], 4'b0, adc_ch[0], 4'b0};
			9: read_data <= {adc_ch[3], 4'b0, adc_ch[2], 4'b0};
			10: read_data <= {adc_ch[5], 4'b0, adc_ch[4], 4'b0};
			11: read_data <= {adc_ch[7], 4'b0, adc_ch[6], 4'b0};
			12: read_data <= {adc_ch[9], 4'b0, adc_ch[8], 4'b0};
			13: read_data <= {adc_ch[11], 4'b0, adc_ch[10], 4'b0};
			14: read_data <= {adc_ch[13], 4'b0, adc_ch[12], 4'b0};
			15: read_data <= {adc_ch[15], 4'b0, adc_ch[14], 4'b0};
			default: read_data <= 0;
		endcase
	end
end

always@(posedge csi_MCLK_clk or posedge rsi_MRST_reset)
begin
	if(rsi_MRST_reset) begin
		adc_range <= 0;
		adc_coding <= 1;
		adc_reset <= 1;
		cnv_delay <= 255;
	end
	else begin
		if(avs_ctrl_write) begin
			case(avs_ctrl_address)
				2: begin 
					if(avs_ctrl_byteenable[2]) adc_range <= avs_ctrl_writedata[16];
					if(avs_ctrl_byteenable[1]) adc_coding <= avs_ctrl_writedata[8];
					if(avs_ctrl_byteenable[0]) adc_reset <= avs_ctrl_writedata[0];
				end
				3: begin 
					if(avs_ctrl_byteenable[0]) cnv_delay <= avs_ctrl_writedata[7:0];
				end
				default: begin end
			endcase
		end
	end
end

wire	rWRITE = 1;
wire	rSEQ = 0;
wire	rPM1 = 1;
wire	rPM0 = 1;
wire	rSHADOW = 0;
wire	rWEAKTRI = 0;

always@(posedge csi_ADCCLK_clk or posedge adc_reset)
begin
	if(adc_reset) begin
		adc_ch[0] <= 0;
		adc_ch[1] <= 0;
		adc_ch[2] <= 0;
		adc_ch[3] <= 0;
		adc_ch[4] <= 0;
		adc_ch[5] <= 0;
		adc_ch[6] <= 0;
		adc_ch[7] <= 0;
		adc_ch[8] <= 0;
		adc_ch[9] <= 0;
		adc_ch[10] <= 0;
		adc_ch[11] <= 0;
		adc_ch[12] <= 0;
		adc_ch[13] <= 0;
		adc_ch[14] <= 0;
		adc_ch[15] <= 0;
		adc_addr <= 0;
		adc_aso_ch <= 0;
		adc_aso_data <= 0;
		adc_aso_valid <= 0;
		spi_din <= 0;
		spi_cs <= 1;
		spi_clk <= 1;
		state <= 0;
		delay <= 0;
	end
	else begin
		case(state)
			0:  begin state <= state + 1; spi_clk <= 1; spi_din <= rWRITE; spi_cs <= 1; delay <= 0; end
			1:  begin if(delay > cnv_delay) begin delay <= 0; state <= state + 1; end else delay <= delay + 1; end
			2:  begin state <= state + 1; spi_clk <= 1; spi_din <= rWRITE; spi_cs <= 0; end
			3:  begin state <= state + 1; spi_clk <= 0; adc_aso_ch[3] <= spi_dout; end
			4:  begin state <= state + 1; spi_clk <= 1; spi_din <= rSEQ; end
			5:  begin state <= state + 1; spi_clk <= 0; adc_aso_ch[2] <= spi_dout; end
			6:  begin state <= state + 1; spi_clk <= 1; spi_din <= adc_addr[3]; end
			7:  begin state <= state + 1; spi_clk <= 0; adc_aso_ch[1] <= spi_dout; end
			8:  begin state <= state + 1; spi_clk <= 1; spi_din <= adc_addr[2]; end
			9:  begin state <= state + 1; spi_clk <= 0; adc_aso_ch[0] <= spi_dout; end
			10: begin state <= state + 1; spi_clk <= 1; spi_din <= adc_addr[1]; end
			11: begin state <= state + 1; spi_clk <= 0; adc_aso_data[11] <= spi_dout; end
			12: begin state <= state + 1; spi_clk <= 1; spi_din <= adc_addr[0]; end
			13: begin state <= state + 1; spi_clk <= 0; adc_aso_data[10] <= spi_dout; end
			14: begin state <= state + 1; spi_clk <= 1; spi_din <= rPM1; end
			15: begin state <= state + 1; spi_clk <= 0; adc_aso_data[9] <= spi_dout; end
			16: begin state <= state + 1; spi_clk <= 1; spi_din <= rPM0; end
			17: begin state <= state + 1; spi_clk <= 0; adc_aso_data[8] <= spi_dout; end
			18: begin state <= state + 1; spi_clk <= 1; spi_din <= rSHADOW; end
			19: begin state <= state + 1; spi_clk <= 0; adc_aso_data[7] <= spi_dout; end
			20: begin state <= state + 1; spi_clk <= 1; spi_din <= rWEAKTRI; end
			21: begin state <= state + 1; spi_clk <= 0; adc_aso_data[6] <= spi_dout; end
			22: begin state <= state + 1; spi_clk <= 1; spi_din <= adc_range; end
			23: begin state <= state + 1; spi_clk <= 0; adc_aso_data[5] <= spi_dout; end
			24: begin state <= state + 1; spi_clk <= 1; spi_din <= adc_coding; end
			25: begin state <= state + 1; spi_clk <= 0; adc_aso_data[4] <= spi_dout; end
			26: begin state <= state + 1; spi_clk <= 1; spi_din <= 0; end
			27: begin state <= state + 1; spi_clk <= 0; adc_aso_data[3] <= spi_dout; end
			28: begin state <= state + 1; spi_clk <= 1; end
			29: begin state <= state + 1; spi_clk <= 0; adc_aso_data[2] <= spi_dout; end
			30: begin state <= state + 1; spi_clk <= 1; end
			31: begin state <= state + 1; spi_clk <= 0; adc_aso_data[1] <= spi_dout; end
			32: begin state <= state + 1; spi_clk <= 1; end
			33: begin state <= state + 1; spi_clk <= 0; adc_aso_data[0] <= spi_dout; end
			34: begin state <= state + 1; spi_clk <= 1; adc_ch[adc_aso_ch] <= adc_aso_data; adc_aso_valid <= 1; end
			35: begin state <= 0; spi_cs <= 1; adc_aso_valid <= 0; adc_addr <= adc_addr + 1; end
			default: begin
				adc_ch[0] <= 0;
				adc_ch[1] <= 0;
				adc_ch[2] <= 0;
				adc_ch[3] <= 0;
				adc_ch[4] <= 0;
				adc_ch[5] <= 0;
				adc_ch[6] <= 0;
				adc_ch[7] <= 0;
				adc_ch[8] <= 0;
				adc_ch[9] <= 0;
				adc_ch[10] <= 0;
				adc_ch[11] <= 0;
				adc_ch[12] <= 0;
				adc_ch[13] <= 0;
				adc_ch[14] <= 0;
				adc_ch[15] <= 0;
				adc_addr <= 0;
				adc_aso_ch <= 0;
				adc_aso_data <= 0;
				adc_aso_valid <= 0;
				spi_din <= 0;
				spi_cs <= 1;
				spi_clk <= 1;
				state <= 0;
				delay <= 0;
			end
		endcase
	end
end

endmodule
