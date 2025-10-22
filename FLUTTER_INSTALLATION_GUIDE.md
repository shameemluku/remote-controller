# Flutter Installation Guide - Step by Step

## Current Status: Flutter is NOT installed

Follow these steps to install Flutter on Windows:

---

## 📥 Step 1: Download Flutter SDK

### Option A: Official Website
1. Go to: **https://docs.flutter.dev/get-started/install/windows**
2. Click "Download Flutter SDK"
3. Save the ZIP file to your Downloads folder

### Option B: Direct Download
Download directly from:
```
https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.24.3-stable.zip
```

**File size:** ~1.5 GB
**Download time:** 5-15 minutes (depending on internet speed)

---

## 📦 Step 2: Extract Flutter

1. Locate the downloaded ZIP file in your Downloads folder
2. Right-click the ZIP file → Extract All...
3. **Extract to:** `C:\flutter`
   
   **Important:** 
   - Do NOT use `C:\Program Files`
   - Avoid paths with spaces
   - Use `C:\flutter` exactly as shown

4. Wait for extraction (2-3 minutes)

---

## 🔧 Step 3: Add Flutter to PATH

### Visual Guide:

1. **Open Environment Variables:**
   - Press `Win + R` on your keyboard
   - Type: `sysdm.cpl`
   - Press Enter
   - Click the "Advanced" tab
   - Click "Environment Variables" button

2. **Edit PATH:**
   - Under "User variables for [your name]"
   - Find and select "Path"
   - Click "Edit" button
   - Click "New" button
   - Type: `C:\flutter\bin`
   - Click "OK"
   - Click "OK" again
   - Click "OK" one more time

### Alternative Method (PowerShell):

Run this in PowerShell (as Administrator):
```powershell
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\flutter\bin", "User")
```

---

## ✅ Step 4: Verify Installation

1. **Close ALL PowerShell/Command Prompt windows**
2. **Open a NEW PowerShell window** (Important - must be new!)
3. Run this command:
   ```bash
   flutter --version
   ```

   **Expected output:**
   ```
   Flutter 3.24.3 • channel stable
   Framework • revision abc123
   Engine • revision def456
   Tools • Dart 3.5.3 • DevTools 2.37.2
   ```

4. Run Flutter Doctor:
   ```bash
   flutter doctor
   ```

   This will check your system and show what's needed.

---

## 📱 Step 5: Install Android Studio (if not installed)

Flutter Doctor will show if Android Studio is needed.

1. Download: https://developer.android.com/studio
2. Run the installer
3. Choose "Standard" installation
4. Install all components (including Android SDK)

---

## ✓ Step 6: Accept Android Licenses

Run this command:
```bash
flutter doctor --android-licenses
```

- Type `y` and press Enter for each license
- There are usually 5-7 licenses
- This is required to build Android apps

---

## 🚀 Step 7: Run Your IR Blast App!

Once Flutter is installed and configured:

```powershell
# Navigate to the app folder
cd "c:\Users\lenovo\Desktop\IR Blast\flutter_ir_app"

# Install dependencies
flutter pub get

# Check for connected devices
flutter devices

# Run the app
flutter run
```

---

## 🐛 Troubleshooting

### "flutter: command not found"

**Solution:**
1. Make sure you added `C:\flutter\bin` to PATH correctly
2. Close and reopen PowerShell (PATH changes require restart)
3. Verify PATH:
   ```powershell
   $env:Path
   ```
   Should include `C:\flutter\bin`

### "Unable to locate Android SDK"

**Solution:**
1. Install Android Studio
2. Open Android Studio
3. Go to Settings → Appearance & Behavior → System Settings → Android SDK
4. Note the SDK location
5. Run:
   ```bash
   flutter config --android-sdk "C:\Users\YourName\AppData\Local\Android\Sdk"
   ```

### "cmdline-tools component is missing"

**Solution:**
1. Open Android Studio
2. Tools → SDK Manager
3. SDK Tools tab
4. Check "Android SDK Command-line Tools"
5. Click Apply

---

## ✨ Quick Reference

### Essential Commands

```bash
# Check Flutter version
flutter --version

# Check system configuration
flutter doctor

# Check detailed info
flutter doctor -v

# Accept licenses
flutter doctor --android-licenses

# List connected devices
flutter devices

# Install dependencies
flutter pub get

# Run app
flutter run

# Clean build
flutter clean
```

---

## 📊 System Requirements

- **OS:** Windows 10 or later (64-bit)
- **Disk Space:** 2.5 GB (not including IDE/tools)
- **Tools:** Git for Windows
- **Optional:** Android Studio, VS Code

---

## 🎯 After Installation

Once Flutter is installed successfully, you'll see:

```
flutter doctor
```

Output should show:
```
[✓] Flutter (Channel stable, 3.24.3)
[✓] Android toolchain
[✓] Android Studio
[✓] Connected device
[!] No issues found!
```

Then you're ready to run the IR Blast app!

---

## 📞 Need Help?

- Flutter Docs: https://docs.flutter.dev
- Flutter Installation: https://docs.flutter.dev/get-started/install/windows
- Community: https://flutter.dev/community

---

## ⏱️ Estimated Time

- **Download:** 5-15 minutes
- **Extract:** 2-3 minutes
- **Setup PATH:** 1 minute
- **Android Studio:** 20-30 minutes (if needed)
- **Total:** ~30-50 minutes

---

**Current Next Step:** Download Flutter SDK from the link above!

After downloading, follow Step 2 to extract and configure Flutter.
