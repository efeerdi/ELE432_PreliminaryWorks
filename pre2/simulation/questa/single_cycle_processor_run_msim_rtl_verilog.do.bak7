transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/jenpz/Documents/Ders/ele432/quartus\ projects/pre2 {C:/Users/jenpz/Documents/Ders/ele432/quartus projects/pre2/single_cycle_processor.sv}
vlog -sv -work work +incdir+C:/Users/jenpz/Documents/Ders/ele432/quartus\ projects/pre2 {C:/Users/jenpz/Documents/Ders/ele432/quartus projects/pre2/controller.sv}
vlog -sv -work work +incdir+C:/Users/jenpz/Documents/Ders/ele432/quartus\ projects/pre2 {C:/Users/jenpz/Documents/Ders/ele432/quartus projects/pre2/maindec.sv}
vlog -sv -work work +incdir+C:/Users/jenpz/Documents/Ders/ele432/quartus\ projects/pre2 {C:/Users/jenpz/Documents/Ders/ele432/quartus projects/pre2/aludec.sv}
vlog -sv -work work +incdir+C:/Users/jenpz/Documents/Ders/ele432/quartus\ projects/pre2 {C:/Users/jenpz/Documents/Ders/ele432/quartus projects/pre2/datapath.sv}
vlog -sv -work work +incdir+C:/Users/jenpz/Documents/Ders/ele432/quartus\ projects/pre2 {C:/Users/jenpz/Documents/Ders/ele432/quartus projects/pre2/adder.sv}
vlog -sv -work work +incdir+C:/Users/jenpz/Documents/Ders/ele432/quartus\ projects/pre2 {C:/Users/jenpz/Documents/Ders/ele432/quartus projects/pre2/extend.sv}
vlog -sv -work work +incdir+C:/Users/jenpz/Documents/Ders/ele432/quartus\ projects/pre2 {C:/Users/jenpz/Documents/Ders/ele432/quartus projects/pre2/flopr.sv}
vlog -sv -work work +incdir+C:/Users/jenpz/Documents/Ders/ele432/quartus\ projects/pre2 {C:/Users/jenpz/Documents/Ders/ele432/quartus projects/pre2/mux2.sv}
vlog -sv -work work +incdir+C:/Users/jenpz/Documents/Ders/ele432/quartus\ projects/pre2 {C:/Users/jenpz/Documents/Ders/ele432/quartus projects/pre2/mux3.sv}
vlog -sv -work work +incdir+C:/Users/jenpz/Documents/Ders/ele432/quartus\ projects/pre2 {C:/Users/jenpz/Documents/Ders/ele432/quartus projects/pre2/top.sv}
vlog -sv -work work +incdir+C:/Users/jenpz/Documents/Ders/ele432/quartus\ projects/pre2 {C:/Users/jenpz/Documents/Ders/ele432/quartus projects/pre2/dmem.sv}
vlog -sv -work work +incdir+C:/Users/jenpz/Documents/Ders/ele432/quartus\ projects/pre2 {C:/Users/jenpz/Documents/Ders/ele432/quartus projects/pre2/regfile.sv}
vlog -sv -work work +incdir+C:/Users/jenpz/Documents/Ders/ele432/quartus\ projects/pre2 {C:/Users/jenpz/Documents/Ders/ele432/quartus projects/pre2/alu.sv}
vlog -sv -work work +incdir+C:/Users/jenpz/Documents/Ders/ele432/quartus\ projects/pre2 {C:/Users/jenpz/Documents/Ders/ele432/quartus projects/pre2/imem.sv}

vlog -sv -work work +incdir+C:/Users/jenpz/Documents/Ders/ele432/quartus\ projects/pre2 {C:/Users/jenpz/Documents/Ders/ele432/quartus projects/pre2/testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run -all
