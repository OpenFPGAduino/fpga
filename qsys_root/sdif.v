module sdi_interface(
// Qsys bus interface	
		input					rsi_MRST_reset,
		input					csi_MCLK_clk,
		input		[31:0]	avs_ctrl_writedata,
		output	[31:0]	avs_ctrl_readdata,
		input		[3:0]		avs_ctrl_byteenable,
		input		[2:0]		avs_ctrl_address,
		input					avs_ctrl_write,
		input					avs_ctrl_read,
		output				avs_ctrl_waitrequest,
		
		input					rsi_PWMRST_reset,
      input					csi_PWMCLK_clk,
//sdi_interface		
		input  SPDIF_IN,	
		output SPDIF_OUT		
		);
//Qsys controller		
	reg [31:0] read_data;  	
	reg [31:0] sdi_state;
	assign	avs_ctrl_readdata = read_data;
	always@(posedge csi_MCLK_clk or posedge rsi_MRST_reset)
	begin
		if(rsi_MRST_reset) begin
			read_data <= 0;
		end
		else if(avs_ctrl_write) 
		begin
			case(avs_ctrl_address)
				1: begin
					if(avs_ctrl_byteenable[3]) sdi_state[31:24] <= avs_ctrl_writedata[31:24];
					if(avs_ctrl_byteenable[2]) sdi_state[23:16] <= avs_ctrl_writedata[23:16];
					if(avs_ctrl_byteenable[1]) sdi_state[15:8]  <= avs_ctrl_writedata[15:8];
					if(avs_ctrl_byteenable[0]) sdi_state[7:0]   <= avs_ctrl_writedata[7:0];
				end
				default:;
			endcase
	   end
		else if(avs_ctrl_read)
		begin
			case(avs_ctrl_address)
				0: read_data <= 32'hEA680003;
				1: read_data <= {30'b0,SPDIF_IN,sdi_state[0]};
				default: read_data <= 32'b0;
			endcase
		end
	end
	assign SPDIF_OUT = sdi_state[1];
endmodule