#!/usr/bin/env python3
"""
Basic PiCar-X Test Script
This script performs basic functionality tests including movement, camera, and audio
"""

import time
import sys

def test_basic_functionality():
    """Test basic PiCar-X functionality"""
    try:
        import picarx
        print("✓ PiCar-X module imported successfully")
        
        # Initialize PiCar-X
        px = picarx.Picarx()
        print("✓ PiCar-X initialized successfully")
        
        # Test basic movement (very brief)
        print("Testing basic movement...")
        px.forward(10)
        time.sleep(0.5)
        px.stop()
        print("✓ Basic movement test completed")
        
        return True
        
    except ImportError as e:
        print(f"❌ Import error: {e}")
        print("Please ensure all modules are installed correctly.")
        return False
    except Exception as e:
        print(f"❌ Basic test error: {e}")
        print("Please check your PiCar-X setup and connections.")
        return False

def test_camera():
    """Test camera functionality"""
    print("\nTesting camera functionality...")
    try:
        # Try to import camera libraries
        import cv2
        print("✓ OpenCV imported successfully")
        
        # Test camera capture with different backends
        camera_devices = [0, 1]  # Try multiple camera indices
        
        for device in camera_devices:
            cap = cv2.VideoCapture(device)
            if cap.isOpened():
                ret, frame = cap.read()
                cap.release()
                
                if ret and frame is not None:
                    print(f"✓ Camera capture successful on device {device} (frame size: {frame.shape})")
                    return True
                else:
                    print(f"⚠️  Camera device {device} opened but capture failed")
            else:
                print(f"⚠️  Camera device {device} not accessible")
        
        # Try Raspberry Pi camera module if available
        try:
            from picamera2 import Picamera2
            print("✓ Picamera2 available, testing Pi camera...")
            picam2 = Picamera2()
            picam2.start()
            time.sleep(1)
            picam2.stop()
            print("✓ Raspberry Pi camera test successful")
            return True
        except ImportError:
            print("⚠️  Picamera2 not available")
        except Exception as e:
            print(f"⚠️  Pi camera test failed: {e}")
        
        print("❌ No working camera found")
        return False
            
    except ImportError as e:
        print(f"❌ Camera test - Import error: {e}")
        print("OpenCV may not be installed or camera libraries missing")
        return False
    except Exception as e:
        print(f"❌ Camera test error: {e}")
        return False

def test_audio():
    """Test audio functionality"""
    print("\nTesting audio functionality...")
    try:
        # Test TTS (Text-to-Speech)
        import robot_hat
        from robot_hat import TTS
        print("✓ Robot HAT TTS module imported successfully")
        
        tts = TTS()
        print("✓ TTS initialized successfully")
        
        # Test basic TTS functionality (brief test)
        print("Testing TTS (you should hear 'PiCar-X test')...")
        tts.say("PiCar-X test")
        time.sleep(1)  # Give time for audio to play
        print("✓ TTS test completed")
        
        return True
        
    except ImportError as e:
        print(f"❌ Audio test - Import error: {e}")
        print("Robot HAT TTS module may not be available")
        return False
    except Exception as e:
        print(f"❌ Audio test error: {e}")
        print("Audio system may not be properly configured")
        return False

def test_servo_functionality():
    """Test servo functionality"""
    print("\nTesting servo functionality...")
    try:
        import picarx
        px = picarx.Picarx()
        
        # Test camera pan/tilt servos
        print("Testing camera pan servo...")
        px.cam_pan.angle(0)  # Center position
        time.sleep(0.5)
        print("✓ Camera pan servo test completed")
        
        print("Testing camera tilt servo...")
        px.cam_tilt.angle(0)  # Center position  
        time.sleep(0.5)
        print("✓ Camera tilt servo test completed")
        
        print("Testing steering servo...")
        px.dir_servo_pin.angle(0)  # Straight ahead
        time.sleep(0.5)
        print("✓ Steering servo test completed")
        
        return True
        
    except Exception as e:
        print(f"❌ Servo test error: {e}")
        print("Servo hardware may not be connected or calibrated")
        return False

def main():
    """Main test function"""
    print("🚗 PiCar-X Comprehensive Test Suite")
    print("=" * 40)
    
    # Track test results
    tests = []
    
    # Run basic functionality test
    tests.append(("Basic Functionality", test_basic_functionality()))
    
    # Run camera test
    tests.append(("Camera", test_camera()))
    
    # Run audio test  
    tests.append(("Audio/TTS", test_audio()))
    
    # Run servo test
    tests.append(("Servo Control", test_servo_functionality()))
    
    # Print summary
    print("\n" + "=" * 40)
    print("📊 Test Results Summary:")
    print("=" * 40)
    
    passed = 0
    total = len(tests)
    
    for test_name, result in tests:
        status = "✓ PASS" if result else "❌ FAIL"
        print(f"{test_name:<20} {status}")
        if result:
            passed += 1
    
    print("=" * 40)
    print(f"Tests passed: {passed}/{total}")
    
    if passed == total:
        print("\n🎉 All tests passed! PiCar-X is fully functional.")
        return 0
    elif passed > 0:
        print(f"\n⚠️  {total - passed} test(s) failed. Check connections and configuration.")
        return 1
    else:
        print("\n❌ All tests failed. Please check your PiCar-X installation.")
        return 2

if __name__ == "__main__":
    try:
        exit_code = main()
        sys.exit(exit_code)
    except KeyboardInterrupt:
        print("\n\n⚠️  Test interrupted by user")
        sys.exit(130)