transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/jenpz/Documents/Ders/ele432/quartus\ projects/homework\ 2 {C:/Users/jenpz/Documents/Ders/ele432/quartus projects/homework 2/controller.sv}
vlog -sv -work work +incdir+C:/Users/jenpz/Documents/Ders/ele432/quartus\ projects/homework\ 2 {C:/Users/jenpz/Documents/Ders/ele432/quartus projects/homework 2/mainfsm.sv}
vlog -sv -work work +incdir+C:/Users/jenpz/Documents/Ders/ele432/quartus\ projects/homework\ 2 {C:/Users/jenpz/Documents/Ders/ele432/quartus projects/homework 2/instrdec.sv}
vlog -sv -work work +incdir+C:/Users/jenpz/Documents/Ders/ele432/quartus\ projects/homework\ 2 {C:/Users/jenpz/Documents/Ders/ele432/quartus projects/homework 2/aludec.sv}

vlog -sv -work work +incdir+C:/Users/jenpz/Documents/Ders/ele432/quartus\ projects/homework\ 2 {C:/Users/jenpz/Documents/Ders/ele432/quartus projects/homework 2/ELE432_controller_testbenchsv_14-04-2026.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run -all
