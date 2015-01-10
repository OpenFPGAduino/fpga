module sht1x_sensor(
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
		// sht1x interface
	   output sck, // 100khz 
		output dir,
		inout  sda
		
		);
		//Qsys interface
		reg      [31:0] read_data;
		reg      [31:0] write_data;
		reg      [15:0] temperature;
		reg      [15:0] moisture;
		
		wire     data_ready;
		assign	avs_ctrl_readdata = read_data;
//		assign   data_ready = (state==ready);
		always@(posedge csi_MCLK_clk or posedge rsi_MRST_reset)
		begin
			if(rsi_MRST_reset) begin
				read_data <= 0;
			end
			else if(avs_ctrl_write) 
			begin
				case(avs_ctrl_address)
					0: write_data <= avs_ctrl_writedata;
					default:;
				endcase	
			end
			else begin
				case(avs_ctrl_address)
					0: read_data <= 32;
					1: read_data <= 32'hEA680003;
					2: read_data <= {16'd0,temperature};
					3: read_data <= {16'd0,moisture};
					4: read_data <= {31'd0,data_ready};
					default: read_data <= 0;
				endcase
			end
		end
		
		wire sck_t;
		reg [31:0] temp;
		always @(posedge csi_MCLK_clk)
		begin
			temp <= temp + 32'd64585974/4/4/2;//for 133.33Mhz clk
		end
		assign sck_t = temp[31];
		
		reg [15:0] measure_date;
		reg [7:0]  crc;
		
		parameter 
	   Address = 3'b000,
		Measure_Temperature=5'b00011,
		Measure_Relative_Humidity=5'b00101,
		Read_Status_Register=5'b00111,
		Write_Status_Register=5'b00110;
		
		parameter dir_out = 1'b1;
		parameter dir_in  = 1'b0;
		reg  dir_r;
		reg  sda_r;
		reg  sck_r;
		wire sda_in;
		
		assign sda_in = sda;
		assign sda = dir_r ? sda_r : 1'bz;
		assign sck = sck_r;
		assign dir = dir_r;
	
		// the bus state machine of sh1x 
		parameter Reset_0 = 15'd0;
		parameter Reset_1 = Reset_0+1; 
		parameter Reset_2 = Reset_1+1;
		parameter Reset_3 = Reset_2+1;
		parameter Reset_4 = Reset_3+1;
		parameter Reset_5 = Reset_4+1;
		parameter Reset_6 = Reset_5+1;
		parameter Reset_7 = Reset_6+1;
		parameter Reset_8 = Reset_7+1;
		parameter Reset_9 = Reset_8+1;
	
		parameter Transmision_Start_0 = Reset_9+1;
		parameter Transmision_Start_1 = Transmision_Start_0+1; 
		parameter Transmision_Start_2 = Transmision_Start_1+1;
		parameter Transmision_Start_3 = Transmision_Start_2+1;
		parameter Transmision_Start_4 = Transmision_Start_3+1;
		parameter Transmision_Start_5 = Transmision_Start_4+1;
		parameter Transmision_Start_6 = Transmision_Start_5+1;
		parameter Transmision_Start_7 = Transmision_Start_6+1;
		
		parameter Command_0   = Transmision_Start_7+1;
		parameter Command_1   = Command_0+1;
		parameter Command_2   = Command_1+1;
		parameter Command_3   = Command_2+1;
		parameter Command_4   = Command_3+1;
	   parameter Command_5   = Command_4+1;
	   parameter Command_6   = Command_5+1;
		parameter Command_7   = Command_6+1;
		parameter Command_ack = Command_7+1;	
		
		parameter Measure_wait = Command_ack+1;
		
		parameter Date_0  = Measure_wait+1;
		parameter Date_1  = Date_0+1;
		parameter Date_2  = Date_1+1;
		parameter Date_3  = Date_2+1;
		parameter Date_4  =  Date_3 +1;
		parameter Date_5  =  Date_4 +1;
		parameter Date_6  =  Date_5 +1;
		parameter Date_7  =  Date_6 +1;
		parameter Date_ack_0 = Date_7+1;
		
		parameter Date_8   =  Date_ack_0 +1;
		parameter Date_9   =  Date_8 +1;
		parameter Date_10  =  Date_9 +1;
		parameter Date_11  =  Date_10 +1;
		parameter Date_12  =  Date_11 +1;
		parameter Date_13  =  Date_12 +1;
		parameter Date_14  =  Date_13 +1;
		parameter Date_15  =  Date_14+1;	
		parameter Date_ack_1 = Date_15+1;
		
		parameter Crc_0   = Date_ack_1+1;
		parameter Crc_1   = Crc_0+1;
		parameter Crc_2   = Crc_1+1;
		parameter Crc_3   = Crc_2+1;
		parameter Crc_4   = Crc_3+1;
		parameter Crc_5   = Crc_4+1;
		parameter Crc_6   = Crc_5+1;
		parameter Crc_7   = Crc_6+1;
		parameter Crc_ack = Crc_7+1;
		
		parameter check_sum = Crc_ack+1;
		parameter measure_update = check_sum+1;
		parameter measure_end = measure_update+1;
		
		reg [14:0]state;
		reg [14:0]next_state;
		reg [15:0]time_out;
		reg [7:0] command_reg;
		always @ (posedge sck_t)
		begin
			if(rsi_MRST_reset) begin
				state <= Reset_0;
			end else	begin
				state <= next_state;
			end
		end
		
		reg temp_moist; 
		
		always @ (state or sda_in or time_out or sck_t)
		begin
			if(state < Transmision_Start_0) begin
				next_state = state + 1;
				sck_r = !sck_t;
				sda_r = 1'b1;
				dir_r = dir_out;
			end
			else
			case(state)
			Transmision_Start_0: begin
				next_state = Transmision_Start_1;
				sck_r = 1'b1;
				sda_r = 1'b1;
				dir_r = dir_out;
			end
			Transmision_Start_1: begin
				next_state = Transmision_Start_2;
				sck_r = 1'b1;
				sda_r = 1'b0;
				dir_r = dir_out;
			end
			Transmision_Start_2: begin
				next_state = Transmision_Start_3;
				sck_r = 1'b0;
				sda_r = 1'b0;
				dir_r = dir_out;				
			end
			Transmision_Start_3: begin
				next_state = Transmision_Start_4;
				sck_r = 1'b1;
				sda_r = 1'b0;
				dir_r = dir_out;
			end
			Transmision_Start_4: begin
				next_state = Transmision_Start_5;
				sck_r = 1'b1;
				sda_r = 1'b1;
				dir_r = dir_out;
			end
			Transmision_Start_5: begin
				next_state = Transmision_Start_6;
				sck_r = 1'b0;
				sda_r = 1'b1;
				dir_r = dir_out;				
			end
			Transmision_Start_6: begin
				next_state = Transmision_Start_7;
				sck_r = 1'b0;
				sda_r = 1'b1;
				dir_r = dir_out;			
			end
			Transmision_Start_7: begin
				next_state = Command_0;
				sck_r = 1'b0;
				sda_r = 1'b0;
				dir_r = dir_out;			
				if (temp_moist == 0) 
					command_reg	= {Address,Measure_Temperature};
				else
					command_reg	= {Address,Measure_Relative_Humidity};
			end
			Command_0: begin
				next_state = Command_1;
				sck_r = !sck_t;
				sda_r = command_reg[7];
				dir_r = dir_out;	
			end
			Command_1: begin
				next_state = Command_2;
				sck_r = !sck_t;
				sda_r = command_reg[6];
				dir_r = dir_out;	
			end
			Command_2: begin
				next_state = Command_3;
				sck_r = !sck_t;
				sda_r = command_reg[5];
				dir_r = dir_out;	
			end
			Command_3: begin
				next_state = Command_4;
				sck_r = !sck_t;
				sda_r = command_reg[4];
				dir_r = dir_out;	
			end
			Command_4: begin
				next_state = Command_5;
				sck_r = !sck_t;
				sda_r = command_reg[3];
				dir_r = dir_out;	
			end
			Command_5: begin
				next_state <= Command_6;
				sck_r = !sck_t;
				sda_r = command_reg[2];
				dir_r = dir_out;	
			end
			Command_6: begin
				next_state = Command_7;
				sck_r = !sck_t;
				sda_r = command_reg[1];
				dir_r = dir_out;	
			end
			Command_7: begin
				next_state = Command_ack;
				sck_r = !sck_t;
				sda_r = command_reg[0];
				dir_r = dir_out;	
			end
			Command_ack: begin
				dir_r = dir_in;
				sck_r = !sck_t;
				if(time_out > 16'd20)
					next_state = Reset_0;
				else if( sda_in == 1'b1)
					next_state = Command_ack;	
				else
					next_state = Measure_wait;
			end
			Measure_wait: begin
				dir_r = dir_in;
				sck_r = 0;
				if(time_out > 16'd5000)
					next_state = Reset_0;
				else if( sda_in == 1'b1)
					next_state = Measure_wait;
				else			
					next_state = Date_0;			
			end
			Date_0: begin
				dir_r = dir_in;
				sck_r = !sck_t;
				next_state = Date_1;				
			end
			Date_1: begin
				dir_r = dir_in;
				sck_r = !sck_t;
				next_state = Date_2;				
			end	
			Date_2: begin
				dir_r = dir_in;
				sck_r = !sck_t;
				next_state = Date_3;				
			end	
			Date_3: begin
				dir_r = dir_in;
				sck_r = !sck_t;
				next_state = Date_4;				
			end	
			Date_4: begin
				dir_r = dir_in;
				sck_r = !sck_t;
				next_state = Date_5;				
			end	
			Date_5: begin
				dir_r = dir_in;
				sck_r = !sck_t;
				next_state = Date_6;				
			end	
			Date_6: begin
				dir_r = dir_in;
				sck_r = !sck_t;
				next_state = Date_7;				
			end	
			Date_7: begin
				dir_r = dir_in;
				sck_r = !sck_t;
				next_state = Date_ack_0;				
			end	
			Date_ack_0: begin
				dir_r = dir_out;
				sck_r = !sck_t;
				sda_r = 1'b0;
				next_state = Date_8;
			end
			Date_8: begin
				dir_r = dir_in;
				sck_r = !sck_t;
				next_state = Date_9;				
			end	
			Date_9: begin
				dir_r = dir_in;
				sck_r = !sck_t;
				next_state = Date_10;				
			end	
			Date_10: begin
				dir_r = dir_in;
				sck_r = !sck_t;
				next_state = Date_11;				
			end
			Date_11: begin
				dir_r = dir_in;
				sck_r = !sck_t;
				next_state = Date_12;				
			end	
			Date_12: begin
				dir_r = dir_in;
				sck_r = !sck_t;
				next_state = Date_13;				
			end	
			Date_13: begin
				dir_r = dir_in;
				sck_r = !sck_t;
				next_state = Date_14;				
			end	
			Date_14: begin
				dir_r = dir_in;
				sck_r = !sck_t;
				next_state = Date_15;				
			end				
			Date_15: begin
				dir_r = dir_in;
				sck_r = !sck_t;
				next_state = Date_ack_1;				
			end	
			Date_ack_1: begin
				dir_r = dir_out;
				sck_r = !sck_t;
				sda_r = 1'b0;
				next_state = Crc_0;				
			end
			Crc_0: begin
				dir_r = dir_in;
				sck_r = !sck_t;
				next_state = Crc_1;				
			end		
			Crc_1: begin
				dir_r = dir_in;
				sck_r = !sck_t;
				next_state = Crc_2;				
			end		
			Crc_2: begin
				dir_r = dir_in;
				sck_r = !sck_t;
				next_state = Crc_3;				
			end		
			Crc_3: begin
				dir_r = dir_in;
				sck_r = !sck_t;
				next_state = Crc_4;				
			end
			Crc_4: begin
				dir_r = dir_in;
				sck_r = !sck_t;
				next_state = Crc_5;				
			end		
			Crc_5: begin
				dir_r = dir_in;
				sck_r = !sck_t;
				next_state = Crc_6;				
			end	
			Crc_6: begin
				dir_r = dir_in;
				sck_r = !sck_t;
				next_state = Crc_7;				
			end	
			Crc_7: begin
				dir_r = dir_in;
				sck_r = !sck_t;
				next_state = Crc_ack;				
			end			
			Crc_ack: begin
				dir_r = dir_out;
				sck_r = !sck_t;
				sda_r = 1'b1;
				next_state = check_sum;				
			end	
			check_sum: begin
				next_state = measure_update;		
			end
		   measure_update: begin
				next_state = measure_end;		
			end	
			measure_end: begin
				next_state = state+1;
			end
			default: begin
				next_state = state+1;
				sck_r = 0;
				//sck_r = !sck_t;
				dir_r = dir_in;
			end
			endcase
		end
		
		always @ (posedge sck_t)
		begin
			case(state)
			Command_ack:
				time_out <= time_out+1;
//			Measure_wait:
//				time_out <= time_out+1;
			Date_ack_0:
				time_out <= time_out+1;
			default:
				time_out <= 0;
			endcase
		end
		
		always @ (posedge sck_t)
		begin
			case (state)
			Date_0: begin
				measure_date[15]<=sda_in;
			end
			Date_1: begin
				measure_date[14]<=sda_in;
			end	
			Date_2: begin
				measure_date[13]<=sda_in;
			end	
			Date_3: begin
				measure_date[12]<=sda_in;			
			end	
			Date_4: begin
				measure_date[11]<=sda_in;		
			end	
			Date_5: begin
				measure_date[10]<=sda_in;		
			end	
			Date_6: begin
				measure_date[9]<=sda_in;				
			end	
			Date_7: begin
				measure_date[8]<=sda_in;				
			end	
			Date_8: begin
				measure_date[7]<=sda_in;		
			end	
			Date_9: begin
				measure_date[6]<=sda_in;			
			end	
			Date_10: begin
				measure_date[5]<=sda_in;		
			end	
			Date_11: begin
				measure_date[4]<=sda_in;		
			end	
			Date_12: begin
				measure_date[3]<=sda_in;		
			end					
			Date_13: begin
				measure_date[2]<=sda_in;		
			end					
			Date_14: begin
				measure_date[1]<=sda_in;		
			end					
			Date_15: begin
				measure_date[0]<=sda_in;		
			end	
			Crc_0: begin
				crc[7]<=sda_in;		
			end	
			Crc_1: begin
				crc[6]<=sda_in;		
			end	
			Crc_2: begin
				crc[5]<=sda_in;		
			end	
			Crc_3: begin
				crc[4]<=sda_in;		
			end	
			Crc_4: begin
				crc[3]<=sda_in;		
			end	
			Crc_5: begin
				crc[2]<=sda_in;		
			end	
			Crc_6: begin
				crc[1]<=sda_in;		
			end	
			Crc_7: begin
				crc[0]<=sda_in;	
			end
			measure_update: begin
			if(temp_moist == 0)
				temperature <= measure_date;
			else
				moisture <= measure_date;
			end
			measure_end: begin
				temp_moist<=!temp_moist;	
			end				
			endcase
		end
		
endmodule