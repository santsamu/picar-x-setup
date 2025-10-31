#!/bin/bash

# PiCar-X Setup Script
# Based on the official SunFounder setup guide with custom picar-x fork
# Official guide: https://docs.sunfounder.com/projects/picar-x/en/latest/python/python_start/quick_guide_on_python.html
# Custom picar-x fork: https://github.com/santsamu/picar-x.git
#
# Usage:
#   ./setup_picar_x.sh              # Interactive mode (default: custom fork)
#   ./setup_picar_x.sh --custom-fork # Use custom fork directly
#   ./setup_picar_x.sh -c           # Use custom fork directly (short form)
#   ./setup_picar_x.sh --official   # Use official SunFounder repository
#   ./setup_picar_x.sh -o           # Use official repository (short form)

# Configuration - Repository URLs
ROBOT_HAT_REPO="https://github.com/sunfounder/robot-hat.git"
ROBOT_HAT_BRANCH="v2.0"
VILIB_REPO="https://github.com/sunfounder/vilib.git"
VILIB_BRANCH="picamera2"
PICAR_X_REPO="https://github.com/santsamu/picar-x.git"
PICAR_X_BRANCH="main"  # Using main branch for custom fork

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function
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

# Show usage information
show_usage() {
    echo "PiCar-X Setup Script"
    echo
    echo "Usage:"
    echo "  $0 [OPTION]"
    echo
    echo "Options:"
    echo "  -c, --custom-fork    Use custom fork (santsamu/picar-x) - Default"
    echo "  -o, --official      Use official SunFounder repository"
    echo "  -h, --help          Show this help message"
    echo
    echo "Examples:"
    echo "  $0                  # Interactive mode"
    echo "  $0 --custom-fork    # Use custom fork directly"
    echo "  $0 --official       # Use official repository"
    echo
}

# Check if running on Raspberry Pi
check_raspberry_pi() {
    log_info "Checking if running on Raspberry Pi..."
    if [[ ! -f /proc/device-tree/model ]] || ! grep -q "Raspberry Pi" /proc/device-tree/model; then
        log_warning "This script is designed for Raspberry Pi. Continuing anyway..."
    else
        log_success "Running on Raspberry Pi"
    fi
}

# Allow user to choose picar-x repository
choose_picar_x_repo() {
    # Check if --custom-fork argument was passed
    if [[ "$1" == "--custom-fork" ]] || [[ "$1" == "-c" ]]; then
        log_info "Using custom fork repository (from command line)"
        PICAR_X_REPO="https://github.com/santsamu/picar-x.git"
        PICAR_X_BRANCH="main"
        return
    fi
    
    # Check if --official argument was passed
    if [[ "$1" == "--official" ]] || [[ "$1" == "-o" ]]; then
        log_info "Using official SunFounder repository (from command line)"
        PICAR_X_REPO="https://github.com/sunfounder/picar-x.git"
        PICAR_X_BRANCH="v2.0"
        return
    fi
    
    echo
    log_info "Choose PiCar-X repository:"
    echo "1. Custom fork (santsamu/picar-x) - Default"
    echo "2. Official SunFounder repository (sunfounder/picar-x v2.0)"
    echo
    
    read -p "Enter your choice (1-2) [1]: " -r choice
    choice=${choice:-1}
    
    case $choice in
        2)
            log_info "Using official SunFounder repository"
            PICAR_X_REPO="https://github.com/sunfounder/picar-x.git"
            PICAR_X_BRANCH="v2.0"
            ;;
        *)
            log_info "Using custom fork repository"
            PICAR_X_REPO="https://github.com/santsamu/picar-x.git"
            PICAR_X_BRANCH="main"
            ;;
    esac
    
    log_success "Repository selected: $PICAR_X_REPO (branch: $PICAR_X_BRANCH)"
}

# Update system
update_system() {
    log_info "Updating system packages..."
    sudo apt update
    sudo apt upgrade -y
    log_success "System updated successfully"
}

# Install Python3 dependencies (required for Lite OS)
install_python_deps() {
    log_info "Installing Python3 dependencies..."
    sudo apt install -y git python3-pip python3-setuptools python3-smbus
    log_success "Python3 dependencies installed"
}

# Install robot-hat module
install_robot_hat() {
    log_info "Installing robot-hat module..."
    cd ~/
    if [[ -d "robot-hat" ]]; then
        log_warning "robot-hat directory exists, removing..."
        rm -rf robot-hat
    fi
    
    git clone -b "$ROBOT_HAT_BRANCH" "$ROBOT_HAT_REPO"
    cd robot-hat
    sudo python3 setup.py install
    log_success "robot-hat module installed"
}

# Install vilib module
install_vilib() {
    log_info "Installing vilib module..."
    cd ~/
    if [[ -d "vilib" ]]; then
        log_warning "vilib directory exists, removing..."
        rm -rf vilib
    fi
    
    git clone -b "$VILIB_BRANCH" "$VILIB_REPO"
    cd vilib
    sudo python3 install.py
    log_success "vilib module installed"
}

# Install picar-x module
install_picar_x() {
    if [[ "$PICAR_X_REPO" == *"santsamu"* ]]; then
        log_info "Installing picar-x module (using custom fork)..."
    else
        log_info "Installing picar-x module (using official repository)..."
    fi
    
    cd ~/
    if [[ -d "picar-x" ]]; then
        log_warning "picar-x directory exists, removing..."
        rm -rf picar-x
    fi
    
    log_info "Cloning from $PICAR_X_REPO (branch: $PICAR_X_BRANCH)"
    if [[ "$PICAR_X_BRANCH" == "main" ]]; then
        git clone "$PICAR_X_REPO" --depth 1
    else
        git clone -b "$PICAR_X_BRANCH" "$PICAR_X_REPO" --depth 1
    fi
    cd picar-x
    sudo python3 setup.py install
    
    if [[ "$PICAR_X_REPO" == *"santsamu"* ]]; then
        log_success "picar-x module installed from custom fork"
    else
        log_success "picar-x module installed from official repository"
    fi
}

# Install I2S amplifier components
install_i2s_amplifier() {
    log_info "Installing I2S amplifier components..."
    cd ~/picar-x
    
    log_warning "The i2samp.sh script will prompt for user input."
    log_warning "You will need to press 'y' and Enter three times during the installation."
    log_warning "The system will automatically reboot after installation."
    
    read -p "Press Enter to continue with I2S amplifier installation..."
    
    sudo bash i2samp.sh
    log_success "I2S amplifier components installed"
}

# Enable I2C interface
enable_i2c() {
    log_info "Checking I2C interface status..."
    
    # Check if I2C is already enabled
    if grep -q "dtparam=i2c_arm=on" /boot/config.txt; then
        log_success "I2C interface is already enabled"
        return 0
    fi
    
    log_warning "I2C interface needs to be enabled manually."
    log_warning "Please run 'sudo raspi-config' and:"
    log_warning "1. Select 'Interfacing Options'"
    log_warning "2. Select 'I2C'"
    log_warning "3. Select 'Yes' to enable I2C"
    log_warning "4. Select 'Finish' and reboot when prompted"
    
    read -p "Have you enabled I2C interface? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_error "I2C interface must be enabled. Please run 'sudo raspi-config' and enable I2C."
        exit 1
    fi
    
    log_success "I2C interface confirmed as enabled"
}

# Create servo zeroing script
create_servo_script() {
    log_info "Creating servo zeroing convenience script..."
    
    cat > ~/servo_zero.sh << 'EOF'
#!/bin/bash
# Servo Zeroing Script for PiCar-X
# This script runs the servo_zeroing.py to set servos to 0 degrees

echo "Setting all servos to 0 degrees..."
echo "Make sure to connect servo to P11 port before running this."
cd ~/picar-x/example
sudo python3 servo_zeroing.py
echo "Servo zeroing complete!"
EOF
    
    chmod +x ~/servo_zero.sh
    log_success "Servo zeroing script created at ~/servo_zero.sh"
}

# Create test script
create_test_script() {
    log_info "Creating basic test script..."
    
    cat > ~/picar_test.py << 'EOF'
#!/usr/bin/env python3
"""
Basic PiCar-X Test Script
This script performs basic functionality tests
"""

try:
    import picarx
    print("✓ PiCar-X module imported successfully")
    
    # Initialize PiCar-X
    px = picarx.Picarx()
    print("✓ PiCar-X initialized successfully")
    
    # Test basic movement (very brief)
    print("Testing basic movement...")
    px.forward(10)
    import time
    time.sleep(0.5)
    px.stop()
    print("✓ Basic movement test completed")
    
    print("\n🎉 All tests passed! PiCar-X is ready to use.")
    
except ImportError as e:
    print(f"❌ Import error: {e}")
    print("Please ensure all modules are installed correctly.")
except Exception as e:
    print(f"❌ Test error: {e}")
    print("Please check your PiCar-X setup and connections.")
EOF
    
    chmod +x ~/picar_test.py
    log_success "Test script created at ~/picar_test.py"
}

# Create README with instructions
create_readme() {
    log_info "Creating README with usage instructions..."
    
    cat > ~/PICAR_X_README.md << 'EOF'
# PiCar-X Setup Complete

Your PiCar-X has been set up according to the official SunFounder guide.

## What was installed:
- robot-hat module (v2.0)
- vilib module (picamera2 branch)
- picar-x module (v2.0)
- I2S amplifier components
- Python3 dependencies

## Important Notes:

### I2C Interface
Make sure I2C interface is enabled:
```bash
sudo raspi-config
# Navigate to: Interfacing Options > I2C > Yes
```

### Servo Calibration
Before assembly, calibrate each servo to 0°:
```bash
~/servo_zero.sh
```
Then connect servo to P11 port and follow assembly instructions.

### Testing Your Setup
Run the basic test:
```bash
python3 ~/picar_test.py
```

### Example Code Location
Official examples are in: `~/picar-x/example/`

### Troubleshooting
- If no sound after reboot, run the i2samp.sh script again:
  ```bash
  cd ~/picar-x
  sudo bash i2samp.sh
  ```
- Check I2C devices: `sudo i2cdetect -y 1`
- Verify modules: `python3 -c "import picarx; print('PiCar-X OK')"`

## Official Documentation
https://docs.sunfounder.com/projects/picar-x/en/latest/

Happy coding with your PiCar-X! 🚗
EOF
    
    log_success "README created at ~/PICAR_X_README.md"
}

# Main installation function
main() {
    # Handle help option
    if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
        show_usage
        exit 0
    fi
    
    echo "=========================================="
    echo "    PiCar-X Setup Script v1.0"
    echo "    Based on SunFounder Official Guide"
    echo "    Using custom picar-x fork"
    echo "=========================================="
    echo
    
    check_raspberry_pi
    choose_picar_x_repo "$1"
    
    log_info "Starting PiCar-X setup process..."
    log_warning "This script will install packages and may take some time."
    log_warning "Make sure you have a stable internet connection."
    echo
    
    read -p "Continue with installation? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Installation cancelled by user."
        exit 0
    fi
    
    # Run installation steps
    update_system
    install_python_deps
    install_robot_hat
    install_vilib
    install_picar_x
    
    # Create helper scripts
    create_servo_script
    create_test_script
    create_readme
    
    echo
    log_success "============================================"
    log_success "    PiCar-X Setup Complete!"
    log_success "============================================"
    echo
    log_info "Next steps:"
    log_info "1. Enable I2C interface: sudo raspi-config"
    log_info "2. Install I2S amplifier: cd ~/picar-x && sudo bash i2samp.sh"
    log_info "3. Calibrate servos: ~/servo_zero.sh"
    log_info "4. Test installation: python3 ~/picar_test.py"
    echo
    log_info "Read ~/PICAR_X_README.md for detailed instructions."
    echo
    
    # Prompt for I2C setup
    read -p "Would you like to open raspi-config to enable I2C now? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        log_info "Opening raspi-config..."
        sudo raspi-config
    fi
    
    # Prompt for I2S installation
    echo
    read -p "Would you like to install I2S amplifier components now? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        install_i2s_amplifier
    else
        log_warning "Remember to run: cd ~/picar-x && sudo bash i2samp.sh"
    fi
}

# Run main function
main "$@"