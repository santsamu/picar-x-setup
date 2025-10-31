# PiCar-X Setup Project

This project provides an automated setup script for the SunFounder PiCar-X robot car, following the official setup guide.

## Quick Start

Run the setup script:
```bash
./setup_picar_x.sh
```

Or use command-line options:
```bash
./setup_picar_x.sh --custom-fork    # Use custom fork (default)
./setup_picar_x.sh --official       # Use official SunFounder repository  
./setup_picar_x.sh --help           # Show usage information
```

## What This Script Does

The setup script automates the complete PiCar-X installation process based on the official SunFounder documentation:

### 1. System Updates
- Updates package lists and upgrades system packages
- Installs Python3 dependencies (git, pip, setuptools, smbus)

### 2. Module Installation
- **robot-hat** (v2.0): Core hardware abstraction layer
- **vilib** (picamera2 branch): Computer vision library
- **picar-x** (custom fork): Main PiCar-X control library from https://github.com/santsamu/picar-x.git

### 3. Audio Setup
- Installs I2S amplifier components for sound functionality
- Configures audio drivers for the PiCar-X speaker

### 4. Helper Scripts
- Creates servo zeroing script (`~/servo_zero.sh`)
- Creates basic test script (`~/picar_test.py`)
- Generates comprehensive README with usage instructions

## Manual Steps Required

Some steps require manual intervention:

### Enable I2C Interface
```bash
sudo raspi-config
# Navigate to: Interfacing Options > I2C > Yes > Finish
```

### Servo Calibration
Before assembly, calibrate each servo:
```bash
~/servo_zero.sh
```

## Testing Your Installation

After setup, test your PiCar-X:
```bash
python3 ~/picar_test.py
```

## File Structure After Setup

```
~/
├── robot-hat/              # Robot HAT library source
├── vilib/                  # Vision library source
├── picar-x/               # PiCar-X library and examples
├── servo_zero.sh          # Servo calibration script
├── picar_test.py          # Basic functionality test
└── PICAR_X_README.md      # Detailed usage instructions
```

## Troubleshooting

### No Sound After Reboot
Run the I2S script again:
```bash
cd ~/picar-x
sudo bash i2samp.sh
```

### Import Errors
Verify installation:
```bash
python3 -c "import picarx; print('PiCar-X module OK')"
python3 -c "import robot_hat; print('Robot HAT module OK')"
```

### I2C Issues
Check I2C devices:
```bash
sudo i2cdetect -y 1
```

## Official Documentation

This setup follows the official SunFounder guide:
- [Quick Guide on Python](https://docs.sunfounder.com/projects/picar-x/en/latest/python/python_start/quick_guide_on_python.html)
- [Install All Modules](https://docs.sunfounder.com/projects/picar-x/en/latest/python/python_start/install_all_modules.html)
- [Enable I2C Interface](https://docs.sunfounder.com/projects/picar-x/en/latest/python/python_start/enable_i2c.html)
- [Servo Adjust](https://docs.sunfounder.com/projects/picar-x/en/latest/python/python_start/py_servo_adjust.html)

## Requirements

- Raspberry Pi with Raspberry Pi OS
- Internet connection for downloading packages
- PiCar-X hardware kit

## License

This setup script is provided as-is for educational purposes. The PiCar-X software and documentation are property of SunFounder.