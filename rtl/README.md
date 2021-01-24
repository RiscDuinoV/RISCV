# RTL

Here you'll find all RiscDuinoV hardware description.

- cpu : Contains the hardware description of Vexriscv generated with SpinalHDL
- generic : Contains the hardware description of RiscDuinoV with all instantiations between system components, user components and VexRiscv.
- proj : Contains the 3 ready to use projects.
- soc : contains the hardware description of system components of RiscDuinoV.
- Altera, Lattice, Xilinx : Contains the top level file for the 3 projects

On the folder **VexRiscvScala**, contains the instantiations of all plugins to build VexRiscv. You can modify it if you want to add more plugins to VexRiscv. Check [VexRiscv](https://github.com/SpinalHDL/VexRiscv) for more information about VexRiscv and how to generate the CPU with SpinalHDL.

## Memory management

The memory is defined in 3 parts :

- RAM
- User defined components
- System components

|Component  | Address range |
|:----------: | :-------------: |
|RAM        | 0x00000000 &rarr; 0x7FFFFFFF
|User defined components | 0x80000000 &rarr; 0xBFFFFFFF |
| System components | 0xFFFFF800 &rarr; 0xFFFFFFFF |
