###################################################################################################
## This constraints file contains default clock frequencies to be used during creation of a 
## Synthesis Design Checkpoint (DCP). For best results the frequencies should be modified 
## to match the target frequencies. 
## This constraints file is not used in top-down/global synthesis (not the default flow of Vivado).
###################################################################################################


##################################################################################################
## 
##  Xilinx, Inc. 2010            www.xilinx.com 
##  Tue Feb  2 20:00:35 2021

##  Generated by MIG Version 4.2
##  
##################################################################################################
##  File name :       mig_7series_0.xdc
##  Details :     Constraints file
##                    FPGA Family:       KINTEX7
##                    FPGA Part:         XC7K325T-FFG900
##                    Speedgrade:        -2
##                    Design Entry:      VERILOG
##                    Frequency:         800 MHz
##                    Time Period:       1250 ps
##################################################################################################

##################################################################################################
## Controller 0
## Memory Device: DDR3_SDRAM->Components->MT41K256M16XX-107
## Data Width: 64
## Time Period: 1250
## Data Mask: 1
##################################################################################################

create_clock -period 5 [get_ports sys_clk_i]
          