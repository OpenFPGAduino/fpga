module steering_driver(
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
      input					csi_PWMCLK_clk,     //200Mhz

//brush_moter_interface		
		output streeing	
		);
//Qsys controller		
	reg forward_back;
   reg on_off;
	reg [9:0] angle;
	reg [31:0] read_data;
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
					if(avs_ctrl_byteenable[1]) angle[9:8] <= avs_ctrl_writedata[9:8];
					if(avs_ctrl_byteenable[0]) angle[7:0] <= avs_ctrl_writedata[7:0];
				end
				default:;
			endcase
	   end
		else begin
			case(avs_ctrl_address)
				0: read_data <= 32'hEA680003;
				1: read_data <= angle;
				default: read_data <= 32'b0;
			endcase
		end
	end
//steering controller		
	reg PWM_out;
	reg[31:0] counter;
	always @ (posedge csi_PWMCLK_clk or posedge rsi_PWMRST_reset)
	begin
		if (rsi_PWMRST_reset) 
			counter <= 32'b0;
		else 	
			counter <= counter + 2048 * 639; // 500 * 0xffffffff / 200000000;
	end
	reg [10:0] PWM; // 2048 
	always @(posedge counter[31] or posedge rsi_PWMRST_reset)
	begin
		if (rsi_PWMRST_reset) 
			PWM <= 32'b0;
		else 	
			PWM <= PWM + 1;
	end
	always @(PWM)
	begin
		if(PWM < angle)
			PWM_out<= 1;
		else
			PWM_out<= 0;
	end
   assign streeing = PWM_out;

endmodule