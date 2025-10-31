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

# Check what's currently installed
check_installation() {
    log_info "Checking current PiCar-X installation..."
    
    found_packages=()
    packages=("picarx" "robot-hat" "vilib")
    for package in "${packages[@]}"; do
        if pip3 show "$package" &>/dev/null; then
            found_packages+=("$package")
            log_info "Found installed package: $package"
        fi
    done
    
    found_dirs=()
    directories=("$HOME/robot-hat" "$HOME/vilib" "$HOME/picar-x")
    for dir in "${directories[@]}"; do
        if [[ -d "$dir" ]]; then
            found_dirs+=("$dir")
            log_info "Found directory: $dir"
        fi
    done
    
    found_scripts=()
    scripts=("$HOME/servo_zero.sh" "$HOME/picar_test.py" "$HOME/PICAR_X_README.md")
    for script in "${scripts[@]}"; do
        if [[ -f "$script" ]]; then
            found_scripts+=("$script")
            log_info "Found script: $script"
        fi
    done
    
    if [[ ${#found_packages[@]} -eq 0 ]] && [[ ${#found_dirs[@]} -eq 0 ]] && [[ ${#found_scripts[@]} -eq 0 ]]; then
        log_warning "No PiCar-X installation found."
        return 1
    fi
    
    log_success "Found PiCar-X installation components."
    return 0
}

remove_python_packages() {
    log_info "Removing Python packages..."
    
    # Remove pip packages if they exist
    packages=("picarx" "robot-hat" "vilib")
    for package in "${packages[@]}"; do
        # Check if package is installed without broken pipe issues
        if pip3 show "$package" &>/dev/null; then
            log_info "Removing $package..."
            # Try regular uninstall first, then with sudo if needed
            if ! pip3 uninstall -y "$package" &>/dev/null; then
                log_warning "Standard uninstall failed, trying with sudo..."
                sudo pip3 uninstall -y "$package" &>/dev/null || true
            fi
        else
            log_info "Package $package not found (skipping)"
        fi
    done
    
    # Also remove any manually installed packages via setup.py
    log_info "Cleaning up any setup.py installed packages..."
    for package in "${packages[@]}"; do
        # Remove from site-packages if it exists
        python_dirs=$(python3 -c "import site; print('\n'.join(site.getsitepackages()))" 2>/dev/null || echo "/usr/local/lib/python3.*/site-packages")
        for pydir in $python_dirs; do
            if [[ -d "$pydir" ]]; then
                sudo find "$pydir" -name "*${package}*" -type d -exec rm -rf {} + 2>/dev/null || true
                sudo find "$pydir" -name "*${package}*" -type f -exec rm -f {} + 2>/dev/null || true
            fi
        done
    done
    
    log_success "Python packages check completed"
}

remove_source_directories() {
    log_info "Removing source directories..."
    
    directories=("$HOME/robot-hat" "$HOME/vilib" "$HOME/picar-x")
    for dir in "${directories[@]}"; do
        if [[ -d "$dir" ]]; then
            log_info "Removing $dir..."
            # First try regular removal, then use sudo if needed
            if ! rm -rf "$dir" 2>/dev/null; then
                log_warning "Permission denied, using sudo to remove $dir..."
                sudo rm -rf "$dir" 2>/dev/null || true
            fi
        else
            log_info "Directory $dir not found (skipping)"
        fi
    done
    
    log_success "Source directories check completed"
}

remove_helper_scripts() {
    log_info "Removing helper scripts..."
    
    scripts=("$HOME/servo_zero.sh" "$HOME/picar_test.py" "$HOME/PICAR_X_README.md")
    for script in "${scripts[@]}"; do
        if [[ -f "$script" ]]; then
            log_info "Removing $script..."
            rm -f "$script"
        else
            log_info "Script $script not found (skipping)"
        fi
    done
    
    log_success "Helper scripts check completed"
}

cleanup_packages() {
    log_info "Cleaning up package cache..."
    sudo apt autoremove -y &>/dev/null || true
    sudo apt autoclean &>/dev/null || true
    log_success "Package cache cleaned"
}

main() {
    print_header
    
    # Check if there's anything to uninstall
    if ! check_installation; then
        log_info "Nothing to uninstall. Exiting."
        exit 0
    fi
    
    echo
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