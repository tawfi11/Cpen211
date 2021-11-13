onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cpu_tb/w
add wave -noupdate /cpu_tb/s
add wave -noupdate /cpu_tb/reset
add wave -noupdate /cpu_tb/out
add wave -noupdate /cpu_tb/load
add wave -noupdate /cpu_tb/in
add wave -noupdate /cpu_tb/err
add wave -noupdate /cpu_tb/clk
add wave -noupdate /cpu_tb/Z
add wave -noupdate /cpu_tb/V
add wave -noupdate /cpu_tb/N
add wave -noupdate /cpu_tb/DUT/DP/REGFILE/writenum
add wave -noupdate /cpu_tb/DUT/DP/REGFILE/write
add wave -noupdate /cpu_tb/DUT/DP/REGFILE/tr
add wave -noupdate /cpu_tb/DUT/DP/REGFILE/t2
add wave -noupdate /cpu_tb/DUT/DP/REGFILE/t1
add wave -noupdate /cpu_tb/DUT/DP/REGFILE/readnum
add wave -noupdate /cpu_tb/DUT/DP/REGFILE/data_out
add wave -noupdate /cpu_tb/DUT/DP/REGFILE/data_in
add wave -noupdate /cpu_tb/DUT/DP/REGFILE/clk
add wave -noupdate /cpu_tb/DUT/DP/REGFILE/R7
add wave -noupdate /cpu_tb/DUT/DP/REGFILE/R6
add wave -noupdate /cpu_tb/DUT/DP/REGFILE/R5
add wave -noupdate /cpu_tb/DUT/DP/REGFILE/R4
add wave -noupdate /cpu_tb/DUT/DP/REGFILE/R3
add wave -noupdate /cpu_tb/DUT/DP/REGFILE/R2
add wave -noupdate /cpu_tb/DUT/DP/REGFILE/R1
add wave -noupdate /cpu_tb/DUT/DP/REGFILE/R0
add wave -noupdate /cpu_tb/DUT/presentstate
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {950 ps} {1950 ps}
