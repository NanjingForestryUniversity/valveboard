transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/miaow/Desktop/valve_board_kun {C:/Users/miaow/Desktop/valve_board_kun/PF1.v}

vlog -vlog01compat -work work +incdir+C:/Users/miaow/Desktop/valve_board_kun {C:/Users/miaow/Desktop/valve_board_kun/tb_PF1.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L maxii_ver -L rtl_work -L work -voptargs="+acc"  tb_PF1

add wave *
view structure
view signals
run 5 ms
