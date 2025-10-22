# Flutter Installation Guide for Windows

## 📥 Step-by-Step Installation

### 1. Install Flutter SDK

1. **Download Flutter**
   - Go to: https://docs.flutter.dev/get-started/install/windows
   - Download latest stable release (ZIP file)

2. **Extract Flutter**
   ```powershell
   # Extract to C:\flutter (or your preferred location)
   # Avoid Program Files or paths with spaces
   ```

3. **Add Flutter to PATH**
   - Search "Environment Variables" in Windows
   - Edit "Path" variable
   - Add: `C:\flutter\bin`
   - Click OK

4. **Verify Installation**
   ```bash
   flutter --version
   flutter doctor
   ```

### 2. Install Android Studio

1. **Download**
   - Go to: https://developer.android.com/studio
   - Download latest version
   - Run installer

2. **During Installation**
   - ✅ Android SDK
   - ✅ Android SDK Platform
   - ✅ Android Virtual Device

3. **First Launch Setup**
   - Choose "Standard" installation
   - Download all components

### 3. Configure Flutter for Android

```bash
# Accept Android licenses
flutter doctor --android-licenses

# Type 'y' for all prompts
```

### 4. Install Visual Studio Code (Optional but Recommended)

1. Download VS Code: https://code.visualstudio.com/
2. Install Flutter extension
3. Install Dart extension

### 5. Create Android Emulator

#### Option A: Android Studio GUI

1. Open Android Studio
2. More Actions → Virtual Device Manager
3. Create Device
4. Select: Pixel 6 Pro
5. Download System Image: API 34 (Android 14)
6. Finish

#### Option B: Command Line

```bash
# List available system images
sdkmanager --list

# Create emulator
avdmanager create avd -n ir_blast_test -k "system-images;android-34;google_apis;x86_64"

# List emulators
flutter emulators

# Launch emulator
flutter emulators --launch ir_blast_test
```

### 6. Verify Everything

```bash
flutter doctor -v
```

Expected output:
```
[✓] Flutter (Channel stable, ...)
[✓] Android toolchain
[✓] Android Studio
[✓] VS Code
[✓] Connected device (emulator)
```

## 🚀 Quick Start Commands

### Navigate to Project
```powershell
cd "c:\Users\lenovo\Desktop\IR Blast\flutter_ir_app"
```

### Install Dependencies
```bash
flutter pub get
```

### Check Available Devices
```bash
flutter devices
```

### Run App
```bash
# On connected device/emulator
flutter run

# On specific device
flutter run -d <device_id>

# In release mode
flutter run --release
```

### Hot Reload
While app is running:
- Press `r` - Hot reload
- Press `R` - Hot restart
- Press `q` - Quit

## 🔧 Troubleshooting

### "cmdline-tools component is missing"

```bash
# Open Android Studio
# Tools → SDK Manager → SDK Tools
# Check "Android SDK Command-line Tools"
# Click Apply
```

### "Unable to locate Android SDK"

```bash
# Set environment variable
$env:ANDROID_SDK_ROOT = "C:\Users\<YourUsername>\AppData\Local\Android\Sdk"

# Add to PATH permanently via System Properties → Environment Variables
```

### "Unable to find bundled Java version"

```bash
# Set JAVA_HOME
$env:JAVA_HOME = "C:\Program Files\Android\Android Studio\jbr"
```

### Emulator Won't Start

```bash
# Enable Hyper-V (Windows 10/11 Pro)
# Or use Android Studio's emulator with HAXM

# Check virtualization in BIOS
# Restart and enter BIOS
# Enable VT-x or AMD-V
```

### Port Already in Use

```bash
# Flutter uses port 8080 by default
# Kill process on port 8080
netstat -ano | findstr :8080
taskkill /PID <PID> /F
```

## 📱 Running the IR Blast App

### 1. Start Node.js Server (First Terminal)
```powershell
cd "c:\Users\lenovo\Desktop\IR Blast"
npm start
```

### 2. Start Emulator (Second Terminal)
```powershell
cd "c:\Users\lenovo\Desktop\IR Blast\flutter_ir_app"

# List emulators
flutter emulators

# Launch
flutter emulators --launch <emulator_name>
```

### 3. Run Flutter App (Same or Third Terminal)
```powershell
# Wait for emulator to fully start (shows home screen)
flutter run
```

### 4. Test Connection
- In app, enter: `ws://10.0.2.2:8080`
- Click "Connect"
- Should see "Connected" status

### 5. Send Command from Postman
```
POST http://localhost:3000/api/ac/temperature
Body: {"temperature": 24}
```

### 6. Observe
- Flutter app receives command
- Check Activity Logs in app

## 🎯 Common Flutter Commands

```bash
# Clean build
flutter clean

# Get dependencies
flutter pub get

# Update dependencies
flutter pub upgrade

# Build APK
flutter build apk

# Build for release
flutter build apk --release

# Install on device
flutter install

# Show logs
flutter logs

# Analyze code
flutter analyze

# Format code
flutter format .
```

## 📋 Checklist

- [ ] Flutter SDK installed and in PATH
- [ ] Android Studio installed
- [ ] Android SDK installed
- [ ] Android licenses accepted
- [ ] Emulator created
- [ ] `flutter doctor` shows all green
- [ ] Project dependencies installed (`flutter pub get`)
- [ ] Emulator running
- [ ] Node.js server running
- [ ] App running on emulator
- [ ] Connected to WebSocket server

## 💡 Pro Tips

1. **Use VS Code** for Flutter development
2. **Keep emulator running** during development
3. **Use hot reload** (`r`) for instant updates
4. **Check logs** if something doesn't work
5. **Use `flutter doctor`** to diagnose issues

## 🔗 Resources

- Flutter Installation: https://docs.flutter.dev/get-started/install/windows
- Android Studio: https://developer.android.com/studio
- Flutter Docs: https://docs.flutter.dev
- Dart Packages: https://pub.dev

---

Need help? Run `flutter doctor -v` and check the output!
