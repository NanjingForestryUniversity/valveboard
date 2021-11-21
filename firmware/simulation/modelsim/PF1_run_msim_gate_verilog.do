transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -vlog01compat -work work +incdir+. {PF1.vo}

vlog -vlog01compat -work work +incdir+C:/Users/miaow/Desktop/valve_board_kun {C:/Users/miaow/Desktop/valve_board_kun/tb_PF1.v}

vsim -t 1ps +transport_int_delays +transport_path_delays -L maxii_ver -L gate_work -L work -voptargs="+acc"  tb_PF1

add wave *
view structure
view signals
run 5 ms
