#!/bin/bash

# setup_vivado.sh - Create/Update Vivado project for golden-rv
# Created by GitHub Copilot to automate Vivado project setup

set -e  # Exit on any error

echo "=== Golden RISC-V Vivado Project Setup ==="

# Check if Vivado is available
if ! command -v vivado &> /dev/null; then
    echo "ERROR: Vivado not found in PATH"
    echo "Please source Vivado settings first:"
    echo "  source /path/to/Vivado/settings64.sh"
    exit 1
fi

# Check if we're in the right directory
if [[ ! -f "make_project.tcl" ]]; then
    echo "ERROR: make_project.tcl not found in current directory"
    echo "Please run this script from the project root directory"
    exit 1
fi

# Create logs directory
mkdir -p logs

# Run the TCL script
echo "Running Vivado project setup..."
echo ""

if vivado -mode batch -source make_project.tcl -log "logs/vivado_setup.log" -journal "logs/vivado_setup.jou"; then
    echo ""
    echo "=== Setup Complete ==="
    echo "To open the project: vivado vivado_project/golden_rv.xpr"
    echo "Logs saved to: logs/vivado_setup.log"
else
    echo ""
    echo "Setup failed! Check the logs for details:"
    echo "  Log file: logs/vivado_setup.log"
    echo "  Journal: logs/vivado_setup.jou"
    exit 1
fi
