set_part xc7a35ticsg324-1L

add_files [glob -directory src *.vhd]
add_files [glob -directory constraints *.xdc] -fileset [get_filesets constrs_1]
add_files [glob -directory cores *.xcix]