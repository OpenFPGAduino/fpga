package require -exact qsys 12.0
# module properties ('module' here means 'system' or 'top level module')
set_module_property NAME {frontier}

# project properties
set_project_property DEVICE_FAMILY {Cyclone IV E}

# instances and instance parameters
add_instance HPS_tabby hps_tabby 1.1

add_instance basic_SysID basic_SysID 1.0
set_instance_parameter_value basic_SysID AUTO_MCLK_CLOCK_RATE {133333333.0}

add_instance basic_FuncLED_0 basic_FuncLED 1.0
set_instance_parameter_value basic_FuncLED_0 AUTO_MCLK_CLOCK_RATE {133333333.0}

add_instance basic_FuncLED_1 basic_FuncLED 1.0
set_instance_parameter_value basic_FuncLED_1 AUTO_MCLK_CLOCK_RATE {133333333.0}

add_instance basic_FuncLED_2 basic_FuncLED 1.0
set_instance_parameter_value basic_FuncLED_2 AUTO_MCLK_CLOCK_RATE {133333333.0}

add_instance basic_FuncLED_3 basic_FuncLED 1.0
set_instance_parameter_value basic_FuncLED_3 AUTO_MCLK_CLOCK_RATE {133333333.0}

add_instance basic_ShieldCtrl basic_ShieldCtrl 1.0
set_instance_parameter_value basic_ShieldCtrl AUTO_MCLK_CLOCK_RATE {133333333.0}

add_instance test_LEDState test_LEDState 1.0
set_instance_parameter_value test_LEDState AUTO_MCLK_CLOCK_RATE {133333333.0}

add_instance grid_PIO26_A grid_PIO26 1.0
set_instance_parameter_value grid_PIO26_A AUTO_MCLK_CLOCK_RATE {133333333.0}

add_instance grid_PIO26_B grid_PIO26 1.0
set_instance_parameter_value grid_PIO26_B AUTO_MCLK_CLOCK_RATE {133333333.0}

add_instance grid_PWM_0 grid_PWM 1.0
set_instance_parameter_value grid_PWM_0 AUTO_MCLK_CLOCK_RATE {133333333.0}
set_instance_parameter_value grid_PWM_0 AUTO_PWMCLK_CLOCK_RATE {200000000.0}

add_instance step_motor_driver_0 step_motor_driver 1.0
set_instance_parameter_value step_motor_driver_0 AUTO_MCLK_CLOCK_RATE {133333333.0}
set_instance_parameter_value step_motor_driver_0 AUTO_PWMCLK_CLOCK_RATE {200000000.0}

add_instance brush_motor_driver_0 brush_motor_driver 1.0
set_instance_parameter_value brush_motor_driver_0 AUTO_MCLK_CLOCK_RATE {133333333.0}
set_instance_parameter_value brush_motor_driver_0 AUTO_PWMCLK_CLOCK_RATE {200000000.0}

add_instance position_encoder_0 position_encoder 1.0
set_instance_parameter_value position_encoder_0 AUTO_MCLK_CLOCK_RATE {133333333.0}

add_instance fan_motor_driver_0 fan_motor_driver 1.0
set_instance_parameter_value fan_motor_driver_0 AUTO_MCLK_CLOCK_RATE {133333333.0}
set_instance_parameter_value fan_motor_driver_0 AUTO_PWMCLK_CLOCK_RATE {200000000.0}

add_instance step_motor_driver_1 step_motor_driver 1.0
set_instance_parameter_value step_motor_driver_1 AUTO_MCLK_CLOCK_RATE {133333333.0}
set_instance_parameter_value step_motor_driver_1 AUTO_PWMCLK_CLOCK_RATE {200000000.0}

add_instance brush_motor_driver_1 brush_motor_driver 1.0
set_instance_parameter_value brush_motor_driver_1 AUTO_MCLK_CLOCK_RATE {133333333.0}
set_instance_parameter_value brush_motor_driver_1 AUTO_PWMCLK_CLOCK_RATE {200000000.0}

add_instance brush_motor_driver_2 brush_motor_driver 1.0
set_instance_parameter_value brush_motor_driver_2 AUTO_MCLK_CLOCK_RATE {133333333.0}
set_instance_parameter_value brush_motor_driver_2 AUTO_PWMCLK_CLOCK_RATE {200000000.0}

add_instance brush_motor_driver_3 brush_motor_driver 1.0
set_instance_parameter_value brush_motor_driver_3 AUTO_MCLK_CLOCK_RATE {133333333.0}
set_instance_parameter_value brush_motor_driver_3 AUTO_PWMCLK_CLOCK_RATE {200000000.0}

add_instance step_motor_driver_2 step_motor_driver 1.0
set_instance_parameter_value step_motor_driver_2 AUTO_MCLK_CLOCK_RATE {133333333.0}
set_instance_parameter_value step_motor_driver_2 AUTO_PWMCLK_CLOCK_RATE {200000000.0}

add_instance step_motor_driver_3 step_motor_driver 1.0
set_instance_parameter_value step_motor_driver_3 AUTO_MCLK_CLOCK_RATE {133333333.0}
set_instance_parameter_value step_motor_driver_3 AUTO_PWMCLK_CLOCK_RATE {200000000.0}

add_instance step_motor_driver_4 step_motor_driver 1.0
set_instance_parameter_value step_motor_driver_4 AUTO_MCLK_CLOCK_RATE {133333333.0}
set_instance_parameter_value step_motor_driver_4 AUTO_PWMCLK_CLOCK_RATE {200000000.0}

add_instance position_encoder_1 position_encoder 1.0
set_instance_parameter_value position_encoder_1 AUTO_MCLK_CLOCK_RATE {133333333.0}

add_instance position_encoder_2 position_encoder 1.0
set_instance_parameter_value position_encoder_2 AUTO_MCLK_CLOCK_RATE {133333333.0}

add_instance position_encoder_3 position_encoder 1.0
set_instance_parameter_value position_encoder_3 AUTO_MCLK_CLOCK_RATE {133333333.0}

add_instance fan_motor_driver_1 fan_motor_driver 1.0
set_instance_parameter_value fan_motor_driver_1 AUTO_MCLK_CLOCK_RATE {133333333.0}
set_instance_parameter_value fan_motor_driver_1 AUTO_PWMCLK_CLOCK_RATE {200000000.0}

add_instance subdivision_step_motor_driver_0 subdivision_step_motor_driver 1.0
set_instance_parameter_value subdivision_step_motor_driver_0 AUTO_MCLK_CLOCK_RATE {133333333.0}
set_instance_parameter_value subdivision_step_motor_driver_0 AUTO_PWMCLK_CLOCK_RATE {133333333.0}

add_instance grid_PWM_1 grid_PWM 1.0
set_instance_parameter_value grid_PWM_1 AUTO_MCLK_CLOCK_RATE {133333333.0}
set_instance_parameter_value grid_PWM_1 AUTO_PWMCLK_CLOCK_RATE {133333333.0}

add_instance grid_PWM_2 grid_PWM 1.0
set_instance_parameter_value grid_PWM_2 AUTO_MCLK_CLOCK_RATE {133333333.0}
set_instance_parameter_value grid_PWM_2 AUTO_PWMCLK_CLOCK_RATE {133333333.0}

add_instance ARM9_soft_core_0 ARM9_soft_core 1.0

add_instance AD7490_0 AD7490 1.0
set_instance_parameter_value AD7490_0 AUTO_MCLK_CLOCK_RATE {133333333.0}
set_instance_parameter_value AD7490_0 AUTO_ADCCLK_CLOCK_RATE {200000000.0}

# connections and connection parameters
add_connection HPS_tabby.MRST basic_SysID.MRST

add_connection HPS_tabby.MCLK basic_SysID.MCLK

add_connection HPS_tabby.M1 basic_SysID.SysID
set_connection_parameter_value HPS_tabby.M1/basic_SysID.SysID arbitrationPriority {1}
set_connection_parameter_value HPS_tabby.M1/basic_SysID.SysID baseAddress {0x10000000}

add_connection HPS_tabby.MRST basic_FuncLED_0.MRST

add_connection HPS_tabby.MCLK basic_FuncLED_0.MCLK

add_connection HPS_tabby.M1 basic_FuncLED_0.ctrl
set_connection_parameter_value HPS_tabby.M1/basic_FuncLED_0.ctrl arbitrationPriority {1}
set_connection_parameter_value HPS_tabby.M1/basic_FuncLED_0.ctrl baseAddress {0x10000100}

add_connection HPS_tabby.MRST basic_FuncLED_1.MRST

add_connection HPS_tabby.MCLK basic_FuncLED_1.MCLK

add_connection HPS_tabby.M1 basic_FuncLED_1.ctrl
set_connection_parameter_value HPS_tabby.M1/basic_FuncLED_1.ctrl arbitrationPriority {1}
set_connection_parameter_value HPS_tabby.M1/basic_FuncLED_1.ctrl baseAddress {0x10000104}

add_connection HPS_tabby.MRST basic_FuncLED_2.MRST

add_connection HPS_tabby.MCLK basic_FuncLED_2.MCLK

add_connection HPS_tabby.M1 basic_FuncLED_2.ctrl
set_connection_parameter_value HPS_tabby.M1/basic_FuncLED_2.ctrl arbitrationPriority {1}
set_connection_parameter_value HPS_tabby.M1/basic_FuncLED_2.ctrl baseAddress {0x10000108}

add_connection HPS_tabby.MRST basic_FuncLED_3.MRST

add_connection HPS_tabby.MCLK basic_FuncLED_3.MCLK

add_connection HPS_tabby.M1 basic_FuncLED_3.ctrl
set_connection_parameter_value HPS_tabby.M1/basic_FuncLED_3.ctrl arbitrationPriority {1}
set_connection_parameter_value HPS_tabby.M1/basic_FuncLED_3.ctrl baseAddress {0x1000010c}

add_connection HPS_tabby.MRST basic_ShieldCtrl.MRST

add_connection HPS_tabby.MCLK basic_ShieldCtrl.MCLK

add_connection HPS_tabby.M1 basic_ShieldCtrl.ctrl
set_connection_parameter_value HPS_tabby.M1/basic_ShieldCtrl.ctrl arbitrationPriority {1}
set_connection_parameter_value HPS_tabby.M1/basic_ShieldCtrl.ctrl baseAddress {0x10000200}

add_connection HPS_tabby.EVENTS basic_ShieldCtrl.OC
set_connection_parameter_value HPS_tabby.EVENTS/basic_ShieldCtrl.OC irqNumber {0}

add_connection HPS_tabby.MRST test_LEDState.MRST

add_connection HPS_tabby.MCLK test_LEDState.MCLK

add_connection test_LEDState.fled1 basic_FuncLED_1.ledf

add_connection test_LEDState.fled2 basic_FuncLED_2.ledf

add_connection test_LEDState.fled3 basic_FuncLED_3.ledf

add_connection HPS_tabby.MRST grid_PIO26_A.MRST

add_connection HPS_tabby.MCLK grid_PIO26_A.MCLK

add_connection HPS_tabby.M1 grid_PIO26_A.gpio
set_connection_parameter_value HPS_tabby.M1/grid_PIO26_A.gpio arbitrationPriority {1}
set_connection_parameter_value HPS_tabby.M1/grid_PIO26_A.gpio baseAddress {0x20000000}

add_connection HPS_tabby.MRST grid_PIO26_B.MRST

add_connection HPS_tabby.MCLK grid_PIO26_B.MCLK

add_connection HPS_tabby.M1 grid_PIO26_B.gpio
set_connection_parameter_value HPS_tabby.M1/grid_PIO26_B.gpio arbitrationPriority {1}
set_connection_parameter_value HPS_tabby.M1/grid_PIO26_B.gpio baseAddress {0x20000080}

add_connection HPS_tabby.EVENTS grid_PIO26_A.gpint
set_connection_parameter_value HPS_tabby.EVENTS/grid_PIO26_A.gpint irqNumber {1}

add_connection HPS_tabby.EVENTS grid_PIO26_B.gpint
set_connection_parameter_value HPS_tabby.EVENTS/grid_PIO26_B.gpint irqNumber {2}

add_connection HPS_tabby.MRST grid_PWM_0.MRST

add_connection HPS_tabby.MCLK grid_PWM_0.MCLK

add_connection HPS_tabby.H2CLK grid_PWM_0.PWMCLK

add_connection HPS_tabby.MRST grid_PWM_0.PWMRST

add_connection HPS_tabby.M1 grid_PWM_0.pwm
set_connection_parameter_value HPS_tabby.M1/grid_PWM_0.pwm arbitrationPriority {1}
set_connection_parameter_value HPS_tabby.M1/grid_PWM_0.pwm baseAddress {0x20000100}

add_connection HPS_tabby.MRST step_motor_driver_0.MRST

add_connection HPS_tabby.MCLK step_motor_driver_0.MCLK

add_connection HPS_tabby.H2CLK step_motor_driver_0.PWMCLK

add_connection HPS_tabby.MRST step_motor_driver_0.PWMRST

add_connection HPS_tabby.M1 step_motor_driver_0.ctrl
set_connection_parameter_value HPS_tabby.M1/step_motor_driver_0.ctrl arbitrationPriority {1}
set_connection_parameter_value HPS_tabby.M1/step_motor_driver_0.ctrl baseAddress {0x10000260}

add_connection HPS_tabby.MRST step_motor_driver_1.MRST

add_connection HPS_tabby.MCLK step_motor_driver_1.MCLK

add_connection HPS_tabby.M1 step_motor_driver_1.ctrl
set_connection_parameter_value HPS_tabby.M1/step_motor_driver_1.ctrl arbitrationPriority {1}
set_connection_parameter_value HPS_tabby.M1/step_motor_driver_1.ctrl baseAddress {0x10000280}

add_connection HPS_tabby.MRST step_motor_driver_1.PWMRST

add_connection HPS_tabby.H2CLK step_motor_driver_1.PWMCLK

add_connection HPS_tabby.MRST step_motor_driver_2.MRST

add_connection HPS_tabby.M1 step_motor_driver_2.ctrl
set_connection_parameter_value HPS_tabby.M1/step_motor_driver_2.ctrl arbitrationPriority {1}
set_connection_parameter_value HPS_tabby.M1/step_motor_driver_2.ctrl baseAddress {0x100002a0}

add_connection HPS_tabby.MRST step_motor_driver_2.PWMRST

add_connection HPS_tabby.MCLK step_motor_driver_2.MCLK

add_connection HPS_tabby.H2CLK step_motor_driver_2.PWMCLK

add_connection HPS_tabby.MRST step_motor_driver_3.MRST

add_connection HPS_tabby.MCLK step_motor_driver_3.MCLK

add_connection HPS_tabby.M1 step_motor_driver_3.ctrl
set_connection_parameter_value HPS_tabby.M1/step_motor_driver_3.ctrl arbitrationPriority {1}
set_connection_parameter_value HPS_tabby.M1/step_motor_driver_3.ctrl baseAddress {0x100002c0}

add_connection HPS_tabby.MRST step_motor_driver_3.PWMRST

add_connection HPS_tabby.H2CLK step_motor_driver_3.PWMCLK

add_connection HPS_tabby.MRST step_motor_driver_4.MRST

add_connection HPS_tabby.M1 step_motor_driver_4.ctrl
set_connection_parameter_value HPS_tabby.M1/step_motor_driver_4.ctrl arbitrationPriority {1}
set_connection_parameter_value HPS_tabby.M1/step_motor_driver_4.ctrl baseAddress {0x100002e0}

add_connection HPS_tabby.MCLK step_motor_driver_4.MCLK

add_connection HPS_tabby.MRST step_motor_driver_4.PWMRST

add_connection HPS_tabby.H2CLK step_motor_driver_4.PWMCLK

add_connection HPS_tabby.MRST grid_PWM_2.MRST

add_connection HPS_tabby.MRST grid_PWM_2.PWMRST

add_connection HPS_tabby.MCLK grid_PWM_2.MCLK

add_connection HPS_tabby.MRST grid_PWM_1.MRST

add_connection HPS_tabby.MRST grid_PWM_1.PWMRST

add_connection HPS_tabby.MCLK grid_PWM_1.PWMCLK

add_connection HPS_tabby.MCLK grid_PWM_1.MCLK

add_connection HPS_tabby.MCLK grid_PWM_2.PWMCLK

add_connection ARM9_soft_core_0.m1 grid_PWM_2.pwm
set_connection_parameter_value ARM9_soft_core_0.m1/grid_PWM_2.pwm arbitrationPriority {1}
set_connection_parameter_value ARM9_soft_core_0.m1/grid_PWM_2.pwm baseAddress {0x21000000}

add_connection ARM9_soft_core_0.m1 grid_PWM_1.pwm
set_connection_parameter_value ARM9_soft_core_0.m1/grid_PWM_1.pwm arbitrationPriority {1}
set_connection_parameter_value ARM9_soft_core_0.m1/grid_PWM_1.pwm baseAddress {0x22000000}

add_connection HPS_tabby.MRST AD7490_0.mrst

add_connection HPS_tabby.MCLK AD7490_0.mclk

add_connection HPS_tabby.H2CLK AD7490_0.adcclk

add_connection HPS_tabby.M1 AD7490_0.ctrl
set_connection_parameter_value HPS_tabby.M1/AD7490_0.ctrl arbitrationPriority {1}
set_connection_parameter_value HPS_tabby.M1/AD7490_0.ctrl baseAddress {0x30000000}

# exported interfaces
add_interface m0 conduit end
set_interface_property m0 EXPORT_OF HPS_tabby.EXPORT
add_interface led_f0 conduit end
set_interface_property led_f0 EXPORT_OF basic_FuncLED_0.EXPORT
add_interface led_f1 conduit end
set_interface_property led_f1 EXPORT_OF basic_FuncLED_1.EXPORT
add_interface led_f2 conduit end
set_interface_property led_f2 EXPORT_OF basic_FuncLED_2.EXPORT
add_interface led_f3 conduit end
set_interface_property led_f3 EXPORT_OF basic_FuncLED_3.EXPORT
add_interface shield_ctrl conduit end
set_interface_property shield_ctrl EXPORT_OF basic_ShieldCtrl.EXPORT
add_interface slot_a conduit end
set_interface_property slot_a EXPORT_OF grid_PIO26_A.EXPORT
add_interface slot_b conduit end
set_interface_property slot_b EXPORT_OF grid_PIO26_B.EXPORT
add_interface pwm_c0 conduit end
set_interface_property pwm_c0 EXPORT_OF grid_PWM_0.EXPORT
add_interface step_motor_driver_0 conduit end
set_interface_property step_motor_driver_0 EXPORT_OF step_motor_driver_0.step_motor
add_interface step_motor_driver_1 conduit end
set_interface_property step_motor_driver_1 EXPORT_OF step_motor_driver_1.step_motor
add_interface step_motor_driver_2 conduit end
set_interface_property step_motor_driver_2 EXPORT_OF step_motor_driver_2.step_motor
add_interface step_motor_driver_3 conduit end
set_interface_property step_motor_driver_3 EXPORT_OF step_motor_driver_3.step_motor
add_interface step_motor_driver_4 conduit end
set_interface_property step_motor_driver_4 EXPORT_OF step_motor_driver_4.step_motor
add_interface m1 conduit end
set_interface_property m1 EXPORT_OF ARM9_soft_core_0.ctrl
add_interface ad7490_0 conduit end
set_interface_property ad7490_0 EXPORT_OF AD7490_0.ADC

# disabled instances
set_instance_property brush_motor_driver_0 ENABLED false
set_instance_property position_encoder_0 ENABLED false
set_instance_property fan_motor_driver_0 ENABLED false
set_instance_property brush_motor_driver_1 ENABLED false
set_instance_property brush_motor_driver_2 ENABLED false
set_instance_property brush_motor_driver_3 ENABLED false
set_instance_property position_encoder_1 ENABLED false
set_instance_property position_encoder_2 ENABLED false
set_instance_property position_encoder_3 ENABLED false
set_instance_property fan_motor_driver_1 ENABLED false
set_instance_property subdivision_step_motor_driver_0 ENABLED false
save_system "frontier.qsys"
