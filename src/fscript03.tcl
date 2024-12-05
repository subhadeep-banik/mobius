read_file -format ddc  {./mob04.ddc}

reset_switching_activity

read_saif -input mob-full_timing.saif -instance POLYSOLVE_TB/MUT -unit ps 

report_power  > powercong_lp03.txt
report_power  -hier > powerconh_lp03.txt

exit

