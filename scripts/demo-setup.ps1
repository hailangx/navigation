#!/usr/bin/env pwsh
# Demo setup script for Navigation Extension

Write-Host "🎯 Navigation Extension Demo Setup" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""

# Check if navigation-demo.json exists
if (-not (Test-Path "navigation-demo.json")) {
    Write-Host "❌ navigation-demo.json not found in current directory" -ForegroundColor Red
    Write-Host "Please run this script from the navigation extension folder" -ForegroundColor Yellow
    exit 1
}

Write-Host "📋 Demo configuration found!" -ForegroundColor Green
Write-Host ""
Write-Host "To apply the demo configuration:" -ForegroundColor White
Write-Host ""
Write-Host "1. 📂 Open VS Code in this workspace folder" -ForegroundColor Yellow
Write-Host "2. ⚙️  Open Settings: Ctrl+, (Cmd+, on Mac)" -ForegroundColor Yellow
Write-Host "3. 🔍 Search for 'navigation'" -ForegroundColor Yellow
Write-Host "4. ✏️  Click 'Edit in settings.json' for 'Navigation: Groups'" -ForegroundColor Yellow
Write-Host "5. 📋 Copy the content from navigation-demo.json" -ForegroundColor Yellow
Write-Host "6. 💾 Save the settings" -ForegroundColor Yellow
Write-Host ""
Write-Host "Alternative: Use Workspace Settings" -ForegroundColor Cyan
Write-Host "1. 📁 Create .vscode/settings.json in your project" -ForegroundColor Yellow
Write-Host "2. 📋 Copy content from navigation-demo.json" -ForegroundColor Yellow
Write-Host "3. 💾 Save the file" -ForegroundColor Yellow
Write-Host ""

# Offer to copy the content to clipboard (if available)
if (Get-Command "Set-Clipboard" -ErrorAction SilentlyContinue) {
    $response = Read-Host "Would you like to copy the demo config to clipboard? (y/N)"
    if ($response -eq "y" -or $response -eq "Y") {
        Get-Content "navigation-demo.json" | Set-Clipboard
        Write-Host "✅ Demo configuration copied to clipboard!" -ForegroundColor Green
        Write-Host "Now paste it into your VS Code settings." -ForegroundColor Cyan
    }
}

Write-Host ""
Write-Host "🎉 The demo showcases:" -ForegroundColor Green
Write-Host "   • File organization with exact paths" -ForegroundColor Gray  
Write-Host "   • Pattern matching for different file types" -ForegroundColor Gray
Write-Host "   • Nested groups for logical organization" -ForegroundColor Gray
Write-Host "   • Various icons and display options" -ForegroundColor Gray
Write-Host "   • Quick access groups" -ForegroundColor Gray
Write-Host ""
Write-Host "Happy navigating! 🚀" -ForegroundColor Cyan