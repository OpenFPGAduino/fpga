module grid_CloseID(
//Avalon System control signal.
input					rsi_MRST_reset,	// reset_n from MCU GPIO
input					csi_MCLK_clk,

//Avalon-MM LED Control.
output	[31:0]	avs_CloseID_readdata,
input		[1:0]		avs_CloseID_address,
input					avs_CloseID_read,
output				avs_CloseID_waitrequest
);

reg		[31:0]	out_data;

assign	avs_CloseID_readdata = out_data;
assign	avs_CloseID_waitrequest = 1'b0;

always@(avs_CloseID_address)
begin:MUX
	case(avs_CloseID_address)
		0: out_data <= 32'h0;
		1: out_data <= 32'hA5A5A5A5;
		2: out_data <= 32'h0;
		3: out_data <= 32'h5A5A5A5A;
	endcase
end

endmodule
