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
	reg [31:0] angle;
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
					if(avs_ctrl_byteenable[3]) angle[31:24] <= avs_ctrl_writedata[31:24];
					if(avs_ctrl_byteenable[2]) angle[23:16] <= avs_ctrl_writedata[23:16];
					if(avs_ctrl_byteenable[1]) angle[15:8] <= avs_ctrl_writedata[15:8];
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
	reg[32:0] counter;
	reg[32:0] counter1;
	always @ (posedge csi_PWMCLK_clk or posedge rsi_PWMRST_reset)
	begin
	counter = counter + 1;
	if(counter ==32'd5000) // 50MHz 
	begin
		counter = 0;
		counter1= counter1 + 1; 
	end
	if(counter1 == 8'd1)
	PWM_out <= 1;
	else if(counter1 == angle) PWM_out <= 0;
	else if (counter1 == 16'd200) counter1=0; end  //2ms
   assign streeing = PWM_out;

endmodule