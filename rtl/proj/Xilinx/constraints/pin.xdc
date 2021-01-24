create_clock -period 10.000 -name Clk -waveform {0.000 5.000} [get_ports Clk]
set_property PACKAGE_PIN E18 [get_ports {Leds[0]}]
set_property PACKAGE_PIN F13 [get_ports {Leds[1]}]
set_property PACKAGE_PIN E13 [get_ports {Leds[2]}]
set_property PACKAGE_PIN H15 [get_ports {Leds[3]}]
set_property PACKAGE_PIN V12 [get_ports Sio_Rx]
set_property PACKAGE_PIN R12 [get_ports Sio_Tx]
set_property PACKAGE_PIN L17 [get_ports Spi_Ce_N]
set_property PACKAGE_PIN L18 [get_ports Spi_Miso]
set_property PACKAGE_PIN M14 [get_ports Spi_Mosi]
set_property PACKAGE_PIN N14 [get_ports Spi_Sck]
set_property PACKAGE_PIN R2 [get_ports Clk]
set_property IOSTANDARD LVCMOS33 [get_ports {Leds[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Leds[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Leds[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Leds[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports ARst]
set_property IOSTANDARD LVCMOS33 [get_ports Clk]
set_property IOSTANDARD LVCMOS33 [get_ports Sio_Rx]
set_property IOSTANDARD LVCMOS33 [get_ports Sio_Tx]
set_property IOSTANDARD LVCMOS33 [get_ports Spi_Ce_N]
set_property IOSTANDARD LVCMOS33 [get_ports Spi_Miso]
set_property IOSTANDARD LVCMOS33 [get_ports Spi_Mosi]
set_property IOSTANDARD LVCMOS33 [get_ports Spi_Sck]

set_property PACKAGE_PIN C18 [get_ports ARst_N]
set_property IOSTANDARD LVCMOS33 [get_ports ARst_N]


set_property SLEW SLOW [get_ports {Leds[3]}]
set_property SLEW SLOW [get_ports {Leds[2]}]
set_property SLEW SLOW [get_ports {Leds[1]}]
set_property SLEW SLOW [get_ports {Leds[0]}]



set_property PACKAGE_PIN J13 [get_ports I2C_Sda]
set_property PACKAGE_PIN J14 [get_ports I2C_Scl]
set_property IOSTANDARD LVCMOS33 [get_ports I2C_Scl]
set_property IOSTANDARD LVCMOS33 [get_ports I2C_Sda]
set_property SLEW SLOW [get_ports I2C_Scl]
set_property PULLUP true [get_ports I2C_Sda]




# connect_debug_port u_ila_0/probe0 [get_nets [list {SocAddressDecoder/soc/genI2C[0].i2c/Present_ST[0]} {SocAddressDecoder/soc/genI2C[0].i2c/Present_ST[1]}]]
# connect_debug_port u_ila_0/probe1 [get_nets [list {SocAddressDecoder/soc/genI2C[0].i2c/CptBit[0]} {SocAddressDecoder/soc/genI2C[0].i2c/CptBit[1]} {SocAddressDecoder/soc/genI2C[0].i2c/CptBit[2]}]]
# connect_debug_port u_ila_0/probe3 [get_nets [list {SocAddressDecoder/soc/data_DAT_O[0]} {SocAddressDecoder/soc/data_DAT_O[1]} {SocAddressDecoder/soc/data_DAT_O[2]} {SocAddressDecoder/soc/data_DAT_O[3]} {SocAddressDecoder/soc/data_DAT_O[4]} {SocAddressDecoder/soc/data_DAT_O[5]} {SocAddressDecoder/soc/data_DAT_O[6]} {SocAddressDecoder/soc/data_DAT_O[7]} {SocAddressDecoder/soc/data_DAT_O[8]} {SocAddressDecoder/soc/data_DAT_O[9]} {SocAddressDecoder/soc/data_DAT_O[10]} {SocAddressDecoder/soc/data_DAT_O[11]} {SocAddressDecoder/soc/data_DAT_O[12]} {SocAddressDecoder/soc/data_DAT_O[13]} {SocAddressDecoder/soc/data_DAT_O[14]} {SocAddressDecoder/soc/data_DAT_O[15]} {SocAddressDecoder/soc/data_DAT_O[16]} {SocAddressDecoder/soc/data_DAT_O[17]} {SocAddressDecoder/soc/data_DAT_O[18]} {SocAddressDecoder/soc/data_DAT_O[19]} {SocAddressDecoder/soc/data_DAT_O[20]} {SocAddressDecoder/soc/data_DAT_O[21]} {SocAddressDecoder/soc/data_DAT_O[22]} {SocAddressDecoder/soc/data_DAT_O[23]} {SocAddressDecoder/soc/data_DAT_O[24]} {SocAddressDecoder/soc/data_DAT_O[25]} {SocAddressDecoder/soc/data_DAT_O[26]} {SocAddressDecoder/soc/data_DAT_O[27]} {SocAddressDecoder/soc/data_DAT_O[28]} {SocAddressDecoder/soc/data_DAT_O[29]} {SocAddressDecoder/soc/data_DAT_O[30]} {SocAddressDecoder/soc/data_DAT_O[31]}]]
# connect_debug_port u_ila_0/probe7 [get_nets [list SocAddressDecoder/soc/data_CMD_ACK_I]]
# connect_debug_port u_ila_0/probe8 [get_nets [list SocAddressDecoder/soc/data_RSP_ACK_I]]
# connect_debug_port u_ila_0/probe9 [get_nets [list SocAddressDecoder/soc/data_STB_O]]
# connect_debug_port u_ila_0/probe11 [get_nets [list {SocAddressDecoder/soc/genI2C[0].i2c/OnTransmission}]]
# connect_debug_port u_ila_0/probe13 [get_nets [list {SocAddressDecoder/soc/genI2C[0].i2c/S_SclFE}]]
# connect_debug_port u_ila_0/probe14 [get_nets [list {SocAddressDecoder/soc/genI2C[0].i2c/S_SclRE}]]



# connect_debug_port u_ila_0/probe0 [get_nets [list {SocAddressDecoder/soc/genI2C[0].i2c/i2c_master/CptBit[0]} {SocAddressDecoder/soc/genI2C[0].i2c/i2c_master/CptBit[1]} {SocAddressDecoder/soc/genI2C[0].i2c/i2c_master/CptBit[2]}]]
# connect_debug_port u_ila_0/probe1 [get_nets [list {SocAddressDecoder/soc/genI2C[0].i2c/i2c_master/DataTx[0]} {SocAddressDecoder/soc/genI2C[0].i2c/i2c_master/DataTx[1]} {SocAddressDecoder/soc/genI2C[0].i2c/i2c_master/DataTx[2]} {SocAddressDecoder/soc/genI2C[0].i2c/i2c_master/DataTx[3]} {SocAddressDecoder/soc/genI2C[0].i2c/i2c_master/DataTx[4]} {SocAddressDecoder/soc/genI2C[0].i2c/i2c_master/DataTx[5]} {SocAddressDecoder/soc/genI2C[0].i2c/i2c_master/DataTx[6]} {SocAddressDecoder/soc/genI2C[0].i2c/i2c_master/DataTx[7]}]]
# connect_debug_port u_ila_0/probe2 [get_nets [list {SocAddressDecoder/soc/genI2C[0].i2c/i2c_master/Present_ST[0]} {SocAddressDecoder/soc/genI2C[0].i2c/i2c_master/Present_ST[1]} {SocAddressDecoder/soc/genI2C[0].i2c/i2c_master/Present_ST[2]}]]
# connect_debug_port u_ila_0/probe3 [get_nets [list {SocAddressDecoder/soc/genI2C[0].i2c/i2c_master/DataRx[0]} {SocAddressDecoder/soc/genI2C[0].i2c/i2c_master/DataRx[1]} {SocAddressDecoder/soc/genI2C[0].i2c/i2c_master/DataRx[2]} {SocAddressDecoder/soc/genI2C[0].i2c/i2c_master/DataRx[3]} {SocAddressDecoder/soc/genI2C[0].i2c/i2c_master/DataRx[4]} {SocAddressDecoder/soc/genI2C[0].i2c/i2c_master/DataRx[5]} {SocAddressDecoder/soc/genI2C[0].i2c/i2c_master/DataRx[6]} {SocAddressDecoder/soc/genI2C[0].i2c/i2c_master/DataRx[7]}]]
# connect_debug_port u_ila_0/probe8 [get_nets [list {SocAddressDecoder/soc/genI2C[0].i2c/i2c_master/BusyFlag}]]
# connect_debug_port u_ila_0/probe11 [get_nets [list {SocAddressDecoder/soc/genI2C[0].i2c/i2c_master/EndTransmission}]]
# connect_debug_port u_ila_0/probe12 [get_nets [list {SocAddressDecoder/soc/genI2C[0].i2c/i2c_master/iScl}]]
# connect_debug_port u_ila_0/probe13 [get_nets [list {SocAddressDecoder/soc/genI2C[0].i2c/i2c_master/iSda}]]
# connect_debug_port u_ila_0/probe14 [get_nets [list {SocAddressDecoder/soc/genI2C[0].i2c/i2c_master/StartTransmission}]]
# connect_debug_port u_ila_0/probe15 [get_nets [list {SocAddressDecoder/soc/genI2C[0].i2c/i2c_master/TrigRead}]]
# connect_debug_port u_ila_0/probe16 [get_nets [list {SocAddressDecoder/soc/genI2C[0].i2c/i2c_master/TrigWrite}]]



