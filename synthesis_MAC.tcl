# Set up the project and read in the design files
set project_name "my_project"
set top_module "my_top_module"
set design_files [list "file1.v" "file2.v" "file3.v"]
read_hdl $design_files

# Set up the target library and compile the design
set target_library "/opt/Foundary_Library"
set link_library "my_link_library"
set compile_options "-retiming"
set compile_report "compile_report.txt"
set link_report "link_report.txt"
set link_options "-auto"
set link_library_options "-reorder"
set link_library_report "link_library_report.txt"
set link_library_report_options "-verbose"
set compile_design $top_module -library $target_library -options $compile_options -report $compile_report
link_design -library $link_library -options $link_options -report $link_report
link_library -library $link_library -options $link_library_options -report $link_library_report -report_options $link_library_report_options

# Optimize the design
set optimize_options "-all_registers -retiming"
set optimize_report "optimize_report.txt"
optimize_design -options $optimize_options -report $optimize_report

# Write out the synthesized netlist
set output_file "my_synthesized_netlist.v"
write -format verilog -hierarchy -output $output_file
