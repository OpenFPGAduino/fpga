module test_RegRW32(
//Avalon System control signal.
input					rsi_MRST_reset,	// reset_n from MCU GPIO
input					csi_MCLK_clk,

//Avalon-MM Control.
input		[31:0]	avs_test_writedata,
output	[31:0]	avs_test_readdata,
input		[3:0]		avs_test_byteenable,
input					avs_test_write,
input					avs_test_read,
output				avs_test_waitrequest
);

reg		[31:0]	test_data = 0;

assign	avs_test_readdata = test_data;
assign	avs_test_waitrequest = 1'b0;

always@(posedge csi_MCLK_clk or posedge rsi_MRST_reset)
begin
	if(rsi_MRST_reset) test_data <= 0;
	else begin
		if(avs_test_write) begin
			if(avs_test_byteenable[3]) test_data[31:24] <= avs_test_writedata[31:24];
			if(avs_test_byteenable[2]) test_data[23:16] <= avs_test_writedata[23:16];
			if(avs_test_byteenable[1]) test_data[15:8] <= avs_test_writedata[15:8];
			if(avs_test_byteenable[0]) test_data[7:0] <= avs_test_writedata[7:0];
		end
	end
end

endmodule
