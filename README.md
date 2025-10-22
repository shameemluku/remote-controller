# IR Blast API - AC Remote Control

Node.js API server for controlling AC units via mobile phone IR blaster.

## Architecture

```
[Postman/Client] → [Node.js API] → [WebSocket] → [Mobile App] → [IR Signal] → [AC Unit]
```

## Setup Instructions

### 1. Install Dependencies

```bash
npm install
```

### 2. Configure Environment

Edit `.env` file if needed:
- `PORT`: HTTP API port (default: 3000)
- `WS_PORT`: WebSocket port (default: 8080)

### 3. Start Server

```bash
npm start
```

For development with auto-reload:
```bash
npm run dev
```

## API Endpoints

### Health Check
```
GET http://localhost:3000/health
```

### Set Temperature
```
POST http://localhost:3000/api/ac/temperature
Content-Type: application/json

{
  "temperature": 24,
  "deviceId": "optional-device-id"
}
```

### Power On/Off
```
POST http://localhost:3000/api/ac/power
Content-Type: application/json

{
  "power": true,
  "deviceId": "optional-device-id"
}
```

### Set Mode
```
POST http://localhost:3000/api/ac/mode
Content-Type: application/json

{
  "mode": "cool",
  "deviceId": "optional-device-id"
}
```
Valid modes: `cool`, `heat`, `fan`, `dry`, `auto`

### List Connected Devices
```
GET http://localhost:3000/api/ac/devices
```

## Mobile App Integration

### WebSocket Connection

Your mobile app should connect to:
```
ws://YOUR_SERVER_IP:8080
```

### Message Format

**Server → Mobile (Commands):**
```json
{
  "type": "SET_TEMPERATURE",
  "temperature": 24,
  "timestamp": "2025-10-20T10:30:00.000Z"
}
```

**Mobile → Server (Response):**
```json
{
  "type": "COMMAND_EXECUTED",
  "success": true
}
```

## Mobile App Requirements

### Android (Recommended)

1. **Create Android App** with:
   - WebSocket client library
   - IR Blaster API access
   - Background service for persistent connection

2. **Key Components:**
   ```java
   // Check IR support
   ConsumerIrManager irManager = (ConsumerIrManager) getSystemService(Context.CONSUMER_IR_SERVICE);
   if (irManager.hasIrEmitter()) {
       // Device has IR blaster
   }
   
   // Transmit IR signal
   irManager.transmit(38000, pattern);
   ```

3. **WebSocket Libraries:**
   - OkHttp WebSocket
   - Java-WebSocket

### iOS
iOS devices typically don't have IR blasters. Use Android or external IR hardware.

## IR Signal Patterns

You'll need to capture/define IR patterns for your specific AC model:

```javascript
// Example AC IR patterns (frequency: 38kHz)
const AC_PATTERNS = {
  power: [9000, 4500, 560, 560, ...],
  temp_24: [9000, 4500, 560, 1690, ...],
  cool_mode: [9000, 4500, 560, 560, ...]
};
```

### Tools to Capture IR Codes:
1. **AnalysIR** - IR analyzer software
2. **IR Remote Control** - Android apps with learning mode
3. **Arduino + IR Receiver** - Hardware solution

## Testing with Postman

1. Start the server
2. Connect your mobile app to WebSocket
3. Send POST request from Postman:

```bash
curl -X POST http://localhost:3000/api/ac/temperature \
  -H "Content-Type: application/json" \
  -d '{"temperature": 24}'
```

## Next Steps

1. ✅ Set up Node.js server (Done)
2. 📱 Create mobile app with WebSocket client
3. 🔍 Capture IR codes for your AC model
4. 📡 Implement IR transmission in mobile app
5. 🧪 Test end-to-end flow

## Troubleshooting

**Device not connecting?**
- Check firewall settings
- Ensure mobile and server on same network
- Verify WebSocket URL

**Commands not working?**
- Check WebSocket connection status
- Verify IR codes are correct for your AC model
- Ensure mobile app has IR permissions

## License

MIT
