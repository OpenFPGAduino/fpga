## Generated SDC file "XEM-S91-U6.sdc"

## Copyright (C) 1991-2011 Altera Corporation
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, Altera MegaCore Function License 
## Agreement, or other applicable license agreement, including, 
## without limitation, that your use is for the sole purpose of 
## programming logic devices manufactured by Altera and sold by 
## Altera or its authorized distributors.  Please refer to the 
## applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus II"
## VERSION "Version 10.0 Build 262 08/18/2010 SJ Full Version"

## DATE    "Wed Feb 1 00:00:01 2012"

##
## DEVICE  "EP4CE15F23C8"
##

#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3

#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {HPS_Clocks} -period 15.000 -waveform { 0.000 7.500 } [get_ports {M1_CLK M2_CLK0 M2_CLK1 ISI_MCLK}]
create_clock -name {LCD_Clock} -period 15.000 -waveform { 0.000 10.000 } [get_ports {LCD_PCLK}]
# create_clock -name {AC97_Clock} -period 40.000 -waveform { 0.000 20.000 } [get_ports {AUDIO_MCK}]
# create_clock -name {Internal_Test_1} -period 6.000 [get_clocks {frontier:inst|sht1x_sensor:sht1x_sensor_0|csi_MCLK_clk}]
# create_clock -name {Internal_Test_2} -period 6.000 [get_nets {frontier:inst|sht1x_sensor:sht1x_sensor_1|csi_MCLK_clk}]
create_generated_clock -divide_by 65536 -source [get_nets {inst|hps_tabby|m1_bus_pll_inst1|auto_generated|pll1|clk[0]}] \
-name {sht1x1_div_1} [get_nets {frontier:inst|sht1x_sensor:sht1x_sensor_0|temp[31]}]
create_generated_clock -divide_by 65536 -source [get_clocks {inst|hps_tabby|m1_bus_pll_inst1|auto_generated|pll1|clk[0]}] \
-name {sht1x1_div_2} [get_nets {frontier:inst|sht1x_sensor:sht1x_sensor_1|temp[31]}]



#**************************************************************
# Create Generated Clock
#**************************************************************
derive_pll_clocks
#derive_clocks

#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************
derive_clock_uncertainty


#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -clock HPS_Clocks -max 2 [all_inputs]
set_input_delay -clock HPS_Clocks -min 0 [all_inputs]

#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -clock HPS_Clocks 2 [all_outputs]

#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************

set_max_delay -from [get_clocks {inst|hps_tabby|m1_bus_pll_inst1|auto_generated|pll1|clk[0]}] -to [get_registers {frontier:inst|hps_tabby:hps_tabby|state[0] frontier:inst|hps_tabby:hps_tabby|state[1] frontier:inst|hps_tabby:hps_tabby|state[2] frontier:inst|hps_tabby:hps_tabby|state[3]}] 1

#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

