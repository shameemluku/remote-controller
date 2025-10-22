# Flutter IR Blast App - Testing Guide

## 🧪 Complete Testing Workflow

This guide walks you through testing the entire system from scratch.

## Prerequisites Checklist

- [ ] Node.js installed
- [ ] Flutter SDK installed
- [ ] Android Studio installed
- [ ] Android emulator created
- [ ] All Flutter dependencies installed

## Step-by-Step Testing

### Phase 1: Install Flutter (If Not Installed)

1. **Download Flutter SDK**
   ```
   https://docs.flutter.dev/get-started/install/windows
   ```

2. **Extract to C:\flutter**

3. **Add to PATH**
   - Windows Search → "Environment Variables"
   - Edit "Path" variable
   - Add: `C:\flutter\bin`
   - Click OK

4. **Open NEW PowerShell** (to reload PATH)

5. **Verify Installation**
   ```bash
   flutter --version
   flutter doctor
   ```

6. **Accept Android Licenses**
   ```bash
   flutter doctor --android-licenses
   # Type 'y' for all
   ```

### Phase 2: Setup Project

1. **Navigate to Flutter Project**
   ```powershell
   cd "c:\Users\lenovo\Desktop\IR Blast\flutter_ir_app"
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Verify No Errors**
   ```bash
   flutter analyze
   ```

### Phase 3: Create & Start Emulator

#### Option A: Using Android Studio (Easier)

1. Open Android Studio
2. Click "More Actions" → "Virtual Device Manager"
3. Click "+ Create Device"
4. Select "Phone" → "Pixel 6 Pro" → Next
5. Select "Tiramisu" (API 33) or "UpsideDownCake" (API 34)
6. Click "Download" if not already downloaded
7. Click "Finish"
8. Click ▶️ (Play button) to start emulator

#### Option B: Using Command Line

```bash
# List available emulators
flutter emulators

# If no emulators exist, create one:
# (This requires Android Studio to be installed first)

# Launch emulator
flutter emulators --launch <emulator_id>
```

### Phase 4: Start Backend Server

**Terminal 1** (Keep running):
```powershell
cd "c:\Users\lenovo\Desktop\IR Blast"
npm start
```

Expected output:
```
🔌 WebSocket Server running on port 8080
📱 Mobile devices can connect to: ws://localhost:8080
🚀 HTTP Server running on port 3000
📡 Test at: http://localhost:3000/health
```

### Phase 5: Run Flutter App

**Terminal 2** (New terminal):
```powershell
cd "c:\Users\lenovo\Desktop\IR Blast\flutter_ir_app"

# Check devices are connected
flutter devices

# Run the app
flutter run
```

Wait for app to build and launch on emulator (first time takes 2-5 minutes).

### Phase 6: Connect App to Server

1. **In the Flutter app:**
   - Server URL should show: `ws://10.0.2.2:8080`
   - Click "Connect" button
   - Wait for "Connected" status
   - Note the Device ID assigned

2. **Check Terminal 1 (Node.js)**
   Should show:
   ```
   📱 New device connected: <device-id> from ::ffff:10.0.2.2
   ```

### Phase 7: Test with Postman

1. **Open Postman**

2. **Test 1: Health Check**
   ```
   GET http://localhost:3000/health
   ```
   Expected: `{"status": "OK", ...}`

3. **Test 2: List Devices**
   ```
   GET http://localhost:3000/api/ac/devices
   ```
   Should show your connected device

4. **Test 3: Set Temperature**
   ```
   POST http://localhost:3000/api/ac/temperature
   Headers: Content-Type: application/json
   Body: {"temperature": 24}
   ```

5. **Observe in Flutter App:**
   - Toast notification appears
   - Activity logs show command received
   - Temperature slider moves to 24°C

6. **Test 4: Control Power**
   ```
   POST http://localhost:3000/api/ac/power
   Headers: Content-Type: application/json
   Body: {"power": true}
   ```

7. **Test 5: Set Mode**
   ```
   POST http://localhost:3000/api/ac/mode
   Headers: Content-Type: application/json
   Body: {"mode": "cool"}
   ```

### Phase 8: Test Manual Controls

In Flutter app:

1. **Adjust temperature slider** to 22°C
2. Click "Test Temp" button
3. Observe:
   - If emulator: "IR Blaster not available" warning
   - If physical device with IR: Signal transmitted

4. **Toggle AC Power switch**
5. Click "Test Power" button

6. **Select different mode** (Heat, Fan, etc.)
7. Click "Test Mode" button

### Phase 9: View Activity Logs

1. Click menu icon (three lines) in app
2. Select "Activity Logs"
3. Review all WebSocket messages
4. Click trash icon to clear logs

## 🎯 Expected Results

### ✅ Successful Test Flow:

```
[Postman] 
    ↓ HTTP POST {"temperature": 24}
[Node.js Server] 
    ↓ WebSocket message
[Flutter App] 
    → Receives command
    → Shows toast: "Set Temperature: 24°C"
    → Updates UI
    → (Attempts IR transmission)
    → Sends response back
[Node.js Server]
    → Logs: "Command executed successfully"
```

### 📊 What to Check:

**Postman Response:**
```json
{
  "success": true,
  "message": "Temperature set to 24°C",
  "command": {
    "type": "SET_TEMPERATURE",
    "temperature": 24,
    "timestamp": "2025-10-20T..."
  }
}
```

**Flutter App:**
- Green toast: "Set Temperature: 24°C - Success"
- Activity log entry
- UI updated

**Node.js Terminal:**
```
📤 Command sent to device abc-123: {...}
✅ Command executed successfully on device abc-123
```

## 🐛 Troubleshooting

### Flutter app won't run

```bash
flutter clean
flutter pub get
flutter run
```

### "No devices found"

```bash
# Start emulator from Android Studio
# Or
flutter emulators --launch <emulator_id>

# Wait 30-60 seconds for emulator to boot
# Then check
flutter devices
```

### App can't connect to server

**Check:**
1. Node.js server is running (Terminal 1)
2. Using correct URL: `ws://10.0.2.2:8080` (emulator)
3. No firewall blocking port 8080

**Fix:**
```powershell
# Restart Node.js server
# Ctrl+C in Terminal 1
npm start
```

### Commands not appearing in app

**Check:**
1. Device ID is assigned (shown in app)
2. WebSocket connection is active (green status)
3. Check Activity Logs for messages

**Test:**
```
GET http://localhost:3000/api/ac/devices
```
Your device should be listed.

### Hot Reload not working

```bash
# While app is running, press:
r   # Hot reload
R   # Hot restart (full restart)
```

### Build errors

```bash
# Clean build
flutter clean

# Re-download dependencies
rm pubspec.lock
flutter pub get

# Run again
flutter run
```

## 📱 Testing on Physical Device

### Requirements:
- Android phone with IR blaster (Xiaomi, Samsung, etc.)
- USB cable
- Developer mode enabled

### Steps:

1. **Enable Developer Mode**
   - Settings → About Phone
   - Tap "Build Number" 7 times

2. **Enable USB Debugging**
   - Settings → Developer Options
   - Enable "USB Debugging"

3. **Connect Phone**
   ```bash
   flutter devices
   # Should show your phone
   ```

4. **Find Computer IP**
   ```bash
   ipconfig
   # Look for IPv4 Address (e.g., 192.168.1.100)
   ```

5. **Update Server URL in App**
   - Change from `ws://10.0.2.2:8080`
   - To `ws://YOUR_IP:8080`
   - Example: `ws://192.168.1.100:8080`

6. **Ensure Same Network**
   - Phone and computer must be on same WiFi

7. **Run App**
   ```bash
   flutter run
   ```

8. **Test IR Transmission**
   - App should show "IR Blaster: ✅ Available"
   - Manual test buttons will actually transmit IR
   - Point phone at AC and test!

## 🎓 Complete End-to-End Test

### The Perfect Test Sequence:

1. ✅ Start Node.js server
2. ✅ Start Android emulator
3. ✅ Run Flutter app
4. ✅ Connect to WebSocket
5. ✅ Send temperature command from Postman
6. ✅ Observe command in app
7. ✅ Check activity logs
8. ✅ Test manual controls
9. ✅ Send power command
10. ✅ Send mode command
11. ✅ Verify all responses in Postman

### Success Criteria:

- [x] Node.js server running without errors
- [x] Flutter app connects successfully
- [x] Device ID assigned
- [x] Commands received in real-time
- [x] Toast notifications appear
- [x] Activity logs show messages
- [x] Responses sent back to server
- [x] Postman shows success responses

## 📝 Notes

- **Emulator Limitation**: No actual IR transmission (no hardware)
- **Physical Device**: Required for real IR testing
- **IR Patterns**: Example patterns need replacement with real codes
- **Network**: Emulator uses `10.0.2.2`, device uses computer IP

## 🚀 Performance Tips

- Keep emulator running during development
- Use hot reload (`r`) for instant updates
- Close unused apps to free memory
- Use `flutter run --release` for better performance

---

**Ready to test?** Follow the phases in order! 🎉
