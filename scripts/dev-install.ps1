#!/usr/bin/env pwsh

# Navigation Extension Installation Script

Write-Host "🔧 Installing Navigation Extension..." -ForegroundColor Cyan

# Check if we're in the correct directory
if (-not (Test-Path "package.json")) {
    Write-Host "❌ Error: package.json not found. Please run this script from the extension directory." -ForegroundColor Red
    exit 1
}

# Install dependencies
Write-Host "📦 Installing dependencies..." -ForegroundColor Yellow
npm install

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to install dependencies" -ForegroundColor Red
    exit 1
}

# Compile TypeScript
Write-Host "🔨 Compiling TypeScript..." -ForegroundColor Yellow
npm run compile

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to compile TypeScript" -ForegroundColor Red
    exit 1
}

# Get VS Code extensions directory
$extensionsDir = ""
if ($IsWindows -or $env:OS -eq "Windows_NT") {
    $extensionsDir = "$env:USERPROFILE\.vscode\extensions"
} elseif ($IsMacOS) {
    $extensionsDir = "$env:HOME/.vscode/extensions"
} else {
    $extensionsDir = "$env:HOME/.vscode/extensions"
}

if (-not (Test-Path $extensionsDir)) {
    Write-Host "❌ VS Code extensions directory not found: $extensionsDir" -ForegroundColor Red
    Write-Host "   Please make sure VS Code is installed and has been run at least once." -ForegroundColor Yellow
    exit 1
}

# Read package.json to derive publisher, name and version
$pkg = Get-Content package.json -Raw | ConvertFrom-Json
$publisher = $pkg.publisher -or 'local'
$name = $pkg.name
$version = $pkg.version

# Create extension directory using the expected VS Code format: publisher.name-version
$extensionName = "$publisher.$name-$version"
$targetDir = Join-Path $extensionsDir $extensionName

Write-Host "📁 Installing to: $targetDir" -ForegroundColor Yellow

# Remove existing installation
if (Test-Path $targetDir) {
    Write-Host "🗑️  Removing existing installation..." -ForegroundColor Yellow
    Remove-Item $targetDir -Recurse -Force
}

# Create target directory
New-Item -ItemType Directory -Path $targetDir -Force | Out-Null

# Copy files
Write-Host "📋 Copying extension files..." -ForegroundColor Yellow

# Verify compiled output exists
if (-not (Test-Path "out/extension.js")) {
  Write-Host "⚠️  Compiled extension not found at out/extension.js. Did compilation succeed?" -ForegroundColor Yellow
  Write-Host "   Run: npm run compile" -ForegroundColor Gray
}

$filesToCopy = @(
  "package.json",
  "README.md",
  "out",
  "CHANGELOG.md",
  "LICENSE"
)

foreach ($file in $filesToCopy) {
    if (Test-Path $file) {
        Copy-Item $file $targetDir -Recurse -Force
        Write-Host "   ✅ Copied $file" -ForegroundColor Green
    } else {
        Write-Host "   ⚠️  Warning: $file not found" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "🎉 Navigation extension installed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Next steps:" -ForegroundColor Cyan
Write-Host "   1. Reload VS Code (Ctrl+Shift+P -> 'Developer: Reload Window')" -ForegroundColor White
Write-Host "   2. Look for '📂 Navigation' panel in the Explorer tab" -ForegroundColor White
Write-Host "   3. Configure navigation groups in VS Code settings:" -ForegroundColor White
Write-Host "      Settings -> Search 'navigation.groups'" -ForegroundColor Gray
Write-Host ""
Write-Host "📖 Ready to configure your navigation groups" -ForegroundColor Yellow 
Write-Host ""

# Create sample configuration file
$configSample = @"
{
  "navigation.groups": [
    {
      "name": "� My Project",
      "icon": "folder",
      "expanded": true,
      "children": [
        {
          "name": "📊 Source Code",
          "type": "filter",
          "icon": "file-code",
          "pattern": "src/**/*.{ts,js,cpp,h}",
          "exclude": ["*.test.*", "node_modules/**"]
        },
        {
          "name": "🧪 Tests",
          "type": "filter",
          "icon": "beaker",
          "pattern": "**/*test*",
          "exclude": ["node_modules/**"]
        },
        {
          "name": "📖 Documentation",
          "type": "files",
          "icon": "book",
          "files": [
            "README.md",
            "docs/setup.md"
          ]
        }
      ]
    }
  ]
}
"@

$sampleFile = "navigation-config-sample.json"
$configSample | Out-File $sampleFile -Encoding UTF8
Write-Host "💡 Sample configuration saved to: $sampleFile" -ForegroundColor Cyan