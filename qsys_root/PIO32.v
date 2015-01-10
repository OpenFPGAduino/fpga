module PIO32(
input					rsi_MRST_reset,
input					csi_MCLK_clk,

input		[31:0]	avs_gpio_writedata,
output	[31:0]	avs_gpio_readdata,
input		[2:0]		avs_gpio_address,
input		[3:0]		avs_gpio_byteenable,
input					avs_gpio_write,
input					avs_gpio_read,
output				avs_gpio_waitrequest,

inout					coe_P0,
inout					coe_P1,
inout					coe_P2,
inout					coe_P3,
inout					coe_P4,
inout					coe_P5,
inout					coe_P6,
inout					coe_P7,
inout					coe_P8,
inout					coe_P9,
inout					coe_P10,
inout					coe_P11,
inout					coe_P12,
inout					coe_P13,
inout					coe_P14,
inout					coe_P15,
inout					coe_P16,
inout					coe_P17,
inout					coe_P18,
inout					coe_P19,
inout					coe_P20,
inout					coe_P21,
inout					coe_P22,
inout					coe_P23,
inout					coe_P24,
inout					coe_P25,
inout					coe_P26,
inout					coe_P27,
inout					coe_P28,
inout					coe_P29,
inout					coe_P30,
inout					coe_P31
);

reg		[31:0]	 io_data;
reg		[31:0]	 io_out_en;
reg		[31:0]   read_data;

assign	avs_gpio_readdata = read_data;
assign	avs_gpio_waitrequest = 1'b0;

assign	coe_P0 = (io_out_en[0]) ? io_data[0] : 1'bz;
assign	coe_P1 = (io_out_en[1]) ? io_data[1] : 1'bz;
assign	coe_P2 = (io_out_en[2]) ? io_data[2] : 1'bz;
assign	coe_P3 = (io_out_en[3]) ? io_data[3] : 1'bz;
assign	coe_P4 = (io_out_en[4]) ? io_data[4] : 1'bz;
assign	coe_P5 = (io_out_en[5]) ? io_data[5] : 1'bz;
assign	coe_P6 = (io_out_en[6]) ? io_data[6] : 1'bz;
assign	coe_P7 = (io_out_en[7]) ? io_data[7] : 1'bz;
assign	coe_P8 = (io_out_en[8]) ? io_data[8] : 1'bz;
assign	coe_P9 = (io_out_en[9]) ? io_data[9] : 1'bz;
assign	coe_P10 = (io_out_en[10]) ? io_data[10] : 1'bz;
assign	coe_P11 = (io_out_en[11]) ? io_data[11] : 1'bz;
assign	coe_P12 = (io_out_en[12]) ? io_data[12] : 1'bz;
assign	coe_P13 = (io_out_en[13]) ? io_data[13] : 1'bz;
assign	coe_P14 = (io_out_en[14]) ? io_data[14] : 1'bz;
assign	coe_P15 = (io_out_en[15]) ? io_data[15] : 1'bz;
assign	coe_P16 = (io_out_en[16]) ? io_data[16] : 1'bz;
assign	coe_P17 = (io_out_en[17]) ? io_data[17] : 1'bz;
assign	coe_P18 = (io_out_en[18]) ? io_data[18] : 1'bz;
assign	coe_P19 = (io_out_en[19]) ? io_data[19] : 1'bz;
assign	coe_P20 = (io_out_en[20]) ? io_data[20] : 1'bz;
assign	coe_P21 = (io_out_en[21]) ? io_data[21] : 1'bz;
assign	coe_P22 = (io_out_en[22]) ? io_data[22] : 1'bz;
assign	coe_P23 = (io_out_en[23]) ? io_data[23] : 1'bz;
assign	coe_P24 = (io_out_en[24]) ? io_data[24] : 1'bz;
assign	coe_P25 = (io_out_en[25]) ? io_data[25] : 1'bz;
assign	coe_P26 = (io_out_en[26]) ? io_data[26] : 1'bz;
assign	coe_P27 = (io_out_en[27]) ? io_data[27] : 1'bz;
assign	coe_P28 = (io_out_en[28]) ? io_data[28] : 1'bz;
assign	coe_P29 = (io_out_en[29]) ? io_data[29] : 1'bz;
assign	coe_P30 = (io_out_en[30]) ? io_data[30] : 1'bz;
assign	coe_P31 = (io_out_en[31]) ? io_data[31] : 1'bz;

always@(posedge csi_MCLK_clk or posedge rsi_MRST_reset)
begin
	if(rsi_MRST_reset) begin
		read_data <= 0;
	end
	else begin
		case(avs_gpio_address)
//			0: read_data <= 8;
//			1: read_data <= 32'hEA680001;
			2: read_data <= {coe_P31, coe_P30, coe_P29, coe_P28, coe_P27, coe_P26, coe_P25, coe_P24,coe_P23, coe_P22, coe_P21, coe_P20, coe_P19, coe_P18, coe_P17, coe_P16,
			coe_P15, coe_P14, coe_P13, coe_P12, coe_P11, coe_P10, coe_P9, coe_P8, coe_P7, coe_P6, coe_P5, coe_P4, coe_P3, coe_P2, coe_P1, coe_P0};
			4: read_data <= io_out_en;
			default: read_data <= 0;
		endcase
	end
end

always@(posedge csi_MCLK_clk or posedge rsi_MRST_reset)
begin
	if(rsi_MRST_reset) begin
		io_data <= 0;
		io_out_en <= 0;
	end
	else begin
		if(avs_gpio_write) begin
			case(avs_gpio_address)
				2: begin 
					io_data <= avs_gpio_writedata;
				end
				4: begin 
					io_out_en <= avs_gpio_writedata;
				end
				default: begin end
			endcase
		end
	end
end

endmodule
