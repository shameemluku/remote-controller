# ✅ Flutter Installed Successfully!

## Current Status

- ✅ Flutter 3.35.6 installed
- ✅ VS Code installed
- ✅ Chrome available
- ✅ Flutter app dependencies installed
- ❌ Android Studio needed for Android development

---

## 🎯 Next Steps to Run Your IR Blast App

### Step 1: Install Android Studio (Required for Android Development)

**Download Android Studio:**
```
https://developer.android.com/studio
```

**Installation:**
1. Download Android Studio from the link above
2. Run the installer
3. Choose "Standard" installation
4. Install all components (Android SDK, Android Virtual Device)
5. Wait for installation (10-20 minutes)

**First Launch:**
1. Open Android Studio
2. Complete the setup wizard
3. It will download additional components
4. Wait for "Configure Android SDK" to complete

---

### Step 2: Accept Android Licenses

After Android Studio is installed, run:
```powershell
flutter doctor --android-licenses
```

Type 'y' to accept all licenses (usually 5-7 licenses)

---

### Step 3: Verify Installation

```powershell
flutter doctor
```

You should see:
```
[√] Flutter
[√] Android toolchain
[√] Android Studio
[√] VS Code
[√] Connected device
```

---

### Step 4: Create Android Emulator

**Option A: Using Android Studio (Easiest)**
1. Open Android Studio
2. Click "More Actions" → "Virtual Device Manager"
3. Click "+ Create Device"
4. Select "Pixel 6 Pro" → Next
5. Select System Image (API 34 - Android 14) → Download if needed
6. Click "Finish"
7. Click ▶️ Play button to start emulator

**Option B: Using Command Line**
```powershell
# List available emulators
flutter emulators

# Create new emulator (if none exist)
flutter emulators --create

# Launch emulator
flutter emulators --launch <emulator_id>
```

---

### Step 5: Run Your IR Blast App! 🚀

Once emulator is running:

```powershell
cd "c:\Users\lenovo\Desktop\IR Blast\flutter_ir_app"
flutter run
```

The app will build and launch on the emulator!

---

## 🧪 Testing the Complete System

### Terminal 1: Backend Server (Already Running ✅)
```powershell
cd "c:\Users\lenovo\Desktop\IR Blast"
npm start
```

### Terminal 2: Flutter App
```powershell
cd "c:\Users\lenovo\Desktop\IR Blast\flutter_ir_app"
flutter run
```

### In the Flutter App:
1. Server URL: `ws://10.0.2.2:8080`
2. Click "Connect"
3. Wait for "Connected" status

### Test with Postman:
```
POST http://localhost:3000/api/ac/temperature
Body: {"temperature": 24}
```

Observe: App receives command and updates UI!

---

## 📱 Alternative: Use Chrome (Web Version)

While waiting for Android Studio, you can test on Chrome:

```powershell
cd "c:\Users\lenovo\Desktop\IR Blast\flutter_ir_app"
flutter run -d chrome
```

**Note:** IR blaster won't work on web, but you can test the UI and WebSocket!

---

## ⚡ Quick Commands Reference

```powershell
# Check Flutter status
flutter doctor

# Check detailed info
flutter doctor -v

# List available devices
flutter devices

# List emulators
flutter emulators

# Run on specific device
flutter run -d <device_id>

# Run on Chrome
flutter run -d chrome

# Hot reload (while app is running)
Press: r

# Hot restart (while app is running)
Press: R

# Quit app
Press: q
```

---

## 🐛 Troubleshooting

### "Unable to locate Android SDK"
**Solution:** Install Android Studio, it includes Android SDK

### "No devices available"
**Solution:** Start an emulator or connect a physical device

### "cmdline-tools component is missing"
**Solution:**
1. Open Android Studio
2. Tools → SDK Manager → SDK Tools tab
3. Check "Android SDK Command-line Tools (latest)"
4. Click Apply

### Build errors
**Solution:**
```powershell
flutter clean
flutter pub get
flutter run
```

---

## ⏱️ Time Estimates

- Android Studio Download: 5-10 minutes
- Android Studio Install: 10-15 minutes
- First Setup: 5-10 minutes
- Create Emulator: 5 minutes
- First App Build: 5-10 minutes
- **Total: ~30-50 minutes**

---

## 🎉 What You Have So Far

✅ Flutter SDK installed and working
✅ VS Code ready
✅ Flutter app dependencies installed
✅ Backend server running
✅ All code ready to run

**Next:** Install Android Studio to run the app on Android!

---

## 📞 Need Help?

- Android Studio: https://developer.android.com/studio
- Flutter Setup: https://docs.flutter.dev/get-started/install/windows
- Emulator Setup: https://docs.flutter.dev/get-started/install/windows#android-setup

---

**Quick Start:** Download Android Studio now while I'm preparing the rest!
```
https://developer.android.com/studio
```

After installation, run:
```powershell
flutter doctor --android-licenses
flutter emulators --create
flutter run
```

🚀 You're almost there!
