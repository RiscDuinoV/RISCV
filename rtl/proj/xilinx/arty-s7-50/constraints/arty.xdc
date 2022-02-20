set_property PACKAGE_PIN C18 [get_ports pin_arst_n_i]
set_property PACKAGE_PIN R2 [get_ports pin_clk_i]
set_property IOSTANDARD LVCMOS33 [get_ports pin_arst_n_i]
set_property IOSTANDARD LVCMOS33 [get_ports pin_clk_i]

# UART
set_property PACKAGE_PIN V12 [get_ports pin_uart_rx_i]
set_property PACKAGE_PIN R12 [get_ports pin_uart_tx_o]
set_property IOSTANDARD LVCMOS33 [get_ports pin_uart_rx_i]
set_property IOSTANDARD LVCMOS33 [get_ports pin_uart_tx_o]

# I2C
set_property PACKAGE_PIN J14 [get_ports pin_i2c_scl_io]
set_property PACKAGE_PIN J13 [get_ports pin_i2c_sda_io]
set_property IOSTANDARD LVCMOS33 [get_ports pin_i2c_scl_io]
set_property IOSTANDARD LVCMOS33 [get_ports pin_i2c_sda_io]

# Btn
set_property PACKAGE_PIN G15 [get_ports {pin_btn_n_i[0]}]
set_property PACKAGE_PIN K16 [get_ports {pin_btn_n_i[1]}]
set_property PACKAGE_PIN J16 [get_ports {pin_btn_n_i[2]}]
set_property PACKAGE_PIN H13 [get_ports {pin_btn_n_i[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pin_btn_n_i[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pin_btn_n_i[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pin_btn_n_i[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pin_btn_n_i[3]}]

# Sw
set_property PACKAGE_PIN H14 [get_ports {pin_sw_i[0]}]
set_property PACKAGE_PIN H18 [get_ports {pin_sw_i[1]}]
set_property PACKAGE_PIN G18 [get_ports {pin_sw_i[2]}]
set_property PACKAGE_PIN M5  [get_ports {pin_sw_i[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pin_sw_i[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pin_sw_i[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pin_sw_i[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pin_sw_i[3]}]

# RGB leds
set_property PACKAGE_PIN J15 [get_ports {pin_led_o[0]}]
set_property PACKAGE_PIN G17 [get_ports {pin_led_o[1]}]
set_property PACKAGE_PIN F15 [get_ports {pin_led_o[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pin_led_o[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pin_led_o[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pin_led_o[2]}]
set_property PACKAGE_PIN E15 [get_ports {pin_led_o[3]}]
set_property PACKAGE_PIN F18 [get_ports {pin_led_o[4]}]
set_property PACKAGE_PIN E14 [get_ports {pin_led_o[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pin_led_o[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pin_led_o[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pin_led_o[5]}]

# Green leds
set_property PACKAGE_PIN E18 [get_ports {pin_led_o[6]}]
set_property PACKAGE_PIN F13 [get_ports {pin_led_o[7]}]
set_property PACKAGE_PIN E13 [get_ports {pin_led_o[8]}]
set_property PACKAGE_PIN H15 [get_ports {pin_led_o[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pin_led_o[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pin_led_o[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pin_led_o[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pin_led_o[9]}]


create_clock -period 10.000 -name pin_clk_i -waveform {0.000 5.000} [get_ports pin_clk_i]