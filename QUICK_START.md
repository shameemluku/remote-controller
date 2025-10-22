# Quick Start Guide

## ✅ Project Setup Complete!

Your IR Blast API server is now running and ready to control your AC.

## 🎯 Current Status

- ✅ Node.js server running on `http://localhost:3000`
- ✅ WebSocket server running on `ws://localhost:8080`
- ✅ Dependencies installed
- ✅ Ready for testing

## 📝 Next Steps

### 1. Test the Server (Right Now!)

Open Postman and test the health endpoint:
```
GET http://localhost:3000/health
```

Or import the Postman collection: `postman_collection.json`

### 2. Test WebSocket Connection

Open `websocket-tester.html` in your browser to simulate a mobile device:
- Click "Connect" button
- You should see connection success
- Try the API endpoints in Postman and watch the WebSocket receive commands

### 3. Build the Mobile App

Follow the instructions in `MOBILE_APP_GUIDE.md` to:
- Create an Android app
- Implement WebSocket client
- Add IR blaster functionality
- Capture your AC's IR codes

## 🧪 Testing Flow

1. **Start Server** (Already running!)
   ```
   npm start
   ```

2. **Test API with Postman**
   ```
   POST http://localhost:3000/api/ac/temperature
   Body: {"temperature": 24}
   ```

3. **Connect Mobile Device**
   - Mobile app connects to `ws://YOUR_COMPUTER_IP:8080`
   - Receives commands via WebSocket
   - Transmits IR signals to AC

## 📱 API Endpoints Reference

### Set Temperature
```http
POST http://localhost:3000/api/ac/temperature
Content-Type: application/json

{
  "temperature": 24
}
```

### Control Power
```http
POST http://localhost:3000/api/ac/power
Content-Type: application/json

{
  "power": true
}
```

### Set Mode
```http
POST http://localhost:3000/api/ac/mode
Content-Type: application/json

{
  "mode": "cool"
}
```
Modes: `cool`, `heat`, `fan`, `dry`, `auto`

### List Connected Devices
```http
GET http://localhost:3000/api/ac/devices
```

## 🔧 Configuration

Edit `.env` file to change ports:
```env
PORT=3000          # HTTP API port
WS_PORT=8080       # WebSocket port
NODE_ENV=development
```

## 📦 What's Included

```
IR Blast/
├── src/
│   ├── server.js              # Main server file
│   ├── controllers/
│   │   └── acController.js    # AC control endpoints
│   └── websocket/
│       └── wsServer.js        # WebSocket server
├── package.json               # Dependencies
├── .env                       # Configuration
├── README.md                  # Full documentation
├── MOBILE_APP_GUIDE.md        # Mobile app development guide
├── postman_collection.json    # Postman test collection
└── websocket-tester.html      # WebSocket test page
```

## 🔍 Troubleshooting

**Server won't start?**
- Check if ports 3000 or 8080 are already in use
- Run: `netstat -ano | findstr :3000`

**Can't connect from mobile?**
- Ensure mobile and computer are on same network
- Use computer's IP address (not localhost)
- Check firewall settings
- Find your IP: `ipconfig` (Windows) or `ifconfig` (Mac/Linux)

**Commands not reaching mobile?**
- Check WebSocket connection status
- View server logs for errors
- Test with `websocket-tester.html` first

## 🚀 Production Deployment

For production use:

1. **Use environment variables** for sensitive data
2. **Add authentication** to API endpoints
3. **Implement HTTPS/WSS** for secure connections
4. **Use PM2** for process management:
   ```
   npm install -g pm2
   pm2 start src/server.js --name ir-blast-api
   ```
5. **Deploy to cloud** (AWS, DigitalOcean, etc.)

## 📚 Architecture Diagram

```
┌─────────────┐
│   Postman   │
│  (Client)   │
└──────┬──────┘
       │ HTTP POST
       │ {"temperature": 24}
       ▼
┌─────────────────────┐
│  Node.js API Server │
│  (Port 3000)        │
│  - Express REST API │
└──────┬──────────────┘
       │ WebSocket
       │ Command
       ▼
┌─────────────────────┐
│  WebSocket Server   │
│  (Port 8080)        │
└──────┬──────────────┘
       │
       │ ws://
       ▼
┌─────────────────────┐
│   Mobile App        │
│   (IR Blaster)      │
│   - WebSocket Client│
│   - IR Controller   │
└──────┬──────────────┘
       │ IR Signal
       │ 38kHz
       ▼
┌─────────────────────┐
│    AC Unit          │
└─────────────────────┘
```

## 🎓 Learn More

- **Node.js**: https://nodejs.org/docs
- **Express.js**: https://expressjs.com
- **WebSockets**: https://developer.mozilla.org/en-US/docs/Web/API/WebSocket
- **Android IR Blaster**: https://developer.android.com/reference/android/hardware/ConsumerIrManager

## 📞 Need Help?

- Check `README.md` for detailed documentation
- Review `MOBILE_APP_GUIDE.md` for mobile app development
- Test with `websocket-tester.html` to debug WebSocket issues

---

**Happy Coding! 🎉**

Your AC control system is ready. Now build the mobile app and start controlling your AC from Postman!
