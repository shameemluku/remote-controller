# Quick Setup Script for Flutter IR Blast App

Write-Host "🚀 Flutter IR Blast App - Quick Setup" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Check if Flutter is installed
Write-Host "Checking Flutter installation..." -ForegroundColor Yellow
if (Get-Command flutter -ErrorAction SilentlyContinue) {
    Write-Host "✅ Flutter is installed" -ForegroundColor Green
    flutter --version
} else {
    Write-Host "❌ Flutter is NOT installed" -ForegroundColor Red
    Write-Host ""
    Write-Host "📥 To install Flutter:" -ForegroundColor Yellow
    Write-Host "1. Download from: https://docs.flutter.dev/get-started/install/windows" -ForegroundColor White
    Write-Host "2. Extract to C:\flutter" -ForegroundColor White
    Write-Host "3. Add C:\flutter\bin to PATH" -ForegroundColor White
    Write-Host "4. Run this script again" -ForegroundColor White
    Write-Host ""
    Write-Host "⚠️  Cannot continue without Flutter. Please install Flutter first." -ForegroundColor Red
    
    # Ask if user wants to download
    $download = Read-Host "Open Flutter download page in browser? (y/n)"
    if ($download -eq 'y') {
        Start-Process "https://docs.flutter.dev/get-started/install/windows"
    }
    
    exit
}

Write-Host ""

# Navigate to project directory
$projectPath = "c:\Users\lenovo\Desktop\IR Blast\flutter_ir_app"
Write-Host "📂 Navigating to project: $projectPath" -ForegroundColor Yellow

if (Test-Path $projectPath) {
    Set-Location $projectPath
    Write-Host "✅ Project directory found" -ForegroundColor Green
} else {
    Write-Host "❌ Project directory not found!" -ForegroundColor Red
    exit
}

Write-Host ""

# Run flutter doctor
Write-Host "🔍 Running Flutter Doctor..." -ForegroundColor Yellow
flutter doctor

Write-Host ""

# Get dependencies
Write-Host "📦 Installing dependencies..." -ForegroundColor Yellow
flutter pub get

Write-Host ""

# Check for devices
Write-Host "📱 Checking for connected devices..." -ForegroundColor Yellow
flutter devices

Write-Host ""
Write-Host "✅ Setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "🎯 Next Steps:" -ForegroundColor Cyan
Write-Host "1. Make sure Node.js server is running (npm start)" -ForegroundColor White
Write-Host "2. Start an emulator or connect a physical device" -ForegroundColor White
Write-Host "3. Run: flutter run" -ForegroundColor White
Write-Host ""
Write-Host "📚 See INSTALLATION.md for detailed setup instructions" -ForegroundColor Yellow
Write-Host ""

# Ask if user wants to run the app
$run = Read-Host "Do you want to run the app now? (y/n)"
if ($run -eq 'y') {
    Write-Host ""
    Write-Host "🚀 Starting Flutter app..." -ForegroundColor Green
    Write-Host "Press 'r' for hot reload, 'R' for hot restart, 'q' to quit" -ForegroundColor Yellow
    Write-Host ""
    flutter run
}
