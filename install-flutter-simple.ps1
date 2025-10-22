# Simple Flutter Installation Script for Windows

Clear-Host
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "   Flutter Installation for IR Blast App" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

# Check if Flutter is already installed
Write-Host "Checking if Flutter is installed..." -ForegroundColor Yellow
$flutterInstalled = Get-Command flutter -ErrorAction SilentlyContinue

if ($flutterInstalled) {
    Write-Host "SUCCESS: Flutter is already installed!" -ForegroundColor Green
    Write-Host ""
    flutter --version
    Write-Host ""
    Write-Host "You can now run the Flutter app:" -ForegroundColor Green
    Write-Host "  cd flutter_ir_app" -ForegroundColor White
    Write-Host "  flutter pub get" -ForegroundColor White
    Write-Host "  flutter run" -ForegroundColor White
    Write-Host ""
    exit
}

Write-Host "Flutter is NOT installed" -ForegroundColor Red
Write-Host ""

# Manual installation guide
Write-Host "FLUTTER INSTALLATION STEPS:" -ForegroundColor Yellow
Write-Host ""

Write-Host "Option 1: Download and Install Manually (Recommended)" -ForegroundColor Green
Write-Host "------------------------------------------------------" -ForegroundColor Gray
Write-Host ""
Write-Host "Step 1: Download Flutter SDK" -ForegroundColor Cyan
Write-Host "  Download from: https://docs.flutter.dev/get-started/install/windows" -ForegroundColor White
Write-Host "  OR direct link: https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.24.3-stable.zip" -ForegroundColor White
Write-Host ""

Write-Host "Step 2: Extract ZIP file" -ForegroundColor Cyan
Write-Host "  Extract to: C:\flutter" -ForegroundColor White
Write-Host "  (Avoid Program Files or paths with spaces)" -ForegroundColor Gray
Write-Host ""

Write-Host "Step 3: Add Flutter to PATH" -ForegroundColor Cyan
Write-Host "  1. Press Win + R, type 'sysdm.cpl' and press Enter" -ForegroundColor White
Write-Host "  2. Click 'Advanced' tab" -ForegroundColor White
Write-Host "  3. Click 'Environment Variables' button" -ForegroundColor White
Write-Host "  4. Under 'User variables', select 'Path' and click 'Edit'" -ForegroundColor White
Write-Host "  5. Click 'New' and add: C:\flutter\bin" -ForegroundColor White
Write-Host "  6. Click OK on all dialogs" -ForegroundColor White
Write-Host ""

Write-Host "Step 4: Verify Installation" -ForegroundColor Cyan
Write-Host "  1. Close this window" -ForegroundColor White
Write-Host "  2. Open a NEW PowerShell window" -ForegroundColor White
Write-Host "  3. Run: flutter --version" -ForegroundColor White
Write-Host "  4. Run: flutter doctor" -ForegroundColor White
Write-Host ""

Write-Host "Step 5: Accept Android Licenses" -ForegroundColor Cyan
Write-Host "  Run: flutter doctor --android-licenses" -ForegroundColor White
Write-Host "  Type 'y' to accept all licenses" -ForegroundColor White
Write-Host ""

Write-Host "Step 6: Run the IR Blast App" -ForegroundColor Cyan
Write-Host "  cd c:\Users\lenovo\Desktop\IR Blast\flutter_ir_app" -ForegroundColor White
Write-Host "  flutter pub get" -ForegroundColor White
Write-Host "  flutter run" -ForegroundColor White
Write-Host ""
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

$openBrowser = Read-Host "Open Flutter download page in browser? (y/n)"
if ($openBrowser -eq 'y' -or $openBrowser -eq 'Y') {
    Write-Host "Opening Flutter download page..." -ForegroundColor Green
    Start-Process "https://docs.flutter.dev/get-started/install/windows"
}

Write-Host ""
Write-Host "After installing Flutter, run this script again to verify!" -ForegroundColor Yellow
Write-Host ""
