sh rm -rf WORK/*
sh rm -rf AN.DB/*
sh rm -rf csrc/*
remove_design -all


define_design_lib WORK -path ./WORK
analyze -library WORK -format vhdl {./mob_pkg.vhd
./eq_pkg20.vhd
./mob.vhd
./dec.vhd
./pes.vhd
./penc.vhd
./byte_adder.vhd
./block_adder1.vhd
./brentkung.vhd
./norn1.vhd
./butterfly.vhd
./regs.vhd
./reg.vhd
./rege.vhd
./regr.vhd
./regsen.vhd
./expander.vhd
./dotprod.vhd
./polymobi-vhpipegen.vhd
./qn03.vhd
}

 

elaborate POLYSOLVE -architecture RECURSIVE -library WORK


create_clock -name "Clk" -period 10 -waveform { 0 5  }  { Clk  }

#set_max_area 0
#set_fix_multiple_port_nets -all -buffer_constants
compile_ultra



change_selection -name global -replace [get_timing_paths -delay_type max -nworst 1 -max_paths 1 -include_hierarchical_pins]

uplevel #0 { report_timing -path full -delay max -nworst 40 -max_paths 40 -significant_digits 2 -sort_by group > timing_lp03.txt}

uplevel #0 { report_area -hierarchy > area_lp03.txt}
 
write -hierarchy -format verilog -output mob-syn.v 

write_sdf mob-syn.sdf  

write -hierarchy -format ddc -output mob03.ddc

write -hierarchy -format vhdl -output mob.vhdl

write_sdc -nosplit mob.sdc
exit 
exit 
exit 
