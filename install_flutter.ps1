# Flutter Installation Script for Windows
# This script will guide you through Flutter installation

Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "  Flutter Installation Guide for Windows" -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host ""

# Check if Flutter is already installed
Write-Host "[*] Checking if Flutter is already installed..." -ForegroundColor Yellow
if (Get-Command flutter -ErrorAction SilentlyContinue) {
    Write-Host "[OK] Flutter is already installed!" -ForegroundColor Green
    flutter --version
    Write-Host ""
    $continue = Read-Host "Flutter is installed. Continue to project setup? (y/n)"
    if ($continue -eq 'y') {
        cd "c:\Users\lenovo\Desktop\IR Blast\flutter_ir_app"
        .\setup.ps1
        exit
    } else {
        exit
    }
}

Write-Host "[!] Flutter is not installed" -ForegroundColor Red
Write-Host ""

# Check system requirements
Write-Host "System Requirements Check:" -ForegroundColor Yellow
Write-Host "  * Windows 10 or later (64-bit)" -ForegroundColor White
Write-Host "  * Disk space: 2.5 GB minimum" -ForegroundColor White
Write-Host "  * Git for Windows" -ForegroundColor White
Write-Host ""

# Check if Git is installed
Write-Host "[*] Checking for Git..." -ForegroundColor Yellow
if (Get-Command git -ErrorAction SilentlyContinue) {
    Write-Host "[OK] Git is installed" -ForegroundColor Green
} else {
    Write-Host "[!] Git is not installed" -ForegroundColor Red
    Write-Host "Git is required for Flutter. Download from: https://git-scm.com/download/win" -ForegroundColor Yellow
    $installGit = Read-Host "Open Git download page? (y/n)"
    if ($installGit -eq 'y') {
        Start-Process "https://git-scm.com/download/win"
    }
}

Write-Host ""
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "      FLUTTER INSTALLATION OPTIONS" -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Choose installation method:" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. Automatic Installation (Recommended)" -ForegroundColor Green
Write-Host "   - Downloads Flutter SDK automatically" -ForegroundColor White
Write-Host "   - Extracts to C:\flutter" -ForegroundColor White
Write-Host "   - Adds to PATH" -ForegroundColor White
Write-Host ""
Write-Host "2. Manual Installation" -ForegroundColor Yellow
Write-Host "   - Opens download page" -ForegroundColor White
Write-Host "   - Shows step-by-step instructions" -ForegroundColor White
Write-Host ""

$choice = Read-Host "Enter choice (1 or 2)"

if ($choice -eq "1") {
    Write-Host ""
    Write-Host "🚀 Starting automatic installation..." -ForegroundColor Green
    Write-Host ""
    
    # Download Flutter
    $flutterUrl = "https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.24.3-stable.zip"
    $downloadPath = "$env:USERPROFILE\Downloads\flutter_windows.zip"
    $extractPath = "C:\flutter"
    
    Write-Host "📥 Downloading Flutter SDK..." -ForegroundColor Yellow
    Write-Host "   URL: $flutterUrl" -ForegroundColor White
    Write-Host "   Destination: $downloadPath" -ForegroundColor White
    Write-Host "   This may take 5-10 minutes depending on your internet speed..." -ForegroundColor White
    Write-Host ""
    
    try {
        # Download with progress
        $ProgressPreference = 'SilentlyContinue'
        Invoke-WebRequest -Uri $flutterUrl -OutFile $downloadPath -UseBasicParsing
        Write-Host "✅ Download complete!" -ForegroundColor Green
        Write-Host ""
        
        # Extract Flutter
        Write-Host "📦 Extracting Flutter SDK to $extractPath..." -ForegroundColor Yellow
        Write-Host "   This may take 2-3 minutes..." -ForegroundColor White
        
        # Remove existing flutter directory if it exists
        if (Test-Path $extractPath) {
            Write-Host "⚠️  Removing existing Flutter directory..." -ForegroundColor Yellow
            Remove-Item -Path $extractPath -Recurse -Force
        }
        
        # Extract using .NET instead of Expand-Archive (faster)
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        [System.IO.Compression.ZipFile]::ExtractToDirectory($downloadPath, "C:\")
        
        Write-Host "✅ Extraction complete!" -ForegroundColor Green
        Write-Host ""
        
        # Add to PATH
        Write-Host "🔧 Adding Flutter to system PATH..." -ForegroundColor Yellow
        
        $flutterBinPath = "C:\flutter\bin"
        $currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
        
        if ($currentPath -notlike "*$flutterBinPath*") {
            $newPath = "$currentPath;$flutterBinPath"
            [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
            Write-Host "✅ Flutter added to PATH!" -ForegroundColor Green
            Write-Host ""
            Write-Host "⚠️  IMPORTANT: You need to restart PowerShell for PATH changes to take effect!" -ForegroundColor Yellow
        } else {
            Write-Host "✅ Flutter is already in PATH" -ForegroundColor Green
        }
        
        # Clean up download
        Write-Host ""
        Write-Host "🧹 Cleaning up..." -ForegroundColor Yellow
        Remove-Item -Path $downloadPath -Force
        Write-Host "✅ Cleanup complete!" -ForegroundColor Green
        Write-Host ""
        
        Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Green
        Write-Host "           ✅ FLUTTER INSTALLATION COMPLETE!" -ForegroundColor Green
        Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Green
        Write-Host ""
        Write-Host "📍 Flutter installed at: C:\flutter" -ForegroundColor White
        Write-Host "📍 Flutter bin added to PATH: C:\flutter\bin" -ForegroundColor White
        Write-Host ""
        Write-Host "🔄 Next Steps:" -ForegroundColor Yellow
        Write-Host "1. Close this PowerShell window" -ForegroundColor White
        Write-Host "2. Open a NEW PowerShell window (to reload PATH)" -ForegroundColor White
        Write-Host "3. Run: flutter doctor" -ForegroundColor White
        Write-Host "4. Run: flutter doctor --android-licenses" -ForegroundColor White
        Write-Host "5. Navigate to project and run: .\setup.ps1" -ForegroundColor White
        Write-Host ""
        
        $restart = Read-Host "Open new PowerShell window now? (y/n)"
        if ($restart -eq 'y') {
            Start-Process powershell
            Write-Host ""
            Write-Host "📝 In the new window, run these commands:" -ForegroundColor Yellow
            Write-Host "flutter doctor" -ForegroundColor Cyan
            Write-Host "cd 'c:\Users\lenovo\Desktop\IR Blast\flutter_ir_app'" -ForegroundColor Cyan
            Write-Host ".\setup.ps1" -ForegroundColor Cyan
        }
        
    } catch {
        Write-Host "❌ Error during installation: $_" -ForegroundColor Red
        Write-Host ""
        Write-Host "Please try manual installation instead." -ForegroundColor Yellow
        $openManual = Read-Host "Open Flutter download page? (y/n)"
        if ($openManual -eq 'y') {
            Start-Process "https://docs.flutter.dev/get-started/install/windows"
        }
    }
    
} elseif ($choice -eq "2") {
    Write-Host ""
    Write-Host "📖 Manual Installation Instructions:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Step 1: Download Flutter SDK" -ForegroundColor Cyan
    Write-Host "  → Opening download page..." -ForegroundColor White
    Start-Process "https://docs.flutter.dev/get-started/install/windows"
    Write-Host ""
    
    Write-Host "Step 2: Extract the ZIP file" -ForegroundColor Cyan
    Write-Host "  → Extract to: C:\flutter" -ForegroundColor White
    Write-Host "  → Avoid Program Files or spaces in path" -ForegroundColor White
    Write-Host ""
    
    Write-Host "Step 3: Add Flutter to PATH" -ForegroundColor Cyan
    Write-Host "  → Search 'Environment Variables' in Windows" -ForegroundColor White
    Write-Host "  → Click 'Environment Variables' button" -ForegroundColor White
    Write-Host "  → Under 'User variables', select 'Path'" -ForegroundColor White
    Write-Host "  → Click 'Edit'" -ForegroundColor White
    Write-Host "  → Click 'New'" -ForegroundColor White
    Write-Host "  → Add: C:\flutter\bin" -ForegroundColor White
    Write-Host "  → Click 'OK' on all dialogs" -ForegroundColor White
    Write-Host ""
    
    Write-Host "Step 4: Verify Installation" -ForegroundColor Cyan
    Write-Host "  → Open NEW PowerShell window" -ForegroundColor White
    Write-Host "  → Run: flutter --version" -ForegroundColor White
    Write-Host "  → Run: flutter doctor" -ForegroundColor White
    Write-Host ""
    
    Write-Host "Step 5: Accept Android Licenses" -ForegroundColor Cyan
    Write-Host "  → Run: flutter doctor --android-licenses" -ForegroundColor White
    Write-Host "  → Type 'y' for all prompts" -ForegroundColor White
    Write-Host ""
    
    Write-Host "Step 6: Run the IR Blast app" -ForegroundColor Cyan
    Write-Host "  → cd 'c:\Users\lenovo\Desktop\IR Blast\flutter_ir_app'" -ForegroundColor White
    Write-Host "  → .\setup.ps1" -ForegroundColor White
    Write-Host ""
    
} else {
    Write-Host "Invalid choice. Exiting." -ForegroundColor Red
}

Write-Host ""
Write-Host "Need help? Check the documentation:" -ForegroundColor Yellow
Write-Host "  → flutter_ir_app/INSTALLATION.md" -ForegroundColor White
Write-Host ""
