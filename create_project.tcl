# Recreate the Vivado project:  Vivado > Tools > Run Tcl Script... > create_project.tcl
# or from a shell:  vivado -mode batch -source create_project.tcl
set script_dir [file dirname [file normalize [info script]]]

create_project ov7670_st7735 $script_dir/vivado_project -part xc7a35tcpg236-1 -force
add_files [glob $script_dir/src/*.vhd]
add_files -fileset constrs_1 $script_dir/constraints/basys3.xdc
set_property top top_cam_lcd [current_fileset]
update_compile_order -fileset sources_1
puts "Project created. Run Synthesis -> Implementation -> Generate Bitstream."
