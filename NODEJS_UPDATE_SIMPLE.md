# ⚡ Quick Node.js Update Guide

## 🎯 Simple 3-Step Update

### Step 1: Download Node.js v22

**Click this link to download directly:**
https://nodejs.org/dist/v22.11.0/node-v22.11.0-x64.msi

Or go to: https://nodejs.org/ and click **"Download Node.js (LTS)"**

### Step 2: Install

1. Find the downloaded file: `node-v22.11.0-x64.msi` (usually in Downloads folder)
2. **Double-click** to run it
3. Click **Next** → **Next** → **Install**
4. Wait 2-3 minutes
5. Click **Finish**

### Step 3: Verify in NEW PowerShell

**Important:** Close ALL PowerShell windows and open a NEW one!

```powershell
# Check Node version
node --version
# Should show: v22.11.0 ✅

# Try Firebase login
firebase login
# Should work now! ✅
```

---

## 🚀 Alternative: Manual Download Steps

If automatic installation didn't work, do this:

1. **Open browser:** https://nodejs.org/dist/v22.11.0/node-v22.11.0-x64.msi
2. **Save file** to your Downloads folder
3. **Run the installer** (double-click the .msi file)
4. **Follow the wizard** (just click Next)
5. **Close all PowerShell windows**
6. **Open new PowerShell**
7. **Test:** `node --version`

---

## ✅ After Installation Success

```powershell
# Test Node.js
node --version
# Expected: v22.11.0

# Test npm
npm --version
# Expected: 10.x.x

# Now Firebase should work!
firebase login
# Opens browser for Google login ✅

# Continue with Firebase setup
cd "c:\Users\lenovo\Desktop\IR Blast"
firebase init
```

---

## 🐛 Still Showing Old Version?

### Fix: Refresh PATH

```powershell
# Option 1: Restart PowerShell (easiest)
# Close and open new PowerShell window

# Option 2: Refresh PATH manually
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# Then check
node --version
```

### Fix: Uninstall Old Version First

1. **Windows Settings** → **Apps** → **Installed apps**
2. Search: **Node.js**
3. Click **Uninstall** on old version
4. **Install new version** from the .msi file
5. **Restart PowerShell**

---

## 📋 Complete Verification Checklist

After installation, verify everything works:

```powershell
# 1. Check Node.js
node --version
# ✅ Expected: v22.11.0

# 2. Check npm
npm --version
# ✅ Expected: 10.9.0 or higher

# 3. Check Firebase CLI
firebase --version
# ✅ Expected: 14.20.0

# 4. Try Firebase login
firebase login
# ✅ Should open browser

# 5. If login works, you're ready!
firebase projects:list
# ✅ Shows your Firebase projects
```

---

## 🎉 Success!

When you see this, you're done:

```powershell
PS> node --version
v22.11.0

PS> firebase login
✔ Success! Logged in as your-email@gmail.com
```

---

## 📞 Next Steps

After successful Node.js update:

```powershell
cd "c:\Users\lenovo\Desktop\IR Blast"
firebase init
```

Follow: `FIREBASE_DEPLOYMENT_STEPS.md`

---

**Download Link:** https://nodejs.org/dist/v22.11.0/node-v22.11.0-x64.msi

**Just download, install, restart PowerShell, and you're ready!** 🚀
