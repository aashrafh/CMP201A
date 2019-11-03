onerror {exit -code 1}
vlib work
vlog -work work ExecutionUnit.vo
vlog -work work TestCaseAfterOrg1.vwf.vt
vsim -novopt -c -t 1ps -L maxv_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate_ver -L altera_lnsim_ver work.ExecutionUnit_vlg_vec_tst -voptargs="+acc"
vcd file -direction ExecutionUnit.msim.vcd
vcd add -internal ExecutionUnit_vlg_vec_tst/*
vcd add -internal ExecutionUnit_vlg_vec_tst/i1/*
run -all
quit -f
