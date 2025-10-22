# Flutter IR Blast App

Complete Flutter mobile app for controlling AC via IR blaster and WebSocket connection.

## 📱 Features

- ✅ WebSocket client for real-time communication
- ✅ IR Blaster integration (Android)
- ✅ Temperature control (16-30°C)
- ✅ Power on/off
- ✅ Mode selection (Cool, Heat, Fan, Dry, Auto)
- ✅ Activity logs
- ✅ Manual testing
- ✅ Real-time command reception

## 🚀 Installation & Setup

### Prerequisites

1. **Install Flutter SDK**
   - Download: https://docs.flutter.dev/get-started/install/windows
   - Extract to: `C:\flutter`
   - Add to PATH: `C:\flutter\bin`
   
2. **Install Android Studio**
   - Download: https://developer.android.com/studio
   - Install Android SDK
   - Install Android Emulator

3. **Verify Installation**
   ```bash
   flutter doctor
   ```

### Setup Steps

1. **Navigate to Project**
   ```bash
   cd "c:\Users\lenovo\Desktop\IR Blast\flutter_ir_app"
   ```

2. **Get Dependencies**
   ```bash
   flutter pub get
   ```

3. **Check Connected Devices**
   ```bash
   flutter devices
   ```

4. **Create/Start Android Emulator**
   ```bash
   # List available emulators
   flutter emulators
   
   # Launch emulator
   flutter emulators --launch <emulator_id>
   ```

5. **Run the App**
   ```bash
   flutter run
   ```

## 📋 Creating Android Emulator

### Via Android Studio:

1. Open Android Studio
2. Tools → Device Manager
3. Click "Create Device"
4. Select Phone → Pixel 6 Pro
5. Select System Image → API 34 (Android 14)
6. Click "Finish"
7. Click "Play" to start emulator

### Via Command Line:

```bash
# Create emulator
flutter emulators --create --name ir_test

# Launch emulator
flutter emulators --launch ir_test
```

## 🔧 Configuration

### Server URL Setup

**For Android Emulator:**
- Use: `ws://10.0.2.2:8080`
- This maps to `localhost:8080` on your computer

**For Physical Device:**
- Find your computer's IP address:
  ```bash
  ipconfig  # Look for IPv4 Address
  ```
- Use: `ws://YOUR_IP:8080`
- Ensure phone and computer are on same network

## 🧪 Testing Flow

### 1. Start Node.js Server
```bash
cd "c:\Users\lenovo\Desktop\IR Blast"
npm start
```

### 2. Launch Flutter App
```bash
cd flutter_ir_app
flutter run
```

### 3. Connect to Server
- Enter server URL (default: `ws://10.0.2.2:8080`)
- Click "Connect"
- Check device ID is assigned

### 4. Test with Postman
```
POST http://localhost:3000/api/ac/temperature
Body: {"temperature": 24}
```

### 5. Observe
- App receives command via WebSocket
- IR signal is transmitted (if device has IR blaster)
- Response sent back to server
- Check activity logs

## 📂 Project Structure

```
flutter_ir_app/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── models/
│   │   ├── ir_command.dart       # Command data model
│   │   └── ac_patterns.dart      # IR signal patterns
│   ├── services/
│   │   ├── websocket_service.dart # WebSocket client
│   │   └── ir_service.dart       # IR blaster controller
│   └── screens/
│       ├── home_screen.dart      # Main UI
│       └── logs_screen.dart      # Activity logs
├── android/
│   └── app/src/main/kotlin/
│       └── MainActivity.kt       # Native IR code
├── pubspec.yaml                  # Dependencies
└── README.md                     # This file
```

## 🔑 Key Files

### MainActivity.kt
Native Android code for IR blaster control using `ConsumerIrManager`.

### websocket_service.dart
Manages WebSocket connection, receives commands from server.

### ir_service.dart
Platform channel bridge to native IR functionality.

### ac_patterns.dart
IR signal patterns for different AC commands. **Replace with actual codes for your AC!**

## ⚠️ Important Notes

### IR Patterns
The IR patterns in `ac_patterns.dart` are **examples only**. You need to:
1. Capture actual IR codes from your AC remote
2. Use IR learning apps or Arduino with IR receiver
3. Replace the patterns in the code

### Emulator Limitations
- Android emulator **does NOT have IR blaster**
- App will show "IR Blaster not available"
- WebSocket functionality works fine
- To test IR, use a physical device with IR blaster

### Physical Device Requirements
Devices with IR blaster:
- Xiaomi Mi series (Mi 9, Mi 10, etc.)
- Samsung Galaxy S6, S7
- Huawei P series
- LG G series

## 🐛 Troubleshooting

### "flutter: command not found"
```bash
# Add Flutter to PATH
$env:PATH += ";C:\flutter\bin"
```

### "No devices found"
```bash
# Start emulator first
flutter emulators --launch <emulator_id>

# Then check
flutter devices
```

### "Connection refused"
- Ensure Node.js server is running
- Use `10.0.2.2` for emulator, not `localhost`
- Check firewall settings

### "Build failed"
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

### "IR Blaster not available"
- Normal for emulator
- Physical device needed for IR testing
- Check if device has IR hardware

## 📱 Testing on Physical Device

1. **Enable Developer Mode** on phone:
   - Settings → About Phone
   - Tap "Build Number" 7 times

2. **Enable USB Debugging**:
   - Settings → Developer Options
   - Enable "USB Debugging"

3. **Connect via USB**:
   ```bash
   flutter devices  # Should show your device
   ```

4. **Run App**:
   ```bash
   flutter run
   ```

5. **Configure Server URL**:
   - Find your computer's IP
   - Enter: `ws://YOUR_IP:8080`

## 📊 Running the Complete System

1. **Terminal 1 - Node.js Server**:
   ```bash
   cd "c:\Users\lenovo\Desktop\IR Blast"
   npm start
   ```

2. **Terminal 2 - Flutter App**:
   ```bash
   cd "c:\Users\lenovo\Desktop\IR Blast\flutter_ir_app"
   flutter run
   ```

3. **Postman - Send Commands**:
   - Import `postman_collection.json`
   - Test temperature/power/mode endpoints

4. **Observe**:
   - Postman → Node.js API → WebSocket → Flutter App → IR Signal → AC

## 🎓 Next Steps

1. ✅ Install Flutter and dependencies
2. ✅ Run app on emulator
3. 🔍 Capture your AC's IR codes
4. ✏️ Update `ac_patterns.dart` with real codes
5. 📱 Test on physical device with IR blaster
6. 🎯 Control your AC!

## 🔗 Useful Links

- Flutter Docs: https://docs.flutter.dev
- Android IR: https://developer.android.com/reference/android/hardware/ConsumerIrManager
- WebSocket: https://pub.dev/packages/web_socket_channel

## 💡 Tips

- Use Activity Logs screen to debug WebSocket messages
- Test manual controls before connecting to server
- IR patterns are device-specific - capture your own
- Keep Node.js server running while testing

---

Happy Coding! 🎉
