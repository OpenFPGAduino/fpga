module basic_SysID(
//Avalon System control signal.
input					rsi_MRST_reset,	// reset_n from MCU GPIO
input					csi_MCLK_clk,

//Avalon-MM LED Control.
output	[31:0]	avs_SysID_readdata,
input		[1:0]		avs_SysID_address,
input					avs_SysID_read,
output				avs_SysID_waitrequest
);

reg		[31:0]	out_data;

assign	avs_SysID_readdata = out_data;
assign	avs_SysID_waitrequest = 1'b0;

always@(avs_SysID_address)
begin:MUX
	case(avs_SysID_address)
		0: out_data <= {16'hEA68, 16'h0001};
		1: out_data <= {16'h0000, 16'h0000};
		2: out_data <= 32'hA5A5A5A5;
		3: out_data <= 32'h5A5A5A5A;
	endcase
end

endmodule
