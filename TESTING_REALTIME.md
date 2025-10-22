# 🧪 Complete Real-Time Testing Guide

## Step-by-Step Instructions to Test API → App Real-Time Updates

---

## 📋 Prerequisites Check

### 1. Backend Server Running?
```powershell
# Check if Node.js server is running
# You should see:
# 🚀 HTTP Server running on port 3000
# 🔌 WebSocket Server running on port 8080
```

### 2. Flutter App Running?
```powershell
# Check terminal for:
# Flutter run key commands
# The Flutter DevTools debugger...
```

### 3. Chrome Browser Open?
```
Your Flutter app should be visible in Chrome
```

---

## 🚀 STEP-BY-STEP REAL-TIME TESTING

### Step 1: Connect Flutter App to Backend

**In Chrome (Flutter App):**

1. Look for the **Connection Card** at the top
2. In the "WebSocket Server URL" field, enter:
   ```
   ws://localhost:8080
   ```
   ⚠️ **Important:** Use `localhost:8080`, NOT `10.0.2.2`

3. Click the **"Connect"** button

4. Wait for connection status to change:
   - ❌ Red "Disconnected" → 🟢 Green "Connected"

5. **Device ID** will appear (e.g., "abc-123-def-456")

**Screenshot of what you should see:**
```
┌─────────────────────────────────────┐
│  🟢 Connected                       │
│                                     │
│  WebSocket Server URL:              │
│  [ws://localhost:8080    ]          │
│                                     │
│  [ Disconnect ]                     │
└─────────────────────────────────────┘
```

---

### Step 2: Open Postman (or use cURL)

**Option A: Using Postman**

1. Open Postman
2. Create a new **POST** request
3. Enter URL: `http://localhost:3000/api/ac/temperature`
4. Go to **Headers** tab:
   - Key: `Content-Type`
   - Value: `application/json`
5. Go to **Body** tab:
   - Select **raw**
   - Select **JSON** from dropdown
6. Enter this JSON:
   ```json
   {
     "temperature": 24
   }
   ```

**Option B: Using PowerShell (cURL)**

```powershell
# Run this in a new PowerShell window
Invoke-RestMethod -Uri "http://localhost:3000/api/ac/temperature" `
  -Method POST `
  -ContentType "application/json" `
  -Body '{"temperature": 24}'
```

---

### Step 3: Send the Request & Watch the App!

**In Postman:**
1. Click **"Send"** button

**What Happens in Real-Time:**

**1️⃣ Postman Response (Immediate):**
```json
{
  "success": true,
  "message": "Temperature set to 24°C",
  "command": {
    "type": "SET_TEMPERATURE",
    "temperature": 24,
    "timestamp": "2025-10-20T10:30:00.000Z"
  }
}
```

**2️⃣ Backend Terminal (Within 1 second):**
```
📤 Command sent to device abc-123: {...}
✅ Command executed successfully
```

**3️⃣ Flutter App in Chrome (REAL-TIME!):**
- 🔔 **Toast notification** pops up at bottom:
  ```
  Set Temperature: 24°C - Success
  ```
- 🌡️ **Temperature slider** moves to 24°C
- 📊 **Temperature value** updates to "24°C"

---

### Step 4: Test More Commands

#### Test 1: Change Temperature to 18°C

**Postman Request:**
```
POST http://localhost:3000/api/ac/temperature
Body:
{
  "temperature": 18
}
```

**Watch in App:**
- Slider moves to 18°C
- Toast: "Set Temperature: 18°C - Success"

---

#### Test 2: Turn AC Power ON

**Postman Request:**
```
POST http://localhost:3000/api/ac/power
Body:
{
  "power": true
}
```

**Watch in App:**
- Power switch toggles to ON
- Toast: "Power: ON - Success"

---

#### Test 3: Turn AC Power OFF

**Postman Request:**
```
POST http://localhost:3000/api/ac/power
Body:
{
  "power": false
}
```

**Watch in App:**
- Power switch toggles to OFF
- Toast: "Power: OFF - Success"

---

#### Test 4: Change Mode to COOL

**Postman Request:**
```
POST http://localhost:3000/api/ac/mode
Body:
{
  "mode": "cool"
}
```

**Watch in App:**
- "COOL" chip gets selected (highlighted)
- Toast: "Mode: COOL - Success"

---

#### Test 5: Change Mode to HEAT

**Postman Request:**
```
POST http://localhost:3000/api/ac/mode
Body:
{
  "mode": "heat"
}
```

**Watch in App:**
- "HEAT" chip gets selected
- Toast: "Mode: HEAT - Success"

---

### Step 5: View Activity Logs

**In Flutter App:**

1. Click the **menu icon** (three lines) in top-right
2. Select **"Activity Logs"** or **"Logs"**

**You'll see all commands:**
```
[10:30:15] Received: SET_TEMPERATURE
[10:30:15] 🌡️ Temperature command: 24°C
[10:30:15] 📡 Simulating IR transmission...
[10:30:16] ✅ IR signal transmitted successfully!
[10:30:16] 📤 Sent response: COMMAND_EXECUTED (success)
```

---

## 🎬 Complete Testing Sequence

Try this sequence to see everything work:

```powershell
# Temperature Test
POST http://localhost:3000/api/ac/temperature
{"temperature": 22}

# Wait 2 seconds, then:
POST http://localhost:3000/api/ac/temperature
{"temperature": 26}

# Wait 2 seconds, then:
POST http://localhost:3000/api/ac/power
{"power": true}

# Wait 2 seconds, then:
POST http://localhost:3000/api/ac/mode
{"mode": "cool"}

# Wait 2 seconds, then:
POST http://localhost:3000/api/ac/mode
{"mode": "heat"}
```

Watch the app update in **real-time** with each command! 🎉

---

## 📊 Visual Testing Flow

```
┌─────────────┐
│   Postman   │ ← You send: {"temperature": 24}
└──────┬──────┘
       │ HTTP POST
       ▼
┌─────────────────┐
│  Node.js Server │ ← Receives HTTP request
│  Port 3000      │ ← Validates data
└──────┬──────────┘
       │ WebSocket Message
       ▼
┌─────────────────┐
│ WebSocket Server│ ← Forwards to device
│  Port 8080      │
└──────┬──────────┘
       │ ws:// real-time
       ▼
┌─────────────────┐
│  Flutter App    │ ← UPDATES INSTANTLY!
│  (Chrome)       │ ← Slider moves
│                 │ ← Toast appears
│                 │ ← Logs updated
└─────────────────┘
```

**Total Time:** Less than 1 second! ⚡

---

## 🎯 Expected Results Checklist

After sending each command, verify:

- [ ] Postman shows `"success": true`
- [ ] Backend terminal shows command sent
- [ ] Flutter app shows toast notification
- [ ] UI element updates (slider/switch/chip)
- [ ] Activity logs show new entry
- [ ] Everything happens in under 1 second

---

## 🐛 Troubleshooting

### "Connection failed" in Flutter App

**Problem:** Can't connect to WebSocket

**Solutions:**
```
1. Check backend is running (Terminal 1)
2. Use ws://localhost:8080 (NOT 10.0.2.2)
3. Check for typos in URL
4. Try refreshing the Chrome page
```

### "Device not found" in Postman Response

**Problem:** Flutter app not connected

**Solutions:**
```
1. Connect Flutter app first (Step 1)
2. Check "Connected" status is green
3. Verify Device ID appears
4. Try: GET http://localhost:3000/api/ac/devices
```

### App receives command but UI doesn't update

**Problem:** React/State issue

**Solutions:**
```
1. Press 'r' in terminal (hot reload)
2. Check browser console (F12) for errors
3. Disconnect and reconnect WebSocket
```

### No toast notification appears

**Problem:** Notification might be disabled or UI issue

**Solutions:**
```
1. Check Activity Logs (menu → Logs)
2. Commands should still be logged
3. Press 'R' in terminal (hot restart)
```

---

## 📝 Quick Test Script

**Copy and paste this into Postman:**

Create these as a Collection:

```
# Test 1: Temperature 20
POST http://localhost:3000/api/ac/temperature
{"temperature": 20}

# Test 2: Temperature 25  
POST http://localhost:3000/api/ac/temperature
{"temperature": 25}

# Test 3: Power ON
POST http://localhost:3000/api/ac/power
{"power": true}

# Test 4: Mode Cool
POST http://localhost:3000/api/ac/mode
{"mode": "cool"}

# Test 5: Mode Heat
POST http://localhost:3000/api/ac/mode
{"mode": "heat"}

# Test 6: Check Devices
GET http://localhost:3000/api/ac/devices
```

Run them one by one and watch the app update! ✨

---

## 🎉 Success Indicators

You'll know it's working when:

1. ✅ You click "Send" in Postman
2. ✅ Response comes back immediately
3. ✅ Flutter app updates **instantly**
4. ✅ Toast notification appears
5. ✅ UI element changes
6. ✅ Activity log shows new entry
7. ✅ Backend terminal logs the action

**If all above happen → PERFECT! Your real-time system works! 🚀**

---

## 🎬 Video Guide (What You'll See)

**Timeline:**
```
0:00 - Click Send in Postman
0:01 - Postman shows success response
0:01 - Backend logs "Command sent"
0:01 - Flutter app toast appears ← REAL-TIME!
0:01 - UI updates ← INSTANT!
0:02 - Activity log updated
```

**Total response time: ~1 second!** ⚡

---

## 🔥 Advanced Testing

### Test Multiple Rapid Commands

Send 5 commands quickly:
```
Temperature 20 → 22 → 24 → 26 → 28
```

**Watch:** Slider smoothly moves through all values!

### Test All Features in Sequence

```powershell
# Full sequence
POST /temperature {"temperature": 24}
POST /power {"power": true}
POST /mode {"mode": "cool"}
POST /temperature {"temperature": 22}
POST /mode {"mode": "heat"}
POST /temperature {"temperature": 26}
POST /power {"power": false}
```

Run all in Postman Runner or Collection Runner!

---

## 📞 Need Help?

**App not updating?**
1. Check WebSocket connection (should be green)
2. Check backend terminal for errors
3. Press 'r' to hot reload
4. Check Activity Logs

**Still not working?**
```powershell
# Restart backend
cd "c:\Users\lenovo\Desktop\IR Blast"
npm start

# Restart Flutter app
cd "c:\Users\lenovo\Desktop\IR Blast\flutter_ir_app"
flutter run -d chrome
```

---

## ✨ Pro Tips

1. **Keep Activity Logs open** - See everything happening
2. **Use Postman Runner** - Test multiple commands
3. **Try rapid commands** - Test real-time performance
4. **Watch all 3 places** - Postman, Terminal, Flutter
5. **Press 'r' often** - Hot reload is your friend

---

**NOW GO TEST IT! 🚀**

Open Postman, connect the app, and send your first command!

Watch the magic of real-time updates! ✨
