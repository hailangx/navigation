#!/usr/bin/env pwsh
<#
release-and-install.ps1

Automates releasing a new patch version of the extension, packaging, installing locally,
committing the version bump, tagging the release, and pushing the changes.

Usage:
  ./release-and-install.ps1 [-VersionPatch] [-NoPush] [-NoTag]

Options:
  -VersionPatch  Increments the patch version (default true). Use -Version "1.2.3" to set an explicit version.
  -Version       Set an explicit version string to use (overrides -VersionPatch).
  -NoPush        Do not push commits or tags to origin.
  -NoTag         Do not create a git tag for this release.
  -SkipInstall   Do not auto-install the .vsix locally.
  -WhatIf        PowerShell WhatIf supported for dry-run behavior
#>

param(
    [switch]$VersionPatch = $true,
    [string]$Version = $null,
    [switch]$NoPush = $false,
    [switch]$NoTag = $false,
    [switch]$SkipInstall = $false
)

$ErrorActionPreference = 'Stop'

function Get-PackageJson {
    return Get-Content package.json -Raw | ConvertFrom-Json
}

function Set-PackageJsonVersion($pkg, $ver) {
    $pkg.version = $ver
    $pkg | ConvertTo-Json -Depth 10 | Set-Content -Encoding UTF8 package.json
}

try {
    if (-not (Test-Path "package.json")) {
        throw "package.json not found. Run this script from the repository root."
    }

    Write-Host "🔎 Reading package.json..." -ForegroundColor Cyan
    $pkg = Get-PackageJson
    $currentVersion = $pkg.version
    Write-Host "Current version: $currentVersion"

    if ($Version) {
        $newVersion = $Version
    } elseif ($VersionPatch) {
        # bump patch
        $parts = $currentVersion.Split('.') | ForEach-Object {[int]$_}
        if ($parts.Length -lt 3) { throw "Current version format invalid: $currentVersion" }
        $parts[2] = $parts[2] + 1
        $newVersion = "$($parts[0]).$($parts[1]).$($parts[2])"
    } else {
        throw "No versioning option selected. Use -VersionPatch or -Version <x.y.z>"
    }

    Write-Host "New version will be: $newVersion" -ForegroundColor Green

    Write-Host "
✔ Updating package.json version..." -ForegroundColor Yellow
    Set-PackageJsonVersion $pkg $newVersion

    Write-Host "
🔧 Compiling TypeScript..." -ForegroundColor Yellow
    npm run compile

    Write-Host "
📦 Packaging extension to .vsix..." -ForegroundColor Yellow
    npm run package

    # Ensure releases directory exists
    $releasesDir = Join-Path -Path (Get-Location) -ChildPath "releases"
    if (-not (Test-Path $releasesDir)) { New-Item -ItemType Directory -Path $releasesDir | Out-Null }

    # Find the generated .vsix (vsce produces navigation-<version>.vsix)
    $generated = Get-ChildItem -Filter "navigation-*.vsix" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($null -eq $generated) { throw "No .vsix package found after packaging" }
    Write-Host "Packaging produced: $($generated.Name)" -ForegroundColor Gray

    # Target name in releases folder
    $targetName = "navigation-$newVersion.vsix"
    $targetPath = Join-Path -Path $releasesDir -ChildPath $targetName

    # Move/rename the generated package into releases/ with the canonical name
    Move-Item -Path $generated.FullName -Destination $targetPath -Force

    if (-not $SkipInstall) {
        Write-Host "
🔌 Installing $targetPath locally..." -ForegroundColor Yellow
        code --install-extension $targetPath --force
    }

    Write-Host "
📝 Committing package and version bump..." -ForegroundColor Yellow
    git add package.json
    git add "$targetPath"
    git commit -m "chore(release): $newVersion" || Write-Host "No changes to commit"

    if (-not $NoTag) {
        Write-Host "
🏷️  Creating git tag v$newVersion..." -ForegroundColor Yellow
        git tag -a "v$newVersion" -m "Release $newVersion"
    }

    if (-not $NoPush) {
        Write-Host "
📤 Pushing commits and tags to origin..." -ForegroundColor Yellow
        git push origin HEAD
        if (-not $NoTag) { git push origin "v$newVersion" }
    }

    Write-Host "
🎉 Release $newVersion complete!" -ForegroundColor Green
    Write-Host "Generated: $vsixName" -ForegroundColor Gray

} catch {
    Write-Host "
❌ Error: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
} finally {
    # noop
}
