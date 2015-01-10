module PIO8(
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
inout					coe_P7
);

reg		[7:0]	 io_data;
reg		[7:0]	 io_out_en;
reg		[31:0] read_data;

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


always@(posedge csi_MCLK_clk or posedge rsi_MRST_reset)
begin
	if(rsi_MRST_reset) begin
		read_data <= 0;
	end
	else begin
		case(avs_gpio_address)
//			0: read_data <= 8;
//			1: read_data <= 32'hEA680001;
			2: read_data <= {24'b0000, coe_P7, coe_P6, coe_P5, coe_P4, coe_P3, coe_P2, coe_P1, coe_P0};
			4: read_data <= {24'b0000, io_out_en};
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
					if(avs_gpio_byteenable[0]) io_data[7:0] <= avs_gpio_writedata[7:0];
				end
				4: begin 
					if(avs_gpio_byteenable[0]) io_out_en[7:0] <= avs_gpio_writedata[7:0];
				end
				default: begin end
			endcase
		end
	end
end

endmodule
