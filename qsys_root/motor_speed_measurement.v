module motor_speed_measurement(
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
		
		// motor speed measurement interface
		input frequent
		);
		
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
					if(avs_ctrl_byteenable[3]) gate_frequence[31:24] <= avs_ctrl_writedata[31:24];
					if(avs_ctrl_byteenable[2]) gate_frequence[23:16] <= avs_ctrl_writedata[23:16];
					if(avs_ctrl_byteenable[1]) gate_frequence[15:8] <= avs_ctrl_writedata[15:8];
					if(avs_ctrl_byteenable[0]) gate_frequence[7:0] <= avs_ctrl_writedata[7:0];
				end
				2: begin
					if(avs_ctrl_byteenable[0]) reset <= avs_ctrl_writedata[0];
				end
				default:;
			endcase
	   end
		else begin
			case(avs_ctrl_address)
				0: read_data <= 32'hEA680003;
				1: read_data <= gate_frequence;
				2: read_data <= {23'b0,ready,7'b0,reset};
				3: read_data <= counter_a;
				4: read_data <= counter_b;
				default: read_data <= 32'b0;
			endcase
		end
	end		
			
	//gate signal generate
	wire gate;
	reg [31:0] gate_frequence;
	reg [31:0] tempgate;
	always@(posedge csi_PWMCLK_clk)				
		tempgate<=tempgate+gate_frequence;			
	assign gate=tempgate[31];
	
	//measurement signal
	wire f1;
	wire f2;
	reg temp;
	always@(posedge frequent)
		temp<=gate;
	assign f1=frequent & temp;
	assign f2=csi_PWMCLK_clk &  temp;

	reg [7:0]state;												
	reg [7:0]nextstate;	
	reg reset;
	always@(posedge csi_PWMCLK_clk or posedge rsi_PWMRST_reset) 
		if(rsi_PWMRST_reset)state<=1;
		else if(reset)state<=1;
		else state<=nextstate;
	always@(state or temp)
		case(state)
		1:if(temp==0)nextstate=2;else nextstate=1;
		2:if(temp==1)nextstate=3;else nextstate=2; 
		3:if(temp==0)nextstate=4;else nextstate=3;
		4:nextstate=4;							
		endcase
	
	//measurement couter 
	reg [31:0]counter_a;
	reg [31:0]counter_b;
	always @ (posedge f1 or posedge rsi_PWMRST_reset)
		if(rsi_PWMRST_reset)counter_a<=0;
		else if(reset)counter_a<=0;
		else if(state==4)counter_a<=counter_a;						
		else counter_a<=counter_a+1;			
	always @ (posedge f2 or posedge reset)
		if(rsi_PWMRST_reset)counter_b<=0;		
		else if(reset)counter_b<=0;
		else if(state==4)counter_b<=counter_b;
		else counter_b<=counter_b+1;
	
	reg ready;
	always@(posedge csi_PWMCLK_clk)
		if(state==4)ready<=1;
		else ready<=0;
		

endmodule 