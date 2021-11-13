onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /lab1_top_tb/sim_LEFT_button
add wave -noupdate /lab1_top_tb/sim_RIGHT_button
add wave -noupdate /lab1_top_tb/sim_A
add wave -noupdate /lab1_top_tb/sim_B
add wave -noupdate /lab1_top_tb/sim_result
add wave -noupdate /lab1_top_tb/dut/ANDed_result
add wave -noupdate /lab1_top_tb/dut/ADDed_result
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3 ps} 0}
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
WaveRestoreZoom {0 ps} {26 ps}
