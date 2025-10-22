# 🚀 Deploy to Render.com - Complete Guide

## 🎯 Overview

Deploy your IR Blast Node.js backend to Render.com for **FREE** with WebSocket support!

**What you'll get:**
- ✅ Free HTTPS API
- ✅ WebSocket support
- ✅ Always-on (750 hours/month)
- ✅ Auto-deploy from GitHub
- ✅ Zero configuration needed

**Time needed:** 10 minutes total

---

## 📋 Prerequisites

- [ ] GitHub account (free)
- [ ] Render account (free, no credit card!)
- [ ] Your IR Blast code
- [ ] 10 minutes of time

---

## 🔧 Step 1: Prepare Your Code (2 minutes)

### Update `src/server.js` for Render:

Render uses the `PORT` environment variable. Update your server:

```javascript
// At the top of src/server.js
const PORT = process.env.PORT || 3000;
const WS_PORT = process.env.WS_PORT || 8080;

// Update server start
app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 HTTP Server running on port ${PORT}`);
});

// Update WebSocket
initWebSocketServer(WS_PORT);
```

I'll update this file for you in the next step.

---

## 🐙 Step 2: Push to GitHub (3 minutes)

### Option A: Create New Repo via GitHub Website

1. Go to: https://github.com/new
2. Repository name: `ir-blast-api`
3. Description: "Node.js API for IR Blast control"
4. Visibility: **Public** (for free Render deployment)
5. Click: **"Create repository"**

### Then in PowerShell:

```powershell
cd "c:\Users\lenovo\Desktop\IR Blast"

# Initialize git (if not already)
git init

# Add all files
git add .

# Commit
git commit -m "Initial commit for Render deployment"

# Add remote (replace YOUR-USERNAME)
git remote add origin https://github.com/YOUR-USERNAME/ir-blast-api.git

# Push
git branch -M main
git push -u origin main
```

---

### Option B: Use GitHub Desktop (Easier)

1. Download: https://desktop.github.com/
2. Install GitHub Desktop
3. File → Add Local Repository
4. Choose: `C:\Users\lenovo\Desktop\IR Blast`
5. Click: "Publish repository"
6. Name: `ir-blast-api`
7. Uncheck: "Keep this code private"
8. Click: **"Publish Repository"**

**Done!** Your code is on GitHub ✅

---

## 🌐 Step 3: Deploy to Render (5 minutes)

### 3.1: Sign Up on Render

1. Go to: https://render.com/
2. Click: **"Get Started for Free"**
3. Sign up with: **GitHub** (easiest option)
4. Authorize Render to access GitHub
5. You're logged in! ✅

---

### 3.2: Create Web Service

1. Click: **"New +"** (top right)
2. Select: **"Web Service"**
3. Click: **"Connect a repository"**

**If you see your repo:**
- Click: **"Connect"** next to `ir-blast-api`

**If you DON'T see your repo:**
- Click: **"Configure account"**
- Grant access to `ir-blast-api` repo
- Come back to Render
- Refresh page
- Click: **"Connect"**

---

### 3.3: Configure Service

**Name:**
```
ir-blast-api
```

**Region:**
```
Oregon (US West) or Frankfurt (EU) - choose closest to you
```

**Branch:**
```
main
```

**Root Directory:**
```
(leave empty)
```

**Environment:**
```
Node
```

**Build Command:**
```
npm install
```

**Start Command:**
```
node src/server.js
```

**Plan:**
```
Free
```

---

### 3.4: Environment Variables (Optional)

Click: **"Advanced"** → **"Add Environment Variable"**

Add these (if you have them in `.env`):

```
NODE_ENV = production
```

You can add more later.

---

### 3.5: Deploy!

1. Click: **"Create Web Service"**
2. Wait for deployment (2-3 minutes)
3. Watch the logs scroll
4. Look for: "Live ✅"

**Your API is now LIVE!** 🎉

---

## 🌐 Step 4: Get Your URLs

After deployment, you'll see:

```
Your service is live at:
https://ir-blast-api.onrender.com
```

**Copy this URL!** This is your API base URL.

### Your Endpoints:

```
Health Check:
https://ir-blast-api.onrender.com/health

Temperature API:
https://ir-blast-api.onrender.com/api/ac/temperature

Power API:
https://ir-blast-api.onrender.com/api/ac/power

Mode API:
https://ir-blast-api.onrender.com/api/ac/mode

Get Devices:
https://ir-blast-api.onrender.com/api/ac/devices

WebSocket:
wss://ir-blast-api.onrender.com
```

---

## 🧪 Step 5: Test Your API

### Test 1: Health Check

Open browser:
```
https://ir-blast-api.onrender.com/health
```

Should show:
```json
{
  "status": "ok",
  "message": "IR Blast API is running"
}
```

---

### Test 2: Postman - Set Temperature

**Method:** POST
**URL:** `https://ir-blast-api.onrender.com/api/ac/temperature`
**Headers:** `Content-Type: application/json`
**Body:**
```json
{
  "temperature": 24
}
```

**Expected Response:**
```json
{
  "success": true,
  "message": "Temperature set to 24°C",
  "command": {
    "type": "SET_TEMPERATURE",
    "temperature": 24,
    "timestamp": "2025-10-22T..."
  }
}
```

---

### Test 3: WebSocket Connection

Your Flutter app can connect:
```dart
final serverUrl = 'wss://ir-blast-api.onrender.com';
```

---

## 📱 Step 6: Update Flutter App

### Update WebSocket URL:

**File:** `lib/services/websocket_service.dart`

**Change from:**
```dart
String _serverUrl = kIsWeb ? 'ws://localhost:8080' : 'ws://10.0.2.2:8080';
```

**To:**
```dart
String _serverUrl = 'wss://ir-blast-api.onrender.com';
```

**Or in `home_screen.dart`:**

```dart
@override
void initState() {
  super.initState();
  _checkIrEmitter();
  // Use Render URL
  _serverUrlController.text = 'wss://ir-blast-api.onrender.com';
}
```

---

## 🔄 Step 7: Auto-Deploy (Optional but Recommended)

Render automatically deploys when you push to GitHub!

```powershell
# Make changes to your code
# Then:
git add .
git commit -m "Updated AC controller"
git push

# Render automatically detects and deploys!
# Check Render dashboard to see deployment progress
```

**No manual deployment needed!** ✅

---

## 🐛 Troubleshooting

### Issue: "Service failed to start"

**Check Render logs:**
1. Go to Render dashboard
2. Click your service
3. Go to: **"Logs"** tab
4. Look for errors

**Common fixes:**
```javascript
// Make sure server binds to 0.0.0.0
app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server running on port ${PORT}`);
});
```

---

### Issue: "Cannot connect to WebSocket"

**Check:**
1. Use `wss://` not `ws://` (secure WebSocket)
2. Use correct URL (from Render dashboard)
3. Check Render logs for WebSocket errors

**Fix:**
```javascript
// In wsServer.js, make sure WebSocket server starts correctly
const wss = new WebSocket.Server({ 
  port: process.env.WS_PORT || 8080,
  host: '0.0.0.0'
});
```

---

### Issue: "Build failed"

**Check:**
1. `package.json` has all dependencies
2. Build command is correct: `npm install`
3. Start command is correct: `node src/server.js`

**Fix:**
```powershell
# Test locally first
cd "c:\Users\lenovo\Desktop\IR Blast"
npm install
node src/server.js

# If it works locally, it should work on Render
```

---

### Issue: "Environment variables not working"

**Solution:**
1. Go to Render dashboard
2. Click your service
3. Go to: **"Environment"** tab
4. Click: **"Add Environment Variable"**
5. Add your variables
6. Click: **"Save Changes"**
7. Service will redeploy automatically

---

## 📊 Monitor Your Service

### View Logs:
1. Render Dashboard → Your Service
2. Click: **"Logs"** tab
3. See real-time logs

### View Metrics:
1. Click: **"Metrics"** tab
2. See:
   - CPU usage
   - Memory usage
   - Request count

### Check Status:
1. Look for: **"Live"** badge (green)
2. If red, check logs for errors

---

## 🔐 Security (Optional but Recommended)

### Add Environment Variables for Secrets:

```
# In Render Dashboard → Environment
JWT_SECRET = your-secret-key-here
API_KEY = your-api-key-here
```

### Use in code:
```javascript
const secret = process.env.JWT_SECRET;
const apiKey = process.env.API_KEY;
```

---

## 💰 Free Tier Limits

**Render Free Tier:**
- ✅ 750 hours/month (31 days!)
- ✅ 512MB RAM
- ✅ Shared CPU
- ✅ 100GB bandwidth/month
- ✅ Unlimited apps

**Your Usage Estimate:**
- API calls: ~1,000/month
- WebSocket: Active 24/7
- Bandwidth: ~1GB/month
- **Well within limits!** ✅

**Cost: $0/month** 🎉

---

## 🎯 Custom Domain (Optional)

### Add your own domain:

1. Render Dashboard → Your Service
2. Click: **"Settings"**
3. Scroll to: **"Custom Domains"**
4. Click: **"Add Custom Domain"**
5. Enter: `api.yourdomain.com`
6. Add DNS records (Render shows you how)
7. Wait for SSL (automatic, ~5 minutes)

**Free SSL included!** ✅

---

## 📋 Deployment Checklist

- [ ] Code updated for Render (PORT, host)
- [ ] Pushed to GitHub
- [ ] Render account created
- [ ] GitHub connected to Render
- [ ] Web service created
- [ ] Build command: `npm install`
- [ ] Start command: `node src/server.js`
- [ ] Service deployed successfully
- [ ] Health check works
- [ ] API tested with Postman
- [ ] WebSocket tested
- [ ] Flutter app updated with new URL
- [ ] End-to-end test successful
- [ ] Done! 🎉

---

## 🚀 Quick Commands Reference

```powershell
# Push updates to GitHub (auto-deploys to Render)
git add .
git commit -m "Your message"
git push

# View Render logs (install Render CLI)
npm install -g render-cli
render login
render logs --service ir-blast-api

# Test your API
Invoke-RestMethod -Uri "https://ir-blast-api.onrender.com/health"
```

---

## 🎉 Success!

Your backend is now:
- ✅ Hosted on Render (free!)
- ✅ HTTPS enabled
- ✅ WebSocket working
- ✅ Auto-deploying from GitHub
- ✅ Always available (750 hours/month)
- ✅ Production-ready

**URLs to use:**
```
API: https://ir-blast-api.onrender.com
WebSocket: wss://ir-blast-api.onrender.com
```

**Update these in:**
- Postman collections
- Flutter app (`websocket_service.dart`)
- Any documentation

---

## 📞 Support

- **Render Docs:** https://render.com/docs
- **Render Community:** https://community.render.com/
- **Render Status:** https://status.render.com/
- **Support Email:** support@render.com

---

## 🎯 Next Steps

1. ✅ Test all endpoints with Postman
2. ✅ Update Flutter app with Render URLs
3. ✅ Test end-to-end flow (Postman → Render → Flutter)
4. 📱 Deploy Flutter app to Play Store
5. 🎉 Share your project!

---

**Your backend is live! Time to celebrate! 🎉🚀**
