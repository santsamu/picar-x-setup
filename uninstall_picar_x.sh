#!/bin/bash

# PiCar-X Uninstall Script
# Removes PiCar-X modules and related files

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo "=========================================="
    echo "    PiCar-X Uninstall Script"
    echo "=========================================="
    echo
}

remove_python_packages() {
    log_info "Removing Python packages..."
    
    # Remove pip packages if they exist
    packages=("picarx" "robot-hat" "vilib")
    for package in "${packages[@]}"; do
        if pip3 list | grep -q "$package"; then
            log_info "Removing $package..."
            sudo pip3 uninstall -y "$package" 2>/dev/null || true
        fi
    done
    
    log_success "Python packages removed"
}

remove_source_directories() {
    log_info "Removing source directories..."
    
    directories=("~/robot-hat" "~/vilib" "~/picar-x")
    for dir in "${directories[@]}"; do
        if [[ -d "$dir" ]]; then
            log_info "Removing $dir..."
            rm -rf "$dir"
        fi
    done
    
    log_success "Source directories removed"
}

remove_helper_scripts() {
    log_info "Removing helper scripts..."
    
    scripts=("~/servo_zero.sh" "~/picar_test.py" "~/PICAR_X_README.md")
    for script in "${scripts[@]}"; do
        if [[ -f "$script" ]]; then
            log_info "Removing $script..."
            rm -f "$script"
        fi
    done
    
    log_success "Helper scripts removed"
}

cleanup_packages() {
    log_info "Cleaning up package cache..."
    sudo apt autoremove -y
    sudo apt autoclean
    log_success "Package cache cleaned"
}

main() {
    print_header
    
    log_warning "This script will remove all PiCar-X related files and packages."
    log_warning "This action cannot be undone."
    echo
    
    read -p "Are you sure you want to uninstall PiCar-X? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Uninstall cancelled by user."
        exit 0
    fi
    
    echo
    log_info "Starting PiCar-X uninstall process..."
    
    remove_python_packages
    remove_source_directories
    remove_helper_scripts
    cleanup_packages
    
    echo
    log_success "============================================"
    log_success "    PiCar-X Uninstall Complete!"
    log_success "============================================"
    echo
    log_info "Notes:"
    log_info "- I2C interface settings remain unchanged"
    log_info "- I2S audio settings remain unchanged"
    log_info "- System packages (git, python3-pip, etc.) remain installed"
    echo
    log_info "To reinstall PiCar-X, run ./setup_picar_x.sh"
}

main "$@"