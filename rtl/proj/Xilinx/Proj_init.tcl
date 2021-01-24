# file mkdir "proj"
# cd proj
#
# STEP#1: define the output directory area.
#
set script_path [file dirname [file normalize [info script]]]
cd $script_path
set outputDir "Proj"
file mkdir $outputDir
create_project VexRiscv $outputDir -part xc7s50csga324-1 -force
#
# STEP#2: setup design sources and constraints
#
add_files "[pwd]/../../Xilinx/Top.vhd"
add_files "[pwd]/../../cpu/VexRiscv/VexRiscv.vhd"
add_files "[pwd]/../../cpu/VexRiscv/VexRiscv_wb.vhd"
add_files "[pwd]/../../cpu/VexRiscv/VexRiscVJTAG.v"
add_files "[pwd]/../../generic/Address_Decoder.vhd"
add_files "[pwd]/../../generic/soc.vhd"
add_files "[pwd]/../../generic/SocAddressDecoder.vhd"
add_files "[pwd]/../../generic/type_package.vhd"
add_files "[pwd]/../../soc/spi.vhd"
add_files "[pwd]/../../soc/BootTrap.vhd"
add_files "[pwd]/../../soc/bram.vhd"
add_files "[pwd]/../../soc/bram_cpu.vhd"
add_files "[pwd]/../../soc/gpio.vhd"
add_files "[pwd]/../../soc/interrupt_controller.vhd"
add_files "[pwd]/../../soc/components/fifo.vhd"
add_files "[pwd]/../../soc/timer/mtime.vhd"
add_files "[pwd]/../../soc/timer/timer.vhd"
add_files "[pwd]/../../soc/timer/timerbus.vhd"
add_files "[pwd]/../../soc/Example.vhd"
add_files "[pwd]/../../soc/UART/Uart.vhd"
add_files "[pwd]/../../soc/UART/UartRx.vhd"
add_files "[pwd]/../../soc/UART/UartTx.vhd"
add_files "[pwd]/../../soc/i2c/i2c.vhd"
add_files "[pwd]/../../soc/i2c/i2c_master.vhd"
add_files "[pwd]/constraints/pin.xdc"