module PIO16(
input					rsi_MRST_reset,
input					csi_MCLK_clk,

input		[31:0]	avs_gpio_writedata,
output	    [31:0]	avs_gpio_readdata,
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
inout					coe_P16
);

reg		[15:0]	 io_data;
reg		[15:0]	 io_out_en;
reg		[15:0]   read_data;

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

always@(posedge csi_MCLK_clk or posedge rsi_MRST_reset)
begin
	if(rsi_MRST_reset) begin
		read_data <= 0;
	end
	else begin
		case(avs_gpio_address)
//			0: read_data <= 8;
//			1: read_data <= 32'hEA680001;
			2: read_data <= {16'b0,	coe_P15, coe_P14, coe_P13, coe_P12, coe_P11, coe_P10, coe_P9, coe_P8, coe_P7, coe_P6, coe_P5, coe_P4, coe_P3, coe_P2, coe_P1, coe_P0};
			4: read_data <= {16'b0, io_out_en};
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
					io_data <= avs_gpio_writedata[15:0];
				end
				4: begin 
					io_out_en <= avs_gpio_writedata[15:0];
				end
				default: begin end
			endcase
		end
	end
end

endmodule
