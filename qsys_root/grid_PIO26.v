module grid_PIO26(
input					rsi_MRST_reset,
input					csi_MCLK_clk,

input		[31:0]	avs_gpio_writedata,
output	[31:0]	avs_gpio_readdata,
input		[4:0]		avs_gpio_address,
input		[3:0]		avs_gpio_byteenable,
input					avs_gpio_write,
input					avs_gpio_read,
output				avs_gpio_waitrequest,

output				ins_gpint_irq,

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
inout					coe_P25
);

reg		[25:0]	io_data = 0;
reg		[25:0]	io_out_en = 0;
reg		[25:0]	io_int_mask = 0;
reg		[25:0] 	io_int_clear = 0;
reg		[25:0]	io_int_en = 0;
reg		[25:0]	io_int_inv = 0; 
reg		[25:0]	io_int_edge = 0;

reg		[31:0]	read_data = 0;

assign	avs_gpio_readdata = read_data;
assign	avs_gpio_waitrequest = 1'b0;
assign	ins_gpint_irq = (io_int_mask == 0) ? 1'b0 : 1'b1;

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

always@(posedge csi_MCLK_clk or posedge rsi_MRST_reset)
begin
	if(rsi_MRST_reset) begin
		io_int_mask <= 0;
	end
	else begin
		io_int_mask <= 0;
	end
end

/*
 * GRID_MOD_SIZE		0x0
 * GRID_MOD_ID			0x4
 * PIO_DOUT				0x8
 * PIO_DIN				0xC
 * PIO_DOE				0x10
 * resv					0x14
 * resv					0x18
 * resv					0x1C
 * PIO_IMASK			0x20
 * PIO_ICLR				0x24
 * PIO_IE				0x28
 * PIO_IINV				0x2C
 * PIO_IEDGE			0x30
 * resv					0x34
 * resv					0x38
 * resv					0x3C
 * PIO_IO0				0x40
 * PIO_IO1				0x41
 * PIO_IO2				0x42
 * PIO_IO3				0x43
 * PIO_IO4				0x44
 * PIO_IO5				0x45
 * PIO_IO6				0x46
 * PIO_IO7				0x47
 * PIO_IO8				0x48
 * PIO_IO9				0x49
 * PIO_IO10				0x4A
 * PIO_IO11				0x4B
 * PIO_IO12				0x4C
 * PIO_IO13				0x4D
 * PIO_IO14				0x4E
 * PIO_IO15				0x4F
 * PIO_IO16				0x50
 * PIO_IO17				0x51
 * PIO_IO18				0x52
 * PIO_IO19				0x53
 * PIO_IO20				0x54
 * PIO_IO21				0x55
 * PIO_IO22				0x56
 * PIO_IO23				0x57
 * PIO_IO24				0x58
 * PIO_IO25				0x59
 */

//always@(avs_gpio_address or io_data or io_out_en or io_int_mask or io_int_clear or io_int_en or io_int_inv or io_int_edge or coe_P25 or coe_P24 or coe_P23 or coe_P22 or coe_P21 or coe_P20 or coe_P19 or coe_P18 or coe_P17 or coe_P16 or coe_P15 or coe_P14 or coe_P13 or coe_P12 or coe_P11 or coe_P10 or coe_P9 or coe_P8 or coe_P7 or coe_P6 or coe_P5 or coe_P4 or coe_P3 or coe_P2 or coe_P1 or coe_P0)
//begin:MUX_R
//	case(avs_gpio_address)
//		0: read_data = 128;
//		1: read_data = 32'hEA680001;
//		2: read_data = {4'b0000, io_data[25:22], io_data[21:14], io_data[13:6], 2'b00, io_data[5:0]};
//		3: read_data = {4'b0000, coe_P25, coe_P24, coe_P23, coe_P22, coe_P21, coe_P20, coe_P19, coe_P18, coe_P17, coe_P16, coe_P15, coe_P14, coe_P13, coe_P12, coe_P11, coe_P10, coe_P9, coe_P8, coe_P7, coe_P6, 2'b00, coe_P5, coe_P4, coe_P3, coe_P2, coe_P1, coe_P0};
//		4: read_data = {4'b0000, io_out_en[25:22], io_out_en[21:14], io_out_en[13:6], 2'b00, io_out_en[5:0]};
//		
//		8: read_data = {4'b0000, io_int_mask[25:22], io_int_mask[21:14], io_int_mask[13:6], 2'b00, io_int_mask[5:0]};
//		9: read_data = {4'b0000, io_int_clear[25:22], io_int_clear[21:14], io_int_clear[13:6], 2'b00, io_int_clear[5:0]};
//		10: read_data = {4'b0000, io_int_en[25:22], io_int_en[21:14], io_int_en[13:6], 2'b00, io_int_en[5:0]};
//		11: read_data = {4'b0000, io_int_inv[25:22], io_int_inv[21:14], io_int_inv[13:6], 2'b00, io_int_inv[5:0]};
//		12: read_data = {4'b0000, io_int_edge[25:22], io_int_edge[21:14], io_int_edge[13:6], 2'b00, io_int_edge[5:0]};
//		
//		16: read_data = {7'b0, coe_P3, 7'b0, coe_P2, 7'b0, coe_P1, 7'b0, coe_P0};
//		17: read_data = {7'b0, coe_P7, 7'b0, coe_P6, 7'b0, coe_P5, 7'b0, coe_P4};
//		18: read_data = {7'b0, coe_P11, 7'b0, coe_P10, 7'b0, coe_P9, 7'b0, coe_P8};
//		19: read_data = {7'b0, coe_P15, 7'b0, coe_P14, 7'b0, coe_P13, 7'b0, coe_P12};
//		20: read_data = {7'b0, coe_P19, 7'b0, coe_P18, 7'b0, coe_P17, 7'b0, coe_P16};
//		21: read_data = {7'b0, coe_P23, 7'b0, coe_P22, 7'b0, coe_P21, 7'b0, coe_P20};
//		22: read_data = {23'b0, coe_P25, 7'b0, coe_P24};
//		default: read_data = 0;
//	endcase
//end

always@(posedge csi_MCLK_clk or posedge rsi_MRST_reset)
begin
	if(rsi_MRST_reset) begin
		read_data <= 0;
	end
	else begin
		case(avs_gpio_address)
			0: read_data <= 128;
			1: read_data <= 32'hEA680001;
			2: read_data <= {4'b0000, io_data[25:22], io_data[21:14], io_data[13:6], 2'b00, io_data[5:0]};
			3: read_data <= {4'b0000, coe_P25, coe_P24, coe_P23, coe_P22, coe_P21, coe_P20, coe_P19, coe_P18, coe_P17, coe_P16, coe_P15, coe_P14, coe_P13, coe_P12, coe_P11, coe_P10, coe_P9, coe_P8, coe_P7, coe_P6, 2'b00, coe_P5, coe_P4, coe_P3, coe_P2, coe_P1, coe_P0};
			4: read_data <= {4'b0000, io_out_en[25:22], io_out_en[21:14], io_out_en[13:6], 2'b00, io_out_en[5:0]};
			
			8: read_data <= {4'b0000, io_int_mask[25:22], io_int_mask[21:14], io_int_mask[13:6], 2'b00, io_int_mask[5:0]};
			9: read_data <= {4'b0000, io_int_clear[25:22], io_int_clear[21:14], io_int_clear[13:6], 2'b00, io_int_clear[5:0]};
			10: read_data <= {4'b0000, io_int_en[25:22], io_int_en[21:14], io_int_en[13:6], 2'b00, io_int_en[5:0]};
			11: read_data <= {4'b0000, io_int_inv[25:22], io_int_inv[21:14], io_int_inv[13:6], 2'b00, io_int_inv[5:0]};
			12: read_data <= {4'b0000, io_int_edge[25:22], io_int_edge[21:14], io_int_edge[13:6], 2'b00, io_int_edge[5:0]};
			
			16: read_data <= {7'b0, coe_P3, 7'b0, coe_P2, 7'b0, coe_P1, 7'b0, coe_P0};
			17: read_data <= {7'b0, coe_P7, 7'b0, coe_P6, 7'b0, coe_P5, 7'b0, coe_P4};
			18: read_data <= {7'b0, coe_P11, 7'b0, coe_P10, 7'b0, coe_P9, 7'b0, coe_P8};
			19: read_data <= {7'b0, coe_P15, 7'b0, coe_P14, 7'b0, coe_P13, 7'b0, coe_P12};
			20: read_data <= {7'b0, coe_P19, 7'b0, coe_P18, 7'b0, coe_P17, 7'b0, coe_P16};
			21: read_data <= {7'b0, coe_P23, 7'b0, coe_P22, 7'b0, coe_P21, 7'b0, coe_P20};
			22: read_data <= {23'b0, coe_P25, 7'b0, coe_P24};
			default: read_data <= 0;
		endcase
	end
end

always@(posedge csi_MCLK_clk or posedge rsi_MRST_reset)
begin
	if(rsi_MRST_reset) begin
		io_data <= 0;
		io_out_en <= 0;
		io_int_clear <= 0;
		io_int_en <= 0;
		io_int_inv <= 0;
		io_int_edge <= 0;
	end
	else begin
		if(avs_gpio_write) begin
			case(avs_gpio_address)
				2: begin 
					if(avs_gpio_byteenable[3]) io_data[25:22] <= avs_gpio_writedata[27:24];
					if(avs_gpio_byteenable[2]) io_data[21:14] <= avs_gpio_writedata[23:16];
					if(avs_gpio_byteenable[1]) io_data[13:6] <= avs_gpio_writedata[15:8];
					if(avs_gpio_byteenable[0]) io_data[5:0] <= avs_gpio_writedata[5:0];
				end
				
				4: begin
					if(avs_gpio_byteenable[3]) io_out_en[25:22] <= avs_gpio_writedata[27:24];
					if(avs_gpio_byteenable[2]) io_out_en[21:14] <= avs_gpio_writedata[23:16];
					if(avs_gpio_byteenable[1]) io_out_en[13:6] <= avs_gpio_writedata[15:8];
					if(avs_gpio_byteenable[0]) io_out_en[5:0] <= avs_gpio_writedata[5:0];
				end

				9: begin
					if(avs_gpio_byteenable[3]) io_int_clear[25:22] <= avs_gpio_writedata[27:24]; 
					else begin
						io_int_clear[25] <= io_int_mask[25];
						io_int_clear[24] <= io_int_mask[24];
						io_int_clear[23] <= io_int_mask[23];
						io_int_clear[22] <= io_int_mask[22];
					end
					if(avs_gpio_byteenable[2]) io_int_clear[21:14] <= avs_gpio_writedata[23:16];
					else begin
						io_int_clear[21] <= io_int_mask[21];
						io_int_clear[20] <= io_int_mask[20];
						io_int_clear[19] <= io_int_mask[19];
						io_int_clear[18] <= io_int_mask[18];
						io_int_clear[17] <= io_int_mask[17];
						io_int_clear[16] <= io_int_mask[16];
						io_int_clear[15] <= io_int_mask[15];
						io_int_clear[14] <= io_int_mask[14];
					end	
					if(avs_gpio_byteenable[1]) io_int_clear[13:6] <= avs_gpio_writedata[15:8];
					else begin
						io_int_clear[13] <= io_int_mask[13];
						io_int_clear[12] <= io_int_mask[12];
						io_int_clear[11] <= io_int_mask[11];
						io_int_clear[10] <= io_int_mask[10];
						io_int_clear[9] <= io_int_mask[9];
						io_int_clear[8] <= io_int_mask[8];
						io_int_clear[7] <= io_int_mask[7];
						io_int_clear[6] <= io_int_mask[6];					
					end
					if(avs_gpio_byteenable[0]) io_int_clear[5:0] <= avs_gpio_writedata[5:0];
					else begin
						io_int_clear[5] <= io_int_mask[5];
						io_int_clear[4] <= io_int_mask[4];
						io_int_clear[3] <= io_int_mask[3];
						io_int_clear[2] <= io_int_mask[2];
						io_int_clear[1] <= io_int_mask[1];
						io_int_clear[0] <= io_int_mask[0];						
					end
				end
				
				10: begin
					if(avs_gpio_byteenable[3]) io_int_en[25:22] <= avs_gpio_writedata[27:24];
					if(avs_gpio_byteenable[2]) io_int_en[21:14] <= avs_gpio_writedata[23:16];
					if(avs_gpio_byteenable[1]) io_int_en[13:6] <= avs_gpio_writedata[15:8];
					if(avs_gpio_byteenable[0]) io_int_en[5:0] <= avs_gpio_writedata[5:0];
				end

				11: begin
					if(avs_gpio_byteenable[3]) io_int_inv[25:22] <= avs_gpio_writedata[27:24];
					if(avs_gpio_byteenable[2]) io_int_inv[21:14] <= avs_gpio_writedata[23:16];
					if(avs_gpio_byteenable[1]) io_int_inv[13:6] <= avs_gpio_writedata[15:8];
					if(avs_gpio_byteenable[0]) io_int_inv[5:0] <= avs_gpio_writedata[5:0];
				end
				
				12: begin
					if(avs_gpio_byteenable[3]) io_int_edge[25:22] <= avs_gpio_writedata[27:24];
					if(avs_gpio_byteenable[2]) io_int_edge[21:14] <= avs_gpio_writedata[23:16];
					if(avs_gpio_byteenable[1]) io_int_edge[13:6] <= avs_gpio_writedata[15:8];
					if(avs_gpio_byteenable[0]) io_int_edge[5:0] <= avs_gpio_writedata[5:0];
				end
				
				16: begin
					if(avs_gpio_byteenable[3]) io_data[3] <= avs_gpio_writedata[24];
					if(avs_gpio_byteenable[2]) io_data[2] <= avs_gpio_writedata[16];
					if(avs_gpio_byteenable[1]) io_data[1] <= avs_gpio_writedata[8];
					if(avs_gpio_byteenable[0]) io_data[0] <= avs_gpio_writedata[0];			
				end

				17: begin
					if(avs_gpio_byteenable[3]) io_data[7] <= avs_gpio_writedata[24];
					if(avs_gpio_byteenable[2]) io_data[6] <= avs_gpio_writedata[16];	
					if(avs_gpio_byteenable[1]) io_data[5] <= avs_gpio_writedata[8];
					if(avs_gpio_byteenable[0]) io_data[4] <= avs_gpio_writedata[0];			
				end

				18: begin
					if(avs_gpio_byteenable[3]) io_data[11] <= avs_gpio_writedata[24];
					if(avs_gpio_byteenable[2]) io_data[10] <= avs_gpio_writedata[16];
					if(avs_gpio_byteenable[1]) io_data[9] <= avs_gpio_writedata[8];
					if(avs_gpio_byteenable[0]) io_data[8] <= avs_gpio_writedata[0];			
				end

				19: begin
					if(avs_gpio_byteenable[3]) io_data[15] <= avs_gpio_writedata[24];
					if(avs_gpio_byteenable[2]) io_data[14] <= avs_gpio_writedata[16];
					if(avs_gpio_byteenable[1]) io_data[13] <= avs_gpio_writedata[8];
					if(avs_gpio_byteenable[0]) io_data[12] <= avs_gpio_writedata[0];			
				end
	
				20: begin
					if(avs_gpio_byteenable[3]) io_data[19] <= avs_gpio_writedata[24];
					if(avs_gpio_byteenable[2]) io_data[18] <= avs_gpio_writedata[16];
					if(avs_gpio_byteenable[1]) io_data[17] <= avs_gpio_writedata[8];
					if(avs_gpio_byteenable[0]) io_data[16] <= avs_gpio_writedata[0];			
				end
	
				21: begin
					if(avs_gpio_byteenable[3]) io_data[23] <= avs_gpio_writedata[24];
					if(avs_gpio_byteenable[2]) io_data[22] <= avs_gpio_writedata[16];
					if(avs_gpio_byteenable[1]) io_data[21] <= avs_gpio_writedata[8];
					if(avs_gpio_byteenable[0]) io_data[20] <= avs_gpio_writedata[0];			
				end
	
				22: begin
					if(avs_gpio_byteenable[1]) io_data[25] <= avs_gpio_writedata[8];
					if(avs_gpio_byteenable[0]) io_data[24] <= avs_gpio_writedata[0];			
				end
	
				default: begin end
			endcase
		end
	end
end

endmodule
