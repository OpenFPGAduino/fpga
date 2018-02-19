# TCL File Generated by Component Editor 12.1sp1
# Mon Feb 19 11:54:36 CST 2018
# DO NOT MODIFY


# 
# motor_speed_measurement "motor_speed_measurement" v1.0
# Zhizhou Li 2018.02.19.11:54:36
# 
# 

# 
# request TCL package from ACDS 12.1
# 
package require -exact qsys 12.1


# 
# module motor_speed_measurement
# 
set_module_property NAME motor_speed_measurement
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP Lophilo
set_module_property AUTHOR "Zhizhou Li"
set_module_property DISPLAY_NAME motor_speed_measurement
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property ANALYZE_HDL AUTO
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL motor_speed_measurement
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
add_fileset_file motor_speed_measurement.v VERILOG PATH qsys_root/motor_speed_measurement.v

add_fileset SIM_VERILOG SIM_VERILOG "" ""
set_fileset_property SIM_VERILOG TOP_LEVEL motor_speed_measurement
set_fileset_property SIM_VERILOG ENABLE_RELATIVE_INCLUDE_PATHS false
add_fileset_file motor_speed_measurement.v VERILOG PATH qsys_root/motor_speed_measurement.v


# 
# parameters
# 


# 
# display items
# 


# 
# connection point mrst
# 
add_interface mrst reset end
set_interface_property mrst associatedClock mclk
set_interface_property mrst synchronousEdges DEASSERT
set_interface_property mrst ENABLED true

add_interface_port mrst rsi_MRST_reset reset Input 1


# 
# connection point mclk
# 
add_interface mclk clock end
set_interface_property mclk clockRate 0
set_interface_property mclk ENABLED true

add_interface_port mclk csi_MCLK_clk clk Input 1


# 
# connection point ctrl
# 
add_interface ctrl avalon end
set_interface_property ctrl addressUnits WORDS
set_interface_property ctrl associatedClock mclk
set_interface_property ctrl associatedReset mrst
set_interface_property ctrl bitsPerSymbol 8
set_interface_property ctrl burstOnBurstBoundariesOnly false
set_interface_property ctrl burstcountUnits WORDS
set_interface_property ctrl explicitAddressSpan 0
set_interface_property ctrl holdTime 0
set_interface_property ctrl linewrapBursts false
set_interface_property ctrl maximumPendingReadTransactions 0
set_interface_property ctrl readLatency 0
set_interface_property ctrl readWaitTime 1
set_interface_property ctrl setupTime 0
set_interface_property ctrl timingUnits Cycles
set_interface_property ctrl writeWaitTime 0
set_interface_property ctrl ENABLED true

add_interface_port ctrl avs_ctrl_writedata writedata Input 32
add_interface_port ctrl avs_ctrl_readdata readdata Output 32
add_interface_port ctrl avs_ctrl_byteenable byteenable Input 4
add_interface_port ctrl avs_ctrl_address address Input 3
add_interface_port ctrl avs_ctrl_write write Input 1
add_interface_port ctrl avs_ctrl_read read Input 1
add_interface_port ctrl avs_ctrl_waitrequest waitrequest Output 1
set_interface_assignment ctrl embeddedsw.configuration.isFlash 0
set_interface_assignment ctrl embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment ctrl embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment ctrl embeddedsw.configuration.isPrintableDevice 0


# 
# connection point pwmrst
# 
add_interface pwmrst reset end
set_interface_property pwmrst associatedClock pwmclk
set_interface_property pwmrst synchronousEdges DEASSERT
set_interface_property pwmrst ENABLED true

add_interface_port pwmrst rsi_PWMRST_reset reset Input 1


# 
# connection point pwmclk
# 
add_interface pwmclk clock end
set_interface_property pwmclk clockRate 0
set_interface_property pwmclk ENABLED true

add_interface_port pwmclk csi_PWMCLK_clk clk Input 1


# 
# connection point conduit_end
# 
add_interface conduit_end conduit end
set_interface_property conduit_end associatedClock mclk
set_interface_property conduit_end associatedReset mrst
set_interface_property conduit_end ENABLED true

add_interface_port conduit_end frequent export Input 1

