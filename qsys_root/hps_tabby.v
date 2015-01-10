module hps_tabby(
input					coe_M1_RSTN, coe_M1_CLK,

input		[21:0]	coe_M1_ADDR,
inout		[31:0]	coe_M1_DATA,
input		[3:0]		coe_M1_CSN,
input		[3:0]		coe_M1_BEN,
input					coe_M1_RDN, coe_M1_WRN,
output				coe_M1_WAITN,
output	[9:0]		coe_M1_EINT,

output				rso_MRST_reset,
output				cso_MCLK_clk,
output				cso_H1CLK_clk,
output				cso_H2CLK_clk,

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

//	rSMC_SETUP(0) = (0 << 24) + (2 << 16) + (0 << 8) + (0 << 0);
//	rSMC_PULSE(0) = (0 << 24) + (6 << 16) + (0 << 8) + (2 << 0);
//	rSMC_CYCLE(0) = (0 << 23) + (8 << 16) + (0 << 7) + (6 << 0);
//	rSMC_MODE(0) = (0 << 28) + (0 << 24) + (1 << 20) + (8 << 16) + (2 << 12) + (0 << 8) + (2 << 4) + (1 << 1) + (1 << 0);

assign 	rso_MRST_reset		= ~(pll_locked & coe_M1_RSTN);
assign	cso_MCLK_clk		= pll_clocks[0];	//133.33 MHz

assign	cso_H1CLK_clk			= coe_M1_CLK;	//66.66 MHz
assign	cso_H2CLK_clk			= pll_clocks[1];	//200.00 MHz

assign	coe_M1_DATA				= ((!coe_M1_RDN) && (coe_M1_CSN != 4'b1111) && (!rso_MRST_reset)) ? h_rdata : 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
assign	coe_M1_WAITN			= (~h_wait) | (rso_MRST_reset);
assign	coe_M1_EINT				= inr_EVENTS_irq;

assign	avm_M1_writedata		= q_wdata;
assign	q_rdata					= avm_M1_readdata;
assign	avm_M1_address			= q_addr;
assign	avm_M1_byteenable		= q_be;
assign	avm_M1_write			= q_wr;
assign	avm_M1_read				= q_rd;
assign	avm_M1_begintransfer	= q_btrans;
assign	q_rdvalid				= avm_M1_readdatavalid;
assign	q_wait					= avm_M1_waitrequest;

assign	q_clock = cso_MCLK_clk;
assign	q_reset = rso_MRST_reset;

wire					q_clock;
wire					q_reset;
reg		[3:0]		state = 0;

reg		[31:0]	h_rdata = 0;
reg					h_wait = 0;

reg		[31:0]	q_wdata = 0;
wire		[31:0]	q_rdata;
reg		[29:0]	q_addr = 0;
reg		[3:0]		q_be = 0;
reg					q_wr = 0;
reg					q_rd = 0;
reg					q_btrans = 0;
wire					q_rdvalid, q_wait;

reg		[3:0]		tmp_cs;
reg		[21:0]	tmp_addr;

reg		[19:0]	timeout = 0;

always@(posedge q_clock or posedge q_reset)
begin
	if(q_reset) begin
		q_addr <= 0;
		q_be <= 0;
	end
	else begin
		q_be <= ~coe_M1_BEN; 
		case(coe_M1_CSN)
			4'b1110: begin q_addr <= {8'b00010000, coe_M1_ADDR}; end
			4'b1101: begin q_addr <= {8'b00100000, coe_M1_ADDR}; end
			4'b1011: begin q_addr <= {8'b00110000, coe_M1_ADDR}; end
			4'b0111: begin q_addr <= {8'b01000000, coe_M1_ADDR}; end
			default: begin q_addr <= 0; end
		endcase	
	end
end


parameter idle = 4'd0;
parameter read_prepare  = idle + 1'd1;
parameter read_data     = read_prepare + 1'd1;
parameter read_finish   = read_data + 1'd1;
parameter write_prepare = read_finish + 1'd1;
parameter write_data    = write_prepare + 1'd1;
parameter write_write  = write_data + 1'd1;
parameter write_finish  = write_write + 1'd1;

always@(posedge q_clock or posedge q_reset)
begin
	if(q_reset) begin
		h_rdata <= 0;
		q_wdata <= 0;
		q_wr <= 0;
		q_rd <= 0;
		q_btrans <= 0;
		h_wait <= 0;
		timeout <= 0;
		state <= idle;
	end
	else begin
		case(state)
			idle: begin
				timeout <= 0;
				if((coe_M1_CSN != 4'b1111)&&(!coe_M1_RDN)&&(!q_wait)) begin
					q_btrans <= 0;
					q_wr <= 0;
					q_rd <= 0;
					h_wait <= 1;
					state <= read_prepare;
				end
				else if((coe_M1_CSN != 4'b1111)&&(!coe_M1_WRN)&&(!q_wait)) begin	
					q_btrans <= 0;
					q_wr <= 0;
					q_rd <= 0;
					h_wait <= 1;
					state <= write_prepare;
				end
				else begin
					h_rdata <= 0;
					q_wdata <= 0;
					q_wr <= 0;
					q_rd <= 0;
					q_btrans <= 0;
					h_wait <= 0;
					state <= idle;
				end
			end
			
			// Read process.
			read_prepare: begin
				tmp_addr <= coe_M1_ADDR;
				tmp_cs <= coe_M1_CSN;
				if((!q_wait)||(timeout == 20'hFFFFF)) begin
					q_btrans <= 1;
					q_rd <= 1;
					timeout <= 0;
					state <= read_data;
				end
				else begin 
					timeout <= timeout + 1;
					state <= read_prepare;
				end
			end			
			
			read_data: begin
				q_btrans <= 0;
				q_rd <= 0;
				if((q_rdvalid)||(timeout == 20'hFFFFF)) begin 
					h_rdata <= q_rdata; 
					h_wait <= q_wait; 
					timeout <= 0; 
					state <= read_finish; 
				end
				else begin 
					timeout <= timeout + 1;
					state <= read_data;
				end
			end
			
			read_finish: begin
				h_wait <= q_wait; 
				if((tmp_addr != coe_M1_ADDR)||(tmp_cs != coe_M1_CSN)||(coe_M1_RDN)||(timeout == 20'hFFFFF)) 
					state <= idle;
				else begin 
					timeout <= timeout + 1;
					state <= read_finish;
				end
			end
			
			// Write process.
			write_prepare: begin
				q_wdata <= coe_M1_DATA;
				if(coe_M1_WRN && (!q_wait)) begin
					h_wait <= 1;
					state <= write_data;
				end
				else begin
					h_wait <= q_wait;
					state <= write_prepare;
				end
			end
			
			write_data: begin
				if((!q_wait)||(timeout == 20'hFFFFF)) begin 
					q_btrans <= 1;
					q_wr <= 1;
					timeout <= 0;
					state <= write_write;
				end
				else begin 
					timeout <= timeout + 1;
					state <= write_data;
				end
			end
			
			write_write: begin
				q_btrans <= 0;
				q_wr <= 0;
				if((!q_wait)||(timeout == 20'hFFFFF)) begin
					timeout <= 0;
					state <= write_finish;
				end
				else begin 
					timeout <= timeout + 1;
					state <= write_write;
				end		
			end
			
			write_finish: begin
				if((!q_wait)||(timeout == 20'hFFFFF)) begin
					timeout <= 0;
					h_wait <= 0;
					state <= idle;
				end
				else begin 
					timeout <= timeout + 1;
					state <= write_finish;
				end
			end

			default: begin
				h_rdata <= 0;
				h_wait <= 0;
				q_wdata <= 0;
				q_wr <= 0;
				q_rd <= 0;
				q_btrans <= 0;
				timeout <= 0;
				state <= idle;
			end
			
		endcase
	end

end

wire		[4:0]		pll_clocks;
wire					pll_locked;

	altpll m1_bus_pll_inst1(
		.inclk (coe_M1_CLK),
		.clk (pll_clocks),
		.locked (pll_locked),
		.activeclock (),
		.areset (1'b0),
		.clkbad (),
		.clkena ({6{1'b1}}),
		.clkloss (),
		.clkswitch (1'b0),
		.configupdate (1'b0),
		.enable0 (),
		.enable1 (),
		.extclk (),
		.extclkena ({4{1'b1}}),
		.fbin (1'b1),
		.fbmimicbidir (),
		.fbout (),
		.fref (),
		.icdrclk (),
		.pfdena (1'b1),
		.phasecounterselect ({4{1'b1}}),
		.phasedone (),
		.phasestep (1'b1),
		.phaseupdown (1'b1),
		.pllena (1'b1),
		.scanaclr (1'b0),
		.scanclk (1'b0),
		.scanclkena (1'b1),
		.scandata (1'b0),
		.scandataout (),
		.scandone (),
		.scanread (1'b0),
		.scanwrite (1'b0),
		.sclkout0 (),
		.sclkout1 (),
		.vcooverrange (),
		.vcounderrange ());
	defparam
		m1_bus_pll_inst1.bandwidth_type = "AUTO",
		m1_bus_pll_inst1.clk0_divide_by = 1,
		m1_bus_pll_inst1.clk0_duty_cycle = 50,
		m1_bus_pll_inst1.clk0_multiply_by = 2,
		m1_bus_pll_inst1.clk0_phase_shift = "0",
		m1_bus_pll_inst1.clk1_divide_by = 1,
		m1_bus_pll_inst1.clk1_duty_cycle = 50,
		m1_bus_pll_inst1.clk1_multiply_by = 3,
		m1_bus_pll_inst1.clk1_phase_shift = "0",
		m1_bus_pll_inst1.compensate_clock = "CLK0",
		m1_bus_pll_inst1.inclk0_input_frequency = 15000,
		m1_bus_pll_inst1.intended_device_family = "Cyclone IV E",
		m1_bus_pll_inst1.lpm_hint = "CBX_MODULE_PREFIX=apll",
		m1_bus_pll_inst1.lpm_type = "altpll",
		m1_bus_pll_inst1.operation_mode = "NORMAL",
		m1_bus_pll_inst1.pll_type = "AUTO",
		m1_bus_pll_inst1.port_activeclock = "PORT_UNUSED",
		m1_bus_pll_inst1.port_areset = "PORT_UNUSED",
		m1_bus_pll_inst1.port_clkbad0 = "PORT_UNUSED",
		m1_bus_pll_inst1.port_clkbad1 = "PORT_UNUSED",
		m1_bus_pll_inst1.port_clkloss = "PORT_UNUSED",
		m1_bus_pll_inst1.port_clkswitch = "PORT_UNUSED",
		m1_bus_pll_inst1.port_configupdate = "PORT_UNUSED",
		m1_bus_pll_inst1.port_fbin = "PORT_UNUSED",
		m1_bus_pll_inst1.port_inclk0 = "PORT_USED",
		m1_bus_pll_inst1.port_inclk1 = "PORT_UNUSED",
		m1_bus_pll_inst1.port_locked = "PORT_USED",
		m1_bus_pll_inst1.port_pfdena = "PORT_UNUSED",
		m1_bus_pll_inst1.port_phasecounterselect = "PORT_UNUSED",
		m1_bus_pll_inst1.port_phasedone = "PORT_UNUSED",
		m1_bus_pll_inst1.port_phasestep = "PORT_UNUSED",
		m1_bus_pll_inst1.port_phaseupdown = "PORT_UNUSED",
		m1_bus_pll_inst1.port_pllena = "PORT_UNUSED",
		m1_bus_pll_inst1.port_scanaclr = "PORT_UNUSED",
		m1_bus_pll_inst1.port_scanclk = "PORT_UNUSED",
		m1_bus_pll_inst1.port_scanclkena = "PORT_UNUSED",
		m1_bus_pll_inst1.port_scandata = "PORT_UNUSED",
		m1_bus_pll_inst1.port_scandataout = "PORT_UNUSED",
		m1_bus_pll_inst1.port_scandone = "PORT_UNUSED",
		m1_bus_pll_inst1.port_scanread = "PORT_UNUSED",
		m1_bus_pll_inst1.port_scanwrite = "PORT_UNUSED",
		m1_bus_pll_inst1.port_clk0 = "PORT_USED",
		m1_bus_pll_inst1.port_clk1 = "PORT_USED",
		m1_bus_pll_inst1.port_clk2 = "PORT_UNUSED",
		m1_bus_pll_inst1.port_clk3 = "PORT_UNUSED",
		m1_bus_pll_inst1.port_clk4 = "PORT_UNUSED",
		m1_bus_pll_inst1.port_clk5 = "PORT_UNUSED",
		m1_bus_pll_inst1.port_clkena0 = "PORT_UNUSED",
		m1_bus_pll_inst1.port_clkena1 = "PORT_UNUSED",
		m1_bus_pll_inst1.port_clkena2 = "PORT_UNUSED",
		m1_bus_pll_inst1.port_clkena3 = "PORT_UNUSED",
		m1_bus_pll_inst1.port_clkena4 = "PORT_UNUSED",
		m1_bus_pll_inst1.port_clkena5 = "PORT_UNUSED",
		m1_bus_pll_inst1.port_extclk0 = "PORT_UNUSED",
		m1_bus_pll_inst1.port_extclk1 = "PORT_UNUSED",
		m1_bus_pll_inst1.port_extclk2 = "PORT_UNUSED",
		m1_bus_pll_inst1.port_extclk3 = "PORT_UNUSED",
		m1_bus_pll_inst1.self_reset_on_loss_lock = "ON",
		m1_bus_pll_inst1.width_clock = 5;

endmodule
