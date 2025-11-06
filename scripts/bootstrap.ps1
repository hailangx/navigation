#!/usr/bin/env pwsh
# Bootstrap script for Navigation Extension Development

Write-Host "🚀 Navigation Extension Bootstrap" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

$ErrorActionPreference = "Stop"

try {
    # Check if we're in the right directory
    if (-not (Test-Path "package.json")) {
        Write-Host "❌ package.json not found. Please run this script from the navigation extension root directory." -ForegroundColor Red
        exit 1
    }

    Write-Host "📁 Found package.json - we're in the right place!" -ForegroundColor Green
    Write-Host ""

    # Step 1: Install dependencies
    Write-Host "📦 Step 1: Installing dependencies..." -ForegroundColor Yellow
    npm install
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to install dependencies"
    }
    Write-Host "✅ Dependencies installed successfully!" -ForegroundColor Green
    Write-Host ""

    # Step 2: Compile TypeScript
    Write-Host "🔧 Step 2: Compiling TypeScript..." -ForegroundColor Yellow
    npm run compile
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to compile TypeScript"
    }
    Write-Host "✅ TypeScript compilation successful!" -ForegroundColor Green
    Write-Host ""

    # Step 3: Package extension
    Write-Host "📦 Step 3: Packaging extension..." -ForegroundColor Yellow
    npm run package
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to package extension"
    }
    Write-Host "✅ Extension packaged successfully!" -ForegroundColor Green
    Write-Host ""

    # Step 4: Install extension locally
    Write-Host "🔌 Step 4: Installing extension locally..." -ForegroundColor Yellow
    code --install-extension navigation-1.0.0.vsix --force
    if ($LASTEXITCODE -ne 0) {
        Write-Host "⚠️  Could not install extension automatically. You can install it manually:" -ForegroundColor Yellow
        Write-Host "   1. Open VS Code" -ForegroundColor Gray
        Write-Host "   2. Go to Extensions (Ctrl+Shift+X)" -ForegroundColor Gray
        Write-Host "   3. Click '...' menu → 'Install from VSIX...'" -ForegroundColor Gray
        Write-Host "   4. Select navigation-1.0.0.vsix" -ForegroundColor Gray
    } else {
        Write-Host "✅ Extension installed locally!" -ForegroundColor Green
    }
    Write-Host ""

    # Step 5: Reload VS Code
    Write-Host "🔄 Step 5: Reload VS Code to see the extension in action!" -ForegroundColor Yellow
    Write-Host ""
    
    $response = Read-Host "Would you like to reload VS Code now? (y/N)"
    if ($response -eq "y" -or $response -eq "Y") {
        Write-Host "🔄 Reloading VS Code..." -ForegroundColor Cyan
        code --reuse-window .
    }

    Write-Host ""
    Write-Host "🎉 Bootstrap Complete!" -ForegroundColor Green
    Write-Host "===================" -ForegroundColor Green
    Write-Host ""
    Write-Host "✅ Dependencies installed" -ForegroundColor Gray
    Write-Host "✅ TypeScript compiled" -ForegroundColor Gray
    Write-Host "✅ Extension packaged" -ForegroundColor Gray
    Write-Host "✅ Extension installed locally" -ForegroundColor Gray
    Write-Host "✅ Demo configuration active" -ForegroundColor Gray
    Write-Host ""
    Write-Host "🎯 What's Next:" -ForegroundColor Cyan
    Write-Host "   • Look for the '📂 Navigation' panel in VS Code Explorer" -ForegroundColor White
    Write-Host "   • See the demo configuration in action" -ForegroundColor White
    Write-Host "   • Try customizing the navigation groups in settings" -ForegroundColor White
    Write-Host "   • Use F5 to debug/test the extension in a new window" -ForegroundColor White
    Write-Host ""
    Write-Host "Happy coding! 🚀" -ForegroundColor Cyan

} catch {
    Write-Host ""
    Write-Host "❌ Bootstrap failed: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "You can try running the steps manually:" -ForegroundColor Yellow
    Write-Host "1. npm install" -ForegroundColor Gray
    Write-Host "2. npm run compile" -ForegroundColor Gray
    Write-Host "3. npm run package" -ForegroundColor Gray
    Write-Host "4. code --install-extension navigation-1.0.0.vsix" -ForegroundColor Gray
    exit 1
}