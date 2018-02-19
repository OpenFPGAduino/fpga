module frequent_measure(
		// Qsys bus interface	
		input					rsi_MRST_reset,
		input					csi_MCLK_clk,
		input		[7:0]	   avs_ctrl_writedata,
		output	[7:0]	   avs_ctrl_readdata,
		input		[3:0]		avs_ctrl_address,
		input					avs_ctrl_write,
		input					avs_ctrl_read,
		
		//brushless_moter_interface		
		input frequent	
		);
		wire clk;
		wire gate;
		assign clk = csi_MCLK_clk;
		reg [31:0] tempgate;
		always@(posedge clk)				
			tempgate<=tempgate+107/2;//4294967296/system_clk/2*gate_time;			
		assign gate=tempgate[31];
		
		wire f1;
		wire f2;
		reg temp;
		assign f1=frequent & temp;
		assign f2=clk &  temp;
		always@(posedge frequent)
			temp<=gate;
		reg reset;
		reg ready;
		reg [7:0]state;												
		reg [7:0]nextstate;	
		always@(posedge clk or posedge reset) 
			if(reset)state<=1;
			else state<=nextstate;
		always@(state or temp)
		begin
			case(state)
			1:if(temp==0)nextstate=2;else nextstate=1;	
			2:if(temp==1)nextstate=3;else nextstate=2;  
			3:if(temp==0)nextstate=4;else nextstate=3;
			4:nextstate=4;							
			endcase
		end
		
		reg [31:0]a;
		reg [31:0]b;
		always @ (posedge f1 or posedge reset)
			if(reset)a<=0;
			else if(state==4)a<=a;						
			else a<=a+1;			
		always @ (posedge f2 or posedge reset)
			if(reset)b<=0;
			else if(state==4)b<=b;
			else b<=b+1;
		
		always@(posedge clk)
			if(state==4)ready<=1;
			else ready<=0;
				
		reg [7:0] read_data;
		assign	avs_ctrl_readdata = read_data;
		always@(posedge csi_MCLK_clk or posedge rsi_MRST_reset)
		begin
			if(rsi_MRST_reset) begin
				read_data <= 0;
			end
			else if(avs_ctrl_write) 
			begin
				case(avs_ctrl_address)
					0: reset <= avs_ctrl_writedata[0];	
					default:;
				endcase
			end
			else begin
				case(avs_ctrl_address)
					0:read_data<= reset;
					1:read_data<= ready;
					2:read_data<=a[7:0];
					3:read_data<=a[15:8];
					4:read_data<=a[23:16];
					5:read_data<=a[31:24];
					6:read_data<=b[7:0];
					7:read_data<=b[15:8];
					8:read_data<=b[23:16];
					9:read_data<=b[31:24];
					default: read_data <= 8'b0;
				endcase
			end
		end		
endmodule 