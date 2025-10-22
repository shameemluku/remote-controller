# 🔧 Fix: Update Node.js for Firebase CLI

## ❌ Error
```
Firebase CLI v14.20.0 is incompatible with Node.js v18.20.4
Please upgrade Node.js to version >=20.0.0 || >=22.0.0
```

## ✅ Solution: Update Node.js

### Option 1: Download & Install (Recommended)

**Step 1: Download Node.js v22 (LTS)**

Go to: https://nodejs.org/

- Click: **Download Node.js (LTS)** - v22.x.x
- Choose: **Windows Installer (.msi)** - 64-bit

**Step 2: Run Installer**

1. Double-click downloaded `.msi` file
2. Click **Next** through installer
3. Accept license
4. Choose default installation location
5. Click **Install**
6. Wait for installation (1-2 minutes)
7. Click **Finish**

**Step 3: Restart PowerShell**

Close all PowerShell windows and open a new one.

**Step 4: Verify**

```powershell
node --version
```

Should show: `v22.x.x` ✅

**Step 5: Try Firebase Again**

```powershell
firebase login
```

---

### Option 2: Using Chocolatey (Faster)

If you have Chocolatey installed:

```powershell
# Run as Administrator
choco upgrade nodejs-lts -y

# Restart PowerShell
node --version
firebase login
```

---

### Option 3: Using NVM (Node Version Manager)

If you want to manage multiple Node versions:

**Install NVM for Windows:**

1. Download: https://github.com/coreybutler/nvm-windows/releases
2. Download: `nvm-setup.exe`
3. Run installer
4. Restart PowerShell

**Install Node.js 22:**

```powershell
nvm install 22
nvm use 22
node --version
firebase login
```

---

## 🎯 After Updating Node.js

**Test your setup:**

```powershell
# Check Node version
node --version
# Should show: v22.x.x or v20.x.x

# Check npm version
npm --version
# Should show: 10.x.x or higher

# Try Firebase login
firebase login
# Should open browser for login ✅
```

---

## 🐛 If Still Having Issues

### Issue: "Firebase not recognized"

**Solution:** Reinstall Firebase CLI after updating Node:

```powershell
npm install -g firebase-tools
firebase --version
```

### Issue: PowerShell execution policy

Already fixed! ✅ But if you see it again:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Issue: Permission denied

Run PowerShell as Administrator:

1. Right-click PowerShell
2. Click "Run as Administrator"
3. Try command again

---

## 📋 Complete Setup Checklist

After updating Node.js:

```powershell
# 1. Verify Node.js version
node --version
# Expected: v22.x.x or v20.x.x ✅

# 2. Verify npm
npm --version
# Expected: 10.x.x ✅

# 3. Reinstall Firebase CLI (optional, if issues)
npm install -g firebase-tools

# 4. Verify Firebase CLI
firebase --version
# Expected: 14.x.x ✅

# 5. Login to Firebase
firebase login
# Opens browser, login with Google ✅

# 6. List projects (test)
firebase projects:list
# Shows your projects ✅
```

---

## ⚡ Quick Fix Summary

1. **Download Node.js v22** from https://nodejs.org/
2. **Install** (takes 2 minutes)
3. **Restart PowerShell**
4. **Run:** `firebase login`

**Total time: 5 minutes** ⏱️

---

## 🎉 Success Indicators

You'll know it worked when:

- ✅ `node --version` shows v22.x.x or v20.x.x
- ✅ `firebase login` opens browser
- ✅ You can sign in with Google
- ✅ Terminal shows: "✔ Success! Logged in as your-email@gmail.com"

---

**Next steps after successful login:**

```powershell
cd "c:\Users\lenovo\Desktop\IR Blast"
firebase init
```

Follow the guide in `FIREBASE_DEPLOYMENT_STEPS.md`! 🚀
