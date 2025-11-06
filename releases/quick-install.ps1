#!/usr/bin/env pwsh
# Quick installer for release artifacts (placed in releases/)

Write-Host "⚡ Release Quick Install (from releases/)" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

$ErrorActionPreference = 'Stop'

try {
    # Determine the directory where this script lives
    $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

    # Find the latest navigation-*.vsix in the same folder
    $latest = Get-ChildItem -Path $scriptDir -Filter 'navigation-*.vsix' -File | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($null -eq $latest) {
        Write-Host "❌ No navigation-*.vsix found in $scriptDir. Download a release or run the release script first." -ForegroundColor Red
        exit 1
    }

    Write-Host "Found VSIX: $($latest.Name)" -ForegroundColor Yellow

    # Install via VS Code CLI
    if (-not (Get-Command code -ErrorAction SilentlyContinue)) {
        Write-Host "❌ 'code' CLI not found in PATH. Install VS Code and enable the 'code' command in PATH." -ForegroundColor Red
        exit 1
    }

    Write-Host "🔌 Installing $($latest.Name) locally..." -ForegroundColor Yellow
    code --install-extension $latest.FullName --force
    if ($LASTEXITCODE -ne 0) {
        Write-Host "⚠️  Installation failed. You can install manually via VS Code → Extensions → 'Install from VSIX...'" -ForegroundColor Yellow
        exit 1
    }

    Write-Host "✅ Installed $($latest.Name)" -ForegroundColor Green
    Write-Host "Reload VS Code or restart to activate the extension." -ForegroundColor Cyan

} catch {
    Write-Host "\n❌ Error: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
