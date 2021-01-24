# Project Generation
## Lattice Diamond
### Linux
```
diamondc Lattice/Proj_init.tcl
```
### Windows
```
C:\FullPathToDiamond\bin\pnmain.exe
```
Once the project created, the project will be located in **Lattice/Proj**.


## Vivado
```
vivado -mode=batch -nolog -nojournal -source="Xilinx/Proj_init.tcl"
```
### Windows
```
C:\FullPathToVivado\bin\vivado.exe -mode=batch -nolog -nojournal -source="Xilinx/Proj_init.tcl"
```
Once the project created, the project will be located in **Xilinx/Proj**.