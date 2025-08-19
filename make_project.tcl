# Vivado Project Creation Script for golden-rv
# This script creates a new Vivado project and adds source files from organized directories
# Created by GitHub Copilot with intelligent file management and dependency handling

# Detect if running in batch mode or GUI mode
set is_batch_mode 0
if {[info exists argv] && [lsearch $argv "-mode"] != -1} {
    set mode_idx [lsearch $argv "-mode"]
    if {$mode_idx != -1 && [expr $mode_idx + 1] < [llength $argv]} {
        set mode_val [lindex $argv [expr $mode_idx + 1]]
        if {$mode_val eq "batch"} {
            set is_batch_mode 1
        }
    }
}

# Exit on any error for better bash integration
set errorInfo ""

# Set project variables
set project_name "golden_rv"
set project_dir "./vivado_project"
set top_module "datapath"

# Check if project already exists
set project_file "${project_dir}/${project_name}.xpr"
set project_exists [file exists $project_file]

# Detect if we're running inside an already open project
set current_project_name ""
if {[catch {set current_project_name [get_property NAME [current_project]]}]} {
    set current_project_name ""
}

# If we're in GUI mode and a project is already open, don't recreate it
if {!$is_batch_mode && $current_project_name ne ""} {
    puts "Running in GUI mode with project '$current_project_name' already open"
    puts "Updating files in the current project instead of creating new one..."
    set project_exists 1
    set project_name $current_project_name
    # Don't close or recreate the project
} else {
    # Close any currently open projects to avoid conflicts (only if not in GUI with open project)
    if {[llength [get_projects -quiet]] > 0} {
        puts "Closing currently open projects..."
        close_project -quiet
    }
}

# Wrap main execution in try-catch for better error handling
if {[catch {

# Only create/open project if we're not already in one
if {!$is_batch_mode && $current_project_name ne ""} {
    # We're already in a project - just update files
    puts "Using existing open project: $current_project_name"
} else {
    if {$project_exists} {
        puts "Project already exists at: $project_file"
        puts "Opening existing project and updating files..."
        open_project $project_file
    } else {
        puts "Creating new project..."
        # Create project directory if it doesn't exist
        file mkdir $project_dir
        
        # Create the project
        create_project $project_name $project_dir -part xc7a35tcpg236-1 -force
        
        # Set project properties
        set_property target_language Verilog [current_project]
        set_property simulator_language Mixed [current_project]
    }
}

# Function to add files if they're not already in the project
proc add_files_if_new {fileset file_pattern file_type_name} {
    set new_files [glob -nocomplain $file_pattern]
    set existing_files [get_files -quiet -of_objects [get_filesets $fileset]]
    
    set files_to_add {}
    foreach new_file $new_files {
        set new_file_abs [file normalize $new_file]
        set already_exists 0
        
        foreach existing_file $existing_files {
            if {[file normalize $existing_file] eq $new_file_abs} {
                set already_exists 1
                break
            }
        }
        
        if {!$already_exists} {
            lappend files_to_add $new_file
        }
    }
    
    if {[llength $files_to_add] > 0} {
        puts "Adding [llength $files_to_add] new $file_type_name files to $fileset:"
        foreach file $files_to_add {
            puts "  + [file tail $file]"
        }
        add_files -fileset $fileset $files_to_add
        return $files_to_add
    } else {
        puts "No new $file_type_name files to add to $fileset"
        return {}
    }
}

# Add package files to simulation fileset (since they're simulation-only)
puts "\nChecking package files..."
set new_pkg_files [add_files_if_new sim_1 "pkg/*.sv" "package"]

# Add source files (Verilog design files)
puts "\nChecking source files..."
set new_src_files [add_files_if_new sources_1 "src/*.v" "source"]

# Add simulation files (SystemVerilog testbenches)
puts "\nChecking simulation files..."
set new_sim_files [add_files_if_new sim_1 "sim/*_tb.sv" "simulation"]

# Add memory files (after the simulation files section)
puts "\nChecking memory files..."
set new_mem_files [add_files_if_new sources_1 "mem/*.mem mem/*.hex mem/*.mif mem/*.coe" "memory"]

# Set file properties for newly added files only
if {[llength $new_pkg_files] > 0} {
    puts "Setting properties for new package files..."
    foreach pkg_file $new_pkg_files {
        set_property file_type "SystemVerilog" [get_files $pkg_file]
        set_property is_global_include true [get_files $pkg_file]
    }
}

if {[llength $new_sim_files] > 0} {
    puts "Setting properties for new simulation files..."
    foreach sim_file $new_sim_files {
        set_property file_type "SystemVerilog" [get_files $sim_file]
    }
}

if {[llength $new_src_files] > 0} {
    puts "Setting properties for new source files..."
    foreach src_file $new_src_files {
        set_property file_type "Verilog" [get_files $src_file]
    }
}

if {[llength $new_mem_files] > 0} {
    puts "Setting properties for new memory files..."
    foreach mem_file $new_mem_files {
        # Determine file type based on extension
        set ext [file extension $mem_file]
        switch $ext {
            ".mem" { set_property file_type "Memory File" [get_files $mem_file] }
            ".hex" { set_property file_type "Memory File" [get_files $mem_file] }
            ".mif" { set_property file_type "Memory Initialization Files" [get_files $mem_file] }
            ".coe" { set_property file_type "Coefficient Files" [get_files $mem_file] }
            default { set_property file_type "Memory File" [get_files $mem_file] }
        }
    }
}

proc analyze_and_set_package_order {} {
    # Get all SystemVerilog package files from simulation fileset
    set pkg_files [get_files -quiet -of_objects [get_filesets sim_1] -filter "FILE_TYPE == SystemVerilog && NAME =~ *pkg/*"]
    
    if {[llength $pkg_files] == 0} {
        return
    }
    
    puts "Analyzing package dependencies..."
    
    # Create dependency map
    array set pkg_dependencies {}
    array set pkg_names {}
    
    # First pass: extract package names and find imports
    foreach pkg_file $pkg_files {
        set pkg_name [file rootname [file tail $pkg_file]]
        set pkg_names($pkg_file) $pkg_name
        set pkg_dependencies($pkg_file) {}
        
        # Read file and look for package imports
        if {[catch {
            set fp [open $pkg_file r]
            set content [read $fp]
            close $fp
            
            # Look for import statements
            set import_lines [regexp -all -inline -line {^\s*import\s+(\w+)::} $content]
            foreach {full_match imported_pkg} $import_lines {
                # Find which file contains this package
                foreach other_pkg_file $pkg_files {
                    set other_pkg_name [file rootname [file tail $other_pkg_file]]
                    if {$other_pkg_name eq $imported_pkg} {
                        lappend pkg_dependencies($pkg_file) $other_pkg_file
                        puts "  $pkg_name imports $imported_pkg"
                        break
                    }
                }
            }
        } error_msg]} {
            puts "Warning: Could not analyze dependencies for $pkg_file: $error_msg"
        }
    }
    
    # Simple topological sort to determine compile order
    set ordered_packages {}
    set remaining_packages $pkg_files
    set max_iterations [llength $pkg_files]
    set iteration 0
    
    while {[llength $remaining_packages] > 0 && $iteration < $max_iterations} {
        set progress_made 0
        set new_remaining {}
        
        foreach pkg_file $remaining_packages {
            set dependencies $pkg_dependencies($pkg_file)
            set all_deps_satisfied 1
            
            # Check if all dependencies are already in ordered list
            foreach dep $dependencies {
                if {[lsearch $ordered_packages $dep] == -1} {
                    set all_deps_satisfied 0
                    break
                }
            }
            
            if {$all_deps_satisfied} {
                lappend ordered_packages $pkg_file
                set progress_made 1
                puts "  Added [file tail $pkg_file] to compile order"
            } else {
                lappend new_remaining $pkg_file
            }
        }
        
        if {!$progress_made} {
            puts "Warning: Circular dependency detected or unresolved dependencies. Adding remaining packages in original order."
            set ordered_packages [concat $ordered_packages $new_remaining]
            break
        }
        
        set remaining_packages $new_remaining
        incr iteration
    }
    
    # Set the compile order for packages in simulation fileset
    if {[llength $ordered_packages] > 0} {
        puts "Setting package compile order:"
        set order_index 1
        foreach pkg_file $ordered_packages {
            puts "  $order_index. [file tail $pkg_file]"
            set_property USED_IN_SYNTHESIS false [get_files $pkg_file]
            set_property USED_IN_SIMULATION true [get_files $pkg_file]
            incr order_index
        }
        
        # Reorder files in the simulation fileset
        reorder_files -fileset sim_1 -front $ordered_packages
    }
}

# Analyze package dependencies if we have any packages
set all_pkg_files [get_files -quiet -of_objects [get_filesets sim_1] -filter "FILE_TYPE == SystemVerilog && NAME =~ *pkg/*"]
if {[llength $all_pkg_files] > 0} {
    analyze_and_set_package_order
}

# Update compile order if new files were added
set total_new_files [expr [llength $new_pkg_files] + [llength $new_src_files] + [llength $new_sim_files] + [llength $new_mem_files]]
if {$total_new_files > 0} {
    puts "\nUpdating compile order for $total_new_files new files..."
    update_compile_order -fileset sources_1
    update_compile_order -fileset sim_1
} else {
    puts "\nNo new files added - compile order unchanged"
}

# Set top module only for new projects or if not already set
set current_top [get_property top [current_fileset]]
if {$current_top eq "" || !$project_exists} {
    puts "\nSetting top module for synthesis..."
    set_property top $top_module [current_fileset]
    puts "Set synthesis top module to: $top_module"
} else {
    puts "\nSynthesis top module already set to: $current_top"
}

# Set simulation top module only if not already set
set current_sim_top [get_property top [get_filesets sim_1]]
if {$current_sim_top eq "" || !$project_exists} {
    puts "Setting simulation top module..."
    if {[catch {
        set_property top riscv_tb [get_filesets sim_1]
        set_property top_lib xil_defaultlib [get_filesets sim_1]
        puts "Set simulation top module to: riscv_tb"
    } sim_error]} {
        puts "Warning: Could not set simulation top module: $sim_error"
        puts "You can set it manually later in the GUI"
    }
} else {
    puts "Simulation top module already set to: $current_sim_top"
}

if {$project_exists} {
    puts "\nProject '$project_name' updated successfully!"
    if {$total_new_files > 0} {
        puts "Added $total_new_files new files to the existing project"
    } else {
        puts "No new files found - project is up to date"
    }
} else {
    puts "\nProject '$project_name' created successfully!"
}

puts "Project location: [file normalize $project_dir]"
puts ""
puts "Files organized as:"
puts "  - pkg/: SystemVerilog packages ([llength [get_files -quiet -of_objects [get_filesets sim_1] -filter {FILE_TYPE == SystemVerilog && NAME =~ *pkg/*}]] files)"
puts "  - src/: Verilog design files ([llength [get_files -quiet -filter {FILE_TYPE == Verilog}]] files)"  
puts "  - sim/: SystemVerilog testbenches ([llength [get_files -quiet -of_objects [get_filesets sim_1] -filter {NAME =~ *_tb.sv}]] files)"
puts "  - mem/: Memory initialization files ([llength [get_files -quiet -filter {NAME =~ *mem/* || FILE_TYPE == {Memory File} || FILE_TYPE == {Memory Initialization Files} || FILE_TYPE == {Coefficient Files}}]] files)"
puts ""
puts "You can now:"
puts "  1. Run synthesis with: launch_runs synth_1"
puts "  2. Run simulation with: launch_simulation"
puts "  3. Open the GUI with: start_gui"

# Success - script completed without errors
puts "\nScript completed successfully!"

} error_msg]} {
    puts "\nERROR: Script failed with error:"
    puts $error_msg
    puts "\nPlease check:"
    puts "  1. Vivado is properly installed and in PATH"
    puts "  2. You have write permissions in the current directory"
    puts "  3. The source directories (src/, sim/, pkg/) exist"
    puts "  4. No Vivado project is currently open"
    
    # Only exit in batch mode, return error in GUI mode
    if {$is_batch_mode} {
        exit 1
    } else {
        puts "\nScript failed in GUI mode - please fix the issues above and try again"
        error $error_msg
    }
}

# Only exit/return if we get here successfully (outside try-catch)
if {$is_batch_mode} {
    exit 0
} else {
    puts "Ready to use in GUI mode - project is open and ready!"
    return
}
