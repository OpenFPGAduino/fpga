module arm9_soft(
input					coe_M1_RSTN, coe_M1_CLK,

output				rso_MRST_reset,
output				cso_MCLK_clk,

output	[31:0]	avm_M1_writedata,
input		[31:0]	avm_M1_readdata,
output	[29:0]	avm_M1_address,
output	[3:0]		avm_M1_byteenable,
output				avm_M1_write,
output				avm_M1_read,
output				avm_M1_begintransfer,
input					avm_M1_readdatavalid,
input					avm_M1_waitrequest,

input		[9:0]		inr_EVENTS_irq
);


assign 	rso_MRST_reset		   = ~coe_M1_RSTN;
assign	cso_H1CLK_clk			= coe_M1_CLK;	//66.66 MHz

wire [31:0] rom_address;
assign avm_M1_address = rom_address[29:0];
arm9_compatiable_code arm9(
          .clk(cso_H1CLK_clk),
			 .rst(rso_MRST_reset),
          .cpu_en(1'b1),
          .cpu_restart(1'b0),
			 .fiq(1'b0),
			 .irq(&inr_EVENTS_irq),
			           
          .rom_abort(1'b0),
          .rom_data(avm_M1_readdata),
			 .rom_addr(rom_address),
          .rom_en(avm_M1_read),


			 .ram_abort(1'b0),
          .ram_rdata(),
          .ram_addr(),
          .ram_cen(),
          .ram_flag(),
          .ram_wdata(),
          .ram_wen()

);

endmodule
