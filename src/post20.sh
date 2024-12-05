#!/bin/tcsh
setenv VCS_HOME /opt/designtools/synopsys/vcs/VCS_2021.09-SP1

set path= ( $path $VCS_HOME/bin )


 

vlogan -nc -full64 /home/baniks/nangate15/front_end/verilog/NanGate_15nm_OCL_conditional.v

vhdlan -full64 -vhdl08 mob_pkg.vhd
vhdlan -full64 -vhdl08 eq_pkg20.vhd

vlogan -full64 mob-syn.v

vhdlan -full64 polysolve_tb21.vhd

vcs -full64 -debug -sdf typ:polysolve_tb/mut:mob-syn.sdf polysolve_tb +neg_tchk +sdfverbose -timescale=1ps/1ps

./simv -ucli -include saif.cmd  

