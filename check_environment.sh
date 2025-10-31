#!/bin/bash

# PiCar-X Environment Validation Script
# Checks if the system is ready for PiCar-X installation

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

check_passed=0
check_failed=0

print_header() {
    echo "=========================================="
    echo "    PiCar-X Environment Validation"
    echo "=========================================="
    echo
}

check_item() {
    local description="$1"
    local test_command="$2"
    
    printf "%-40s" "$description"
    
    if eval "$test_command" &>/dev/null; then
        echo -e "${GREEN}✓ PASS${NC}"
        ((check_passed++))
    else
        echo -e "${RED}✗ FAIL${NC}"
        ((check_failed++))
    fi
}

check_gpio_access() {
    # Check if GPIO devices exist and user has access
    # Note: Modern Raspberry Pi OS uses /dev/gpiomem0, /dev/gpiomem1, etc.
    # instead of the legacy /dev/gpiomem device
    if ls /dev/gpiomem* /dev/gpiochip* &>/dev/null && groups | grep -q gpio; then
        return 0
    else
        return 1
    fi
}

check_item_with_output() {
    local description="$1"
    local test_command="$2"
    local expected_output="$3"
    
    printf "%-40s" "$description"
    
    output=$(eval "$test_command" 2>/dev/null)
    if [[ "$output" == *"$expected_output"* ]]; then
        echo -e "${GREEN}✓ PASS${NC}"
        ((check_passed++))
    else
        echo -e "${RED}✗ FAIL${NC}"
        ((check_failed++))
    fi
}

print_header

# System checks
echo -e "${BLUE}System Requirements:${NC}"
check_item "Raspberry Pi OS" "grep -q 'Raspberry Pi' /proc/device-tree/model"
check_item "Internet connection" "ping -c 1 google.com"
check_item "Sufficient disk space (>2GB)" "[[ \$(df / | tail -1 | awk '{print \$4}') -gt 2000000 ]]"
check_item "Python3 installed" "which python3"
check_item "Git installed" "which git"
check_item "Sudo privileges" "sudo -n true"

echo

# Package checks
echo -e "${BLUE}Package Dependencies:${NC}"
check_item "python3-pip available" "apt list python3-pip 2>/dev/null | grep -q python3-pip"
check_item "python3-setuptools available" "apt list python3-setuptools 2>/dev/null | grep -q python3-setuptools"
check_item "python3-smbus available" "apt list python3-smbus 2>/dev/null | grep -q python3-smbus"

echo

# Hardware checks
echo -e "${BLUE}Hardware Configuration:${NC}"
check_item "GPIO interface accessible" "check_gpio_access"
check_item "I2C interface available" "ls /dev/i2c-* 2>/dev/null | head -1"
check_item "SPI interface available" "ls /dev/spidev* 2>/dev/null | head -1"

echo

# Optional checks
echo -e "${BLUE}Optional Components:${NC}"
check_item "Camera interface" "ls /dev/video*"
check_item "Audio system" "aplay -l | grep -q card"

echo
echo "=========================================="
echo -e "Results: ${GREEN}$check_passed passed${NC}, ${RED}$check_failed failed${NC}"
echo "=========================================="

if [[ $check_failed -eq 0 ]]; then
    echo -e "${GREEN}✓ Your system is ready for PiCar-X installation!${NC}"
    echo "Run ./setup_picar_x.sh to begin setup."
    exit 0
elif [[ $check_failed -le 2 ]]; then
    echo -e "${YELLOW}⚠ Your system mostly ready, but some issues detected.${NC}"
    echo "You can proceed with installation, but may need to address failures."
    echo "Run ./setup_picar_x.sh to begin setup."
    exit 1
else
    echo -e "${RED}✗ Several issues detected. Please resolve them before installation.${NC}"
    echo
    echo "Common solutions:"
    echo "- Update system: sudo apt update && sudo apt upgrade"
    echo "- Install git: sudo apt install git"
    echo "- Enable interfaces: sudo raspi-config"
    echo "- Check internet connection"
    exit 2
fi