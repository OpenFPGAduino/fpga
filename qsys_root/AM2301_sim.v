`timescale 1us/1us
module AM2301_sim;
	reg clk;
	reg reset;
	reg sda_in;
	reg [31:0] state;
	
	wire sda_out;   
	wire outclk;
	integer n;	
   AM2301 dut (
		.rsi_MRST_reset(reset),
		.csi_MCLK_clk(clk),
		// AM2301 interface
	   .clk_1us(outclk),
		//.avs_ctrl_readdata(state),
		.sda(sda_out),
		.sda_in(sda_in)
	);
	initial
	begin
	   clk <= 0;
	   reset<= 0;
	end
	initial     //test_start
	begin
	   #2 reset<=0;
	      clk<=1;
	   #2 clk<=0;  
	   #2 reset<=1;
	      clk<=1;			
		for (n = 0; n<= 20000; n = n + 1)
		begin    
			#0.5  clk <= 1'b0;
			#0.5  clk <= 1'b1;
		end
		$display( "All Test Complete." );
		$stop;
	end
	initial
	begin
			#0    sda_in <= 0;   
			#2000 sda_in <= 1;
			#10   sda_in <= 0;
			#80   sda_in <= 1;
			#80   sda_in <= 0;  //start

         #50   sda_in <= 1;  //bit 1 0
         #28   sda_in <= 0;

         #50   sda_in <= 1;  //bit 2 1
         #70   sda_in <= 0;
			
			#50   sda_in <= 1;  //bit 3 0
         #28   sda_in <= 0;

         #50   sda_in <= 1;  //bit 4 0
         #28   sda_in <= 0;
			
	      #50   sda_in <= 1;  //bit 5 1
         #70   sda_in <= 0;
			
	      #50   sda_in <= 1;  //bit 6 1
         #70   sda_in <= 0;
			
         #50   sda_in <= 1;  //bit 7 0
         #28   sda_in <= 0;

         #50   sda_in <= 1;  //bit 8 0
         #28   sda_in <= 0;
			
         #50   sda_in <= 1;  //bit 9 0
         #28   sda_in <= 0;
			
	      #50   sda_in <= 1;  //bit 10 1
         #70   sda_in <= 0;
			
	      #50   sda_in <= 1;  //bit 11 1
         #70   sda_in <= 0;
			
	      #50   sda_in <= 1;  //bit 12 1
         #70   sda_in <= 0;
			
	      #50   sda_in <= 1;  //bit 13 1
         #70   sda_in <= 0;
			
	      #50   sda_in <= 1;  //bit 14 1
         #70   sda_in <= 0;
			
			#50   sda_in <= 1;  //bit 15 0
         #28   sda_in <= 0;

         #50   sda_in <= 1;  //bit 16 1
         #70   sda_in <= 0;
			
			#50   sda_in <= 1;  //bit 17 0
         #28   sda_in <= 0;

         #50   sda_in <= 1;  //bit 18 0
         #28   sda_in <= 0;
			
	      #50   sda_in <= 1;  //bit 19 1
         #70   sda_in <= 0;
			
	      #50   sda_in <= 1;  //bit 20 1
         #70   sda_in <= 0;
			
         #50   sda_in <= 1;  //bit 21 0
         #28   sda_in <= 0;

         #50   sda_in <= 1;  //bit 22 0
         #28   sda_in <= 0;
			
         #50   sda_in <= 1;  //bit 23 0
         #28   sda_in <= 0;
			
	      #50   sda_in <= 1;  //bit 24 1
         #70   sda_in <= 0;
			
	      #50   sda_in <= 1;  //bit 25 1
         #70   sda_in <= 0;
			
	      #50   sda_in <= 1;  //bit 26 1
         #70   sda_in <= 0;
			
	      #50   sda_in <= 1;  //bit 27 1
         #70   sda_in <= 0;
			
	      #50   sda_in <= 1;  //bit 28 1
         #70   sda_in <= 0;
			
			#50   sda_in <= 1;  //bit 29 0
         #28   sda_in <= 0;
			
			#50   sda_in <= 1;  //bit 30 1
         #70   sda_in <= 0;	
			
			#50   sda_in <= 1;  //bit 31 0
         #28   sda_in <= 0;
			
			#50   sda_in <= 1;  //bit 32 0
         #28   sda_in <= 0;
	end	
endmodule 