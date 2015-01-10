module brushless_motor(
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
//brushless_moter_interface		
		input I_limit,	
		
		input Ha,
		input Hb,
		input Hc,
		
		output Lau,		
		output Lbu,
		output Lcu,
		output Lad,
		output Lbd,
		output Lcd
		);
//Qsys controller		
	reg  forward_back;
	reg  brake;   
	wire error;		    	
	reg [31:0] PWM_width;
	reg [31:0] PWM_frequent;
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
					if(avs_ctrl_byteenable[3]) PWM_frequent[31:24] <= avs_ctrl_writedata[31:24];
					if(avs_ctrl_byteenable[2]) PWM_frequent[23:16] <= avs_ctrl_writedata[23:16];
					if(avs_ctrl_byteenable[1]) PWM_frequent[15:8] <= avs_ctrl_writedata[15:8];
					if(avs_ctrl_byteenable[0]) PWM_frequent[7:0] <= avs_ctrl_writedata[7:0];
				end
				2: begin
					if(avs_ctrl_byteenable[3]) PWM_width[31:24] <= avs_ctrl_writedata[31:24];
					if(avs_ctrl_byteenable[2]) PWM_width[23:16] <= avs_ctrl_writedata[23:16];
					if(avs_ctrl_byteenable[1]) PWM_width[15:8] <= avs_ctrl_writedata[15:8];
					if(avs_ctrl_byteenable[0]) PWM_width[7:0] <= avs_ctrl_writedata[7:0];
				end
				3: brake <= avs_ctrl_writedata[0];
				4: forward_back <= avs_ctrl_writedata[0];
				default:;
			endcase
	   end
		else begin
			case(avs_ctrl_address)
				0: read_data <= 32'hEA680003;
				1: read_data <= PWM_frequent;
				2: read_data <= PWM_width;
				3: read_data <= {31'b0,brake};
				4: read_data <= {31'b0,forward_back};
				default: read_data <= 32'b0;
			endcase
		end
	end
//PWM controller		
	reg [31:0] PWM;
	reg PWM_out;
	always @ (posedge csi_PWMCLK_clk or posedge rsi_PWMRST_reset)
	begin
		if(rsi_PWMRST_reset)
			PWM <= 32'b0;
		else
		begin
			PWM <= PWM + PWM_frequent;
			PWM_out <=(PWM > PWM_width) ? 0:1;   
		end
	end
	
//Brushless motor controller 			
	reg Lau_r;		
	reg Lbu_r;
	reg Lcu_r;
	reg Lad_r;
	reg Lbd_r;
	reg Lcd_r;		
	always @(Ha or Hb or Hc)
	begin
		if(I_limit)
			{Lau_r,Lbu_r,Lcu_r,Lad_r,Lbd_r,Lcd_r}<= 6'd0;
		else if(brake)
			{Lau_r,Lbu_r,Lcu_r,Lad_r,Lbd_r,Lcd_r}<= 6'b000111;
		else
		if(forward_back)		
			case ({Ha,Hb,Hc})
				3'b100:
					{Lau_r,Lbu_r,Lcu_r,Lad_r,Lbd_r,Lcd_r}<= 6'b100001;
				3'b110:
					{Lau_r,Lbu_r,Lcu_r,Lad_r,Lbd_r,Lcd_r}<= 6'b010001;
				3'b010:
					{Lau_r,Lbu_r,Lcu_r,Lad_r,Lbd_r,Lcd_r}<= 6'b010100;
				3'b011:
					{Lau_r,Lbu_r,Lcu_r,Lad_r,Lbd_r,Lcd_r}<= 6'b001100;
				3'b001:
					{Lau_r,Lbu_r,Lcu_r,Lad_r,Lbd_r,Lcd_r}<= 6'b001010;
				3'b101:	
					{Lau_r,Lbu_r,Lcu_r,Lad_r,Lbd_r,Lcd_r}<= 6'b100010;
				default:					
					{Lau_r,Lbu_r,Lcu_r,Lad_r,Lbd_r,Lcd_r}<= 6'd0;	
			endcase
		else 
			case ({Ha,Hb,Hc})
				3'b100:
					{Lau_r,Lbu_r,Lcu_r,Lad_r,Lbd_r,Lcd_r}<= 6'b001100;
				3'b110:
					{Lau_r,Lbu_r,Lcu_r,Lad_r,Lbd_r,Lcd_r}<= 6'b001010;
				3'b010:
					{Lau_r,Lbu_r,Lcu_r,Lad_r,Lbd_r,Lcd_r}<= 6'b100010;
				3'b011:
					{Lau_r,Lbu_r,Lcu_r,Lad_r,Lbd_r,Lcd_r}<= 6'b100001;
				3'b001:
					{Lau_r,Lbu_r,Lcu_r,Lad_r,Lbd_r,Lcd_r}<= 6'b010001;
				3'b101:	
					{Lau_r,Lbu_r,Lcu_r,Lad_r,Lbd_r,Lcd_r}<= 6'b010100;
				default:					
					{Lau_r,Lbu_r,Lcu_r,Lad_r,Lbd_r,Lcd_r}<= 6'd0;	
		endcase
	end	
	assign error = {Lau_r,Lbu_r,Lcu_r,Lad_r,Lbd_r,Lcd_r}?0:1;		
	assign Lau = Lau_r & PWM_out;		
	assign Lbu = Lbu_r & PWM_out;
	assign Lcu = Lcu_r & PWM_out;
	assign Lad = Lad_r & PWM_out;
	assign Lbd = Lbd_r & PWM_out;
	assign Lcd = Lcd_r & PWM_out;
endmodule