# Contributing to Navigation Extension

Welcome! Thanks for your interest in contributing to the Navigation extension. This guide will help you get started.

## 🚀 Quick Setup (Recommended)

The fastest way to get started is using our bootstrap script:

```bash
git clone https://github.com/hailangx/navigation.git
cd navigation
./bootstrap.ps1
```

This will automatically:
- Install dependencies
- Compile TypeScript
- Package the extension  
- Install it locally in VS Code
- Activate the demo configuration

## 🛠️ Development Setup

### Prerequisites
- [Node.js](https://nodejs.org/) (v16 or later)
- [VS Code](https://code.visualstudio.com/)
- [Git](https://git-scm.com/)

### Manual Setup
```bash
# Clone and enter the directory
git clone https://github.com/hailangx/navigation.git
cd navigation

# Install dependencies
npm install

# Compile TypeScript
npm run compile

# Package extension (optional)
npm run package
```

## 🧪 Testing Your Changes

### Method 1: F5 Debug (Recommended)
1. Open the project in VS Code
2. Press `F5` to start debugging
3. This opens a new "Extension Development Host" window
4. Your extension will be active in the new window
5. Make changes and reload the window to test

### Method 2: Install Locally
```bash
# Build and install locally
npm run build
code --install-extension navigation-1.0.0.vsix --force

# Or use VS Code tasks (Ctrl+Shift+P → "Tasks: Run Task")
# - "Build & Install Extension"
```

## 📁 Project Structure

```
navigation/
├── src/
│   ├── extension.ts          # Main extension entry point
│   ├── navigationProvider.ts # Tree data provider
│   ├── config.ts            # Configuration handling
│   └── fileMatcher.ts       # File pattern matching
├── .vscode/
│   ├── settings.json        # Workspace settings (includes demo)
│   ├── tasks.json          # Build tasks
│   ├── launch.json         # Debug configuration
│   └── extensions.json     # Recommended extensions
├── navigation-demo.json     # Demo configuration
├── bootstrap.ps1           # Quick setup script
└── package.json           # Extension manifest
```

## 🎯 Demo Configuration

The repository includes a comprehensive demo configuration:
- **Workspace Settings**: `.vscode/settings.json` has active demo config
- **JSON File**: `navigation-demo.json` for copying elsewhere
- **Setup Script**: `demo-setup.ps1` for guided setup

When you open this workspace in VS Code, you'll immediately see the Navigation panel in action!

## 🔧 Available NPM Scripts

```bash
npm run compile      # Compile TypeScript
npm run watch        # Watch and auto-compile changes
npm run package      # Create .vsix package
npm run build        # Compile + package
```

## 🐛 Debugging

### VS Code Debugging
- Press `F5` to start debugging
- Set breakpoints in TypeScript files
- Use the Debug Console for logging

### Extension Host Logs
- In the Extension Development Host window
- Open Developer Tools: `Help → Toggle Developer Tools`
- Check Console for extension logs

## 📝 Making Changes

### Configuration Schema
The extension configuration is defined in `package.json` under `contributes.configuration`. Update this when adding new config options.

### Tree Provider
Main logic in `src/navigationProvider.ts`:
- `getChildren()`: Returns tree items
- `getTreeItem()`: Formats individual items
- File watching and refresh logic

### File Matching  
Pattern matching logic in `src/fileMatcher.ts`:
- Glob pattern support
- Exclude pattern handling
- File type detection

## 🧪 Testing Configuration

Test different configurations by:

1. **Modifying workspace settings** (`.vscode/settings.json`)
2. **Using the demo configs** (`navigation-demo.json`)
3. **Creating custom test configs** in your user settings

## 📋 Pull Request Guidelines

1. **Fork and create a branch** from `master`
2. **Test your changes** using F5 debug or local installation
3. **Update documentation** if adding features
4. **Add example configs** for new features
5. **Ensure TypeScript compiles** without errors

## 🎉 What to Contribute

Ideas for contributions:
- 🐛 Bug fixes
- ✨ New organization types
- 🎨 UI improvements  
- 📖 Documentation improvements
- 🧪 Test configurations
- 🚀 Performance improvements

## 💡 Questions?

- **Issues**: Open a GitHub issue
- **Discussions**: Use GitHub Discussions
- **Quick questions**: Check the README or demo configs

Happy coding! 🚀