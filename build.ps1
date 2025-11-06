#!/usr/bin/env pwsh
# Build script for Navigation VS Code Extension

Write-Host "🔨 Building Navigation Extension..." -ForegroundColor Cyan

# Check if npm is available
if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    Write-Host "❌ npm is not installed. Please install Node.js first." -ForegroundColor Red
    exit 1
}

# Check if vsce is available
if (-not (Get-Command vsce -ErrorAction SilentlyContinue)) {
    Write-Host "📦 Installing vsce..." -ForegroundColor Yellow
    npm install -g vsce
}

# Install dependencies
Write-Host "📦 Installing dependencies..." -ForegroundColor Yellow
npm install

# Compile TypeScript
Write-Host "🔧 Compiling TypeScript..." -ForegroundColor Yellow
npm run compile

# Package extension
Write-Host "📦 Packaging extension..." -ForegroundColor Yellow
vsce package

Write-Host "✅ Build complete! The .vsix file is ready for installation." -ForegroundColor Green
Write-Host "📁 Look for: navigation-1.0.0.vsix" -ForegroundColor Cyan
Write-Host ""
Write-Host "To install:" -ForegroundColor White
Write-Host "1. Open VS Code" -ForegroundColor Gray
Write-Host "2. Go to Extensions (Ctrl+Shift+X)" -ForegroundColor Gray
Write-Host "3. Click '...' menu → 'Install from VSIX...'" -ForegroundColor Gray
Write-Host "4. Select the .vsix file" -ForegroundColor Gray