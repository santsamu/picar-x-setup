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

The setup script automates the complete PiCar-X installation process based on the official SunFounder documentation, with modern Python environment support:

### 1. System Updates
- Updates package lists and upgrades system packages
- Installs Python3 dependencies (git, pip, setuptools, smbus, python3-full)

### 2. Modern Python Environment Support
- **PEP 668 Compliance**: Configures pip to handle externally managed environments
- **System Dependencies**: Installs system packages to reduce pip dependency issues
- **Updated Package Names**: Uses current package names (e.g., libgtk-3-0t64)

### 3. Module Installation
- **robot-hat** (v2.0): Core hardware abstraction layer (uses install.py method)
- **vilib** (picamera2 branch): Computer vision library
- **picar-x** (custom fork): Main PiCar-X control library from https://github.com/santsamu/picar-x.git

### 4. Audio Setup
- Installs I2S amplifier components for sound functionality
- Configures audio drivers for the PiCar-X speaker

### 5. Helper Scripts
- Creates servo zeroing script (`~/servo_zero.sh`)
- Creates basic test script (available in repository)
- Generates comprehensive README with usage instructions

## Manual Steps Required

The setup script now includes optional prompts for most steps, but some may require manual intervention:

### Enable I2C Interface
```bash
sudo raspi-config
# Navigate to: Interfacing Options > I2C > Yes > Finish
```

### Optional Manual Steps (if skipped during setup)

#### I2S Audio Setup
```bash
cd ~/picar-x
sudo bash i2samp.sh
```

#### Motor & Servo Calibration
```bash
cd ~/picar-x/example/calibration
sudo python3 calibration.py
```

#### Basic Servo Zeroing (if needed)
```bash
~/servo_zero.sh  # If the script was created
```

## Testing Your Installation

After setup, test your PiCar-X:
```bash
python3 ~/picar-x-setup/picar_test.py
```

## File Structure After Setup

```
~/
├── robot-hat/              # Robot HAT library source
├── vilib/                  # Vision library source
├── picar-x/               # PiCar-X library and examples
├── servo_zero.sh          # Servo calibration script (if created)
└── PICAR_X_README.md      # Detailed usage instructions

picar-x-setup/
└── picar_test.py          # Basic functionality test
```

## Troubleshooting

### PEP 668 Externally Managed Environment
If you see errors about "externally-managed-environment":
```bash
# The script automatically configures pip, but you can verify:
cat ~/.config/pip/pip.conf
# Should contain: break-system-packages = true
```

### Package Installation Errors
For system package conflicts:
```bash
sudo apt update
sudo apt install python3-full python3-dev build-essential
```

### Robot-hat Installation Issues
If robot-hat fails to install:
```bash
cd ~/robot-hat
sudo python3 install.py  # Use install.py, not setup.py
```

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

### GPIO Issues
Check GPIO devices and permissions:
```bash
ls -la /dev/gpio*
groups | grep gpio
```

Modern Raspberry Pi OS uses `/dev/gpiomem0`, `/dev/gpiomem1`, etc. instead of the legacy `/dev/gpiomem`.

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
- [Motor & Servo Calibration](https://docs.sunfounder.com/projects/picar-x/en/latest/python/python_calibrate.html#calibrate-motors-servo)

## Requirements

- Raspberry Pi with Raspberry Pi OS
- Internet connection for downloading packages
- PiCar-X hardware kit

## License

This setup script is provided as-is for educational purposes. The PiCar-X software and documentation are property of SunFounder.