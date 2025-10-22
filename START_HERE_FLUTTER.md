# FLUTTER INSTALLATION - QUICK START

## ⚡ What You Need to Do

Flutter is NOT currently installed on your system.

---

## 🎯 3-Step Installation (Easiest Method)

### Step 1: Download (5-10 minutes)
```
Open this link in your browser:
https://docs.flutter.dev/get-started/install/windows

Click "Download Flutter SDK" button
Save the ZIP file
```

### Step 2: Extract & Setup (5 minutes)
```
1. Extract ZIP to C:\flutter (exactly)
2. Add C:\flutter\bin to your PATH:
   - Press Win+R
   - Type: sysdm.cpl
   - Advanced → Environment Variables
   - Edit PATH → New → C:\flutter\bin
   - OK all dialogs
```

### Step 3: Verify (1 minute)
```
1. Close this window
2. Open NEW PowerShell
3. Type: flutter --version
4. Type: flutter doctor
```

---

## 📋 After Installation Checklist

Once Flutter is installed:

```powershell
# Step 1: Accept Android licenses
flutter doctor --android-licenses
# Type 'y' for all

# Step 2: Go to your app folder
cd "c:\Users\lenovo\Desktop\IR Blast\flutter_ir_app"

# Step 3: Install dependencies
flutter pub get

# Step 4: Run the app
flutter run
```

---

## 🎬 The Browser is Open!

I've opened the Flutter download page for you.

**What to do now:**
1. Look at the browser window
2. Click "Download Flutter SDK for Windows"
3. Wait for download to complete
4. Follow Step 2 above to extract and setup

---

## 📚 Detailed Instructions

If you need more help, check these files:
- `FLUTTER_INSTALLATION_GUIDE.md` - Complete step-by-step guide
- `flutter_ir_app/INSTALLATION.md` - Full installation documentation

---

## 🔗 Direct Download Link

If the page doesn't load, use this direct link:
```
https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.24.3-stable.zip
```

Copy and paste into your browser.

---

## ⏰ Time Required

- Download: 5-15 min (depends on internet)
- Extract: 2-3 min
- Setup PATH: 1 min
- Total: ~10-20 minutes

---

## ❓ Common Questions

**Q: Where exactly should I extract Flutter?**
A: `C:\flutter` (not in Program Files, not in Desktop)

**Q: How do I add to PATH?**
A: Win+R → sysdm.cpl → Advanced → Environment Variables → Edit Path → New → C:\flutter\bin

**Q: Do I need Android Studio?**
A: Yes, install it after Flutter. Download from: https://developer.android.com/studio

**Q: The download is too slow, any alternatives?**
A: You can use the direct download link above and paste it into your browser.

---

## ✅ Success Check

You'll know Flutter is installed when:
```bash
flutter --version
# Shows: Flutter 3.24.3 • channel stable
```

Then you're ready to run the IR Blast app! 🎉

---

**START HERE:** Download Flutter from the browser window I just opened!
