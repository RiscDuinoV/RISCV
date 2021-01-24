set script_path [file dirname [file normalize [info script]]]
cd $script_path
file mkdir "[pwd]/Proj"
cd "Proj"

prj_project new -name "VexRiscv" -impl "impl1" -dev LFE5UM5G-85F-8BG381C -synthesis "synplify"

prj_src add "[pwd]/../../../Lattice/Top.vhd"
prj_src add "[pwd]/../../../cpu/VexRiscv/VexRiscv.vhd"
prj_src add "[pwd]/../../../cpu/VexRiscv/VexRiscv_wb.vhd"
prj_src add "[pwd]/../../../cpu/VexRiscv/VexRiscVJTAG.v"
prj_src add "[pwd]/../../../generic/Address_Decoder.vhd"
prj_src add "[pwd]/../../../generic/soc.vhd"
prj_src add "[pwd]/../../../generic/SocAddressDecoder.vhd"
prj_src add "[pwd]/../../../generic/type_package.vhd"
prj_src add "[pwd]/../../../soc/spi.vhd"
prj_src add "[pwd]/../../../soc/BootTrap.vhd"
prj_src add "[pwd]/../../../soc/bram.vhd"
prj_src add "[pwd]/../../../soc/bram_cpu.vhd"
prj_src add "[pwd]/../../../soc/gpio.vhd"
prj_src add "[pwd]/../../../soc/interrupt_controller.vhd"
prj_src add "[pwd]/../../../soc/components/fifo.vhd"
prj_src add "[pwd]/../../../soc/timer/mtime.vhd"
prj_src add "[pwd]/../../../soc/timer/timer.vhd"
prj_src add "[pwd]/../../../soc/timer/timerbus.vhd"
prj_src add "[pwd]/../../../soc/UART/Uart.vhd"
prj_src add "[pwd]/../../../soc/UART/UartRx.vhd"
prj_src add "[pwd]/../../../soc/UART/UartTx.vhd"
prj_src add "[pwd]/../../../soc/i2c/i2c.vhd"
prj_src add "[pwd]/../../../soc/i2c/i2c_master.vhd"
prj_src add "[pwd]/../../../soc/Example.vhd"

prj_src add -exclude "[pwd]/../constraints/pin.lpf"
prj_src enable "[pwd]/../constraints/pin.lpf"

prj_project save

prj_project close