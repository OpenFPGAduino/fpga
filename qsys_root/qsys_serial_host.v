module qsys_serial_host(
		// Qsys serial interface
		output    reg		sdo,
		input 		      sdi,
		input             clk,
		input             sle,
		output    reg     srdy,
		
		input             reset,

	   // Qsys bus interface
		output				rso_MRST_reset,
		output				cso_MCLK_clk,

		output	reg[31:0]avm_M1_writedata,
		input		[31:0]	avm_M1_readdata,
		output	reg[7:0] avm_M1_address,
		output	[3:0]		avm_M1_byteenable,
		output	reg		avm_M1_write,
		output	reg		avm_M1_read,
		output				avm_M1_begintransfer,
		input					avm_M1_readdatavalid,
		input					avm_M1_waitrequest
);

		assign cso_MCLK_clk = clk;
		assign rso_MRST_reset = reset;
		reg [64:0] data_buffer;
		assign avm_M1_byteenable = 4'b1111;
		
		parameter initial_state = 8'd0;
		parameter bus_ready = initial_state+8'd1;
		parameter bus_transmit_start = bus_ready+8'd1;
		parameter bus_transmit_ready = bus_transmit_start+8'd1;
		parameter bus_address_ready = bus_transmit_ready + 8'd1;
		parameter bus_data_wait = bus_address_ready + 8'd1;
		parameter bus_data_ready = bus_data_wait + 8'd1;
		parameter bus_transmit_back = bus_data_ready + 8'd1;
		parameter bus_transmit_finish = bus_transmit_back + 8'd32;

		reg [7:0] state;
		reg [7:0] nextstate;
		always@(posedge clk or posedge reset)
		begin
			if (reset)
				state <= initial_state;
			else 
				state <= nextstate;
		end
		always@(state or sle or avm_M1_waitrequest)
		begin
			case(state)
			initial_state: nextstate <= bus_ready;
			bus_ready: begin
				if(sle == 1'b1) nextstate <= bus_transmit_start;
				else nextstate <= bus_ready;
			end
			bus_transmit_start: begin
				if(sle == 1'b0) nextstate <= bus_transmit_ready;
				else nextstate <= bus_transmit_start;
			end
			bus_transmit_ready: nextstate <= bus_address_ready;
			bus_address_ready:  nextstate <= bus_data_wait;
			bus_data_wait: begin 
				if(avm_M1_waitrequest == 1'b0) nextstate <= bus_data_ready;
				else nextstate <= bus_data_wait;
			end		
			bus_data_ready: nextstate <= bus_transmit_back;
			bus_transmit_back:nextstate <= state + 1;
			bus_transmit_finish:nextstate <= bus_ready;
			default:
				nextstate <= state + 1;
			endcase
		end
		
		always@(posedge clk)
		begin
			if (state >= bus_transmit_back && state < bus_transmit_finish)
			begin
				integer i;
				for(i=0;i<64;i=i+1)
					data_buffer[i+1] <= data_buffer[i];
				sdo <= data_buffer[31];
			end 
			else begin
				case(state)
				bus_transmit_start:
				begin
					integer i;
					for(i=0;i<64;i=i+1)
						data_buffer[i+1] <= data_buffer[i];
					data_buffer[0]<= sdi;
				end
				bus_transmit_ready:
					avm_M1_address <= data_buffer[63:32];
				bus_address_ready: 
				begin
					if (data_buffer[64] == 1'b0) begin
						avm_M1_read  <= 1'b1;
						avm_M1_write <= 1'b0; 
					end
					else begin
						avm_M1_writedata <= data_buffer[31:0];
						avm_M1_read <= 1'd0;
						avm_M1_write <= 1'b1; 
					end
				end
				bus_data_ready: begin
					data_buffer[31:0] <= avm_M1_readdata;
					avm_M1_read <= 1'd0;
					avm_M1_write <= 1'b0; 
				end
				endcase
			end
		end
	
		always@(posedge clk)
		begin
			if (state >= bus_data_ready && state < bus_transmit_finish-1)
			srdy <= 1;
			else
			srdy <= 0;
		end
endmodule