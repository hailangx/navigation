#!/usr/bin/env pwsh
# Test script to verify the navigation extension setup

Write-Host "🧪 Navigation Extension Test" -ForegroundColor Cyan
Write-Host "============================" -ForegroundColor Cyan
Write-Host ""

$allPassed = $true

function Test-Condition {
    param(
        [string]$TestName,
        [bool]$Condition,
        [string]$SuccessMessage,
        [string]$FailMessage
    )
    
    Write-Host "Testing: $TestName" -ForegroundColor Yellow
    if ($Condition) {
        Write-Host "  ✅ $SuccessMessage" -ForegroundColor Green
        return $true
    } else {
        Write-Host "  ❌ $FailMessage" -ForegroundColor Red
        return $false
    }
}

# Test 1: Check if we're in the right directory
$test1 = Test-Condition -TestName "Project Structure" -Condition (Test-Path "package.json") -SuccessMessage "Found package.json" -FailMessage "package.json not found"
$allPassed = $allPassed -and $test1

# Test 2: Check if source files exist
$test2 = Test-Condition -TestName "Source Files" -Condition ((Test-Path "src/extension.ts") -and (Test-Path "src/navigationProvider.ts")) -SuccessMessage "All source files present" -FailMessage "Missing source files"
$allPassed = $allPassed -and $test2

# Test 3: Check if demo files exist
$test3 = Test-Condition -TestName "Demo Configuration" -Condition ((Test-Path "navigation-demo.json") -and (Test-Path ".vscode/settings.json")) -SuccessMessage "Demo configuration files present" -FailMessage "Missing demo configuration"
$allPassed = $allPassed -and $test3

# Test 4: Check if dependencies are installed
$test4 = Test-Condition -TestName "Dependencies" -Condition (Test-Path "node_modules") -SuccessMessage "Node modules installed" -FailMessage "Run 'npm install' first"
$allPassed = $allPassed -and $test4

# Test 5: Check if TypeScript compiles
if ($test4) {
    Write-Host "Testing: TypeScript Compilation" -ForegroundColor Yellow
    npm run compile 2>$null
    $test5 = Test-Condition -TestName "TypeScript Build" -Condition ($LASTEXITCODE -eq 0) -SuccessMessage "TypeScript compiles successfully" -FailMessage "TypeScript compilation failed"
    $allPassed = $allPassed -and $test5
}

# Test 6: Check if VS Code workspace files exist
$test6 = Test-Condition -TestName "VS Code Workspace" -Condition ((Test-Path ".vscode/tasks.json") -and (Test-Path ".vscode/launch.json")) -SuccessMessage "VS Code workspace configured" -FailMessage "VS Code workspace files missing"
$allPassed = $allPassed -and $test6

# Test 7: Check if extension can be packaged
if ($test4 -and $test5) {
    Write-Host "Testing: Extension Packaging" -ForegroundColor Yellow
    npm run package 2>$null
    $test7 = Test-Condition -TestName "Extension Package" -Condition (Test-Path "navigation-1.0.0.vsix") -SuccessMessage "Extension packages successfully" -FailMessage "Extension packaging failed"
    $allPassed = $allPassed -and $test7
}

Write-Host ""
Write-Host "========================" -ForegroundColor Cyan

if ($allPassed) {
    Write-Host "🎉 All tests passed!" -ForegroundColor Green
    Write-Host ""
    Write-Host "✅ Project structure is correct" -ForegroundColor Gray
    Write-Host "✅ Source code is present" -ForegroundColor Gray
    Write-Host "✅ Demo configuration is ready" -ForegroundColor Gray
    Write-Host "✅ Dependencies are installed" -ForegroundColor Gray
    Write-Host "✅ TypeScript compiles successfully" -ForegroundColor Gray
    Write-Host "✅ VS Code workspace is configured" -ForegroundColor Gray
    Write-Host "✅ Extension packages successfully" -ForegroundColor Gray
    Write-Host ""
    Write-Host "🚀 Ready for development!" -ForegroundColor Cyan
    Write-Host "   • Press F5 in VS Code to debug" -ForegroundColor White
    Write-Host "   • Open this workspace to see the demo" -ForegroundColor White
    Write-Host "   • Run ./bootstrap.ps1 to install locally" -ForegroundColor White
} else {
    Write-Host "❌ Some tests failed!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Try running:" -ForegroundColor Yellow
    Write-Host "  • npm install" -ForegroundColor Gray
    Write-Host "  • ./bootstrap.ps1" -ForegroundColor Gray
    exit 1
}