# PiCar-X Setup - Quick Usage Guide

## Scripts Overview

This project provides three main scripts for PiCar-X setup and management:

### 🔍 `check_environment.sh`
**Purpose**: Validates that your system meets PiCar-X requirements
```bash
./check_environment.sh
```
**What it checks**:
- Raspberry Pi OS compatibility
- Internet connectivity
- Required packages availability
- Hardware interfaces (GPIO, I2C, SPI)
- Disk space and permissions

### 🚀 `setup_picar_x.sh` 
**Purpose**: Complete automated installation of PiCar-X
```bash
./setup_picar_x.sh                 # Interactive mode (custom fork default)
./setup_picar_x.sh --custom-fork   # Use custom fork directly
./setup_picar_x.sh --official      # Use official SunFounder repository
./setup_picar_x.sh --help          # Show usage information
```
**What it installs**:
- Updates system packages
- Installs Python dependencies
- Downloads and installs robot-hat, vilib, and picar-x modules
- Allows choice between custom fork (santsamu/picar-x) and official repository
- Sets up I2S audio components
- Creates helper scripts and documentation

### 🗑️ `uninstall_picar_x.sh`
**Purpose**: Removes PiCar-X installation and files
```bash
./uninstall_picar_x.sh
```
**What it removes**:
- Python packages (picarx, robot-hat, vilib)
- Source directories
- Helper scripts
- Cleans package cache

## Recommended Workflow

1. **Check your environment first**:
   ```bash
   ./check_environment.sh
   ```

2. **If environment is ready, run setup**:
   ```bash
   ./setup_picar_x.sh
   ```

3. **Follow post-installation steps**:
   - Enable I2C interface: `sudo raspi-config`
   - Install I2S audio: `cd ~/picar-x && sudo bash i2samp.sh`
   - Calibrate servos: `~/servo_zero.sh`
   - Test installation: `python3 ~/picar_test.py`

## Post-Installation Files

After successful installation, you'll find:

- `~/robot-hat/` - Robot HAT library source
- `~/vilib/` - Computer vision library source  
- `~/picar-x/` - PiCar-X library and examples
- `~/servo_zero.sh` - Servo calibration script
- `~/picar_test.py` - Basic functionality test
- `~/PICAR_X_README.md` - Detailed usage guide

## Troubleshooting

### Script Permission Issues
```bash
chmod +x *.sh
```

### Network Issues During Setup
- Check internet connection
- Try running setup again (script handles existing installations)

### Module Import Errors After Installation
```bash
python3 -c "import picarx; print('Success')"
```

### Need to Reinstall
```bash
./uninstall_picar_x.sh
./setup_picar_x.sh
```

## Safety Notes

- Always calibrate servos before assembly to prevent damage
- Enable I2C interface before using hardware
- Test with basic scripts before complex operations
- Keep backup power source during long operations

## Support

- Official Documentation: https://docs.sunfounder.com/projects/picar-x/
- SunFounder Forum: https://forum.sunfounder.com/
- GitHub Issues: Use this repository's issue tracker

Happy building! 🚗