module SIO32(
	// Qsys interface
	input					rsi_MRST_reset,
	input					csi_MCLK_clk,

	input		[31:0]	avs_gpio_writedata,
	output	[31:0]	avs_gpio_readdata,
	input		[2:0]		avs_gpio_address,
	input		[3:0]		avs_gpio_byteenable,
	input					avs_gpio_write,
	input					avs_gpio_read,
	output				avs_gpio_waitrequest,
	
	// EPL interface
	output EPL_SCLK,	
	output reg EPL_SDI,	
	input  EPL_SDO,		
	output reg EPL_SLE,		
	input  EPL_INT
);	
	reg [2:0] temp_clk;
	always@(posedge csi_MCLK_clk)
	begin
		temp_clk <= temp_clk + 1;
	end
	assign EPL_SCLK = temp_clk[2];
	//assign EPL_SCLK = csi_MCLK_clk;
	
	reg [31:0] port_i;
	reg [31:0] port_o;
	reg [31:0] read_data;
	assign avs_gpio_readdata = read_data;
	always@(posedge csi_MCLK_clk or posedge rsi_MRST_reset)
	begin
		if(rsi_MRST_reset) begin
			read_data <= 0;
		end
		else begin
			case(avs_gpio_address)
				0: read_data <= 8;
				1: read_data <= 32'hEA680001;
				2: read_data <= port_o;
				default: read_data <= 0;
			endcase
		end
	end

	always@(posedge csi_MCLK_clk or posedge rsi_MRST_reset)
	begin
		if(rsi_MRST_reset) begin
			
		end
		else begin
			if(avs_gpio_write) begin
				case(avs_gpio_address)
					2: begin 
						port_i <= avs_gpio_writedata;
					end
					default: begin end
				endcase
			end
		end
	end
	
	reg [63:0]data_buffer;	
	parameter data_input = 8'd0;
	parameter data_ready = data_input + 1;
	parameter data_sync  = data_ready+ 1;
	parameter data_output = data_sync+ 66;	
	reg [7:0] state;
	reg [7:0] nextstate;
	
	always@(posedge EPL_SCLK or posedge rsi_MRST_reset)
	begin
		if(rsi_MRST_reset) begin
			state <= 8'b0;
		end
		else begin
			state <= state + 8'b1;
			if(state >= data_sync && state < data_output)
				begin
					integer i;
					EPL_SLE = 1'b1;
					EPL_SDI <= data_buffer[63];
					for(i=0;i<63;i=i+1)
						data_buffer[i+1] <= data_buffer[i];
					data_buffer[0]<= EPL_SDO;
				end
			else begin
				case(state)
					data_input: 
					begin
						EPL_SLE = 1'b0;		
						data_buffer[63:32] <= port_i;
						data_buffer[31:0] <= 32'h0;
					end
					data_ready: 
					begin
						EPL_SLE = 1'b0;
					end
					data_output:
					begin
						EPL_SLE = 1'b0;
						port_o <= data_buffer[31:0];
					end
				endcase
			end
		end
	end

endmodule 
