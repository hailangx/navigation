# Navigation Extension

A configurable VS Code extension for organizing files into custom navigation trees in the Explorer panel.

![Navigation Extension Demo](https://github.com/hailangx/navigation/blob/master/navigation.png?raw=true)


## 🚀 Try it Now!

**Want to see it in action immediately?** Clone and run:

```bash
git clone https://github.com/hailangx/navigation.git
cd navigation
./bootstrap.ps1
```

✨ **That's it!** The extension will be installed and configured with a comprehensive demo. Just reload VS Code and check the Explorer panel for "📂 Navigation".

## Features

The screenshot above shows the Navigation extension in action with the demo configuration. You'll see:

- **Configurable Navigation Groups**: Define custom file organization hierarchies
- **Three Organization Types**:
  - **Files**: Exact file paths for precise control
  - **Filter**: Pattern-based file matching with glob support  
  - **Group**: Nested navigation groups
- **Explorer Integration**: Appears directly in VS Code Explorer tab
- **Auto-refresh**: Updates when files change in workspace
- **Icon Support**: VS Code icon themes for visual organization

## Configuration

Configure navigation groups in your VS Code settings or workspace settings:

```json
{
  "navigation.groups": [
    {
      "name": "� My Project",
      "icon": "folder",
      "expanded": true,
      "children": [
        {
          "name": "📊 Source Code",
          "type": "files",
          "icon": "file-code",
          "files": [
            "src/main.ts",
            "src/utils.ts",
            "src/config.ts"
          ]
        },
        {
          "name": "🧪 All Tests",
          "type": "filter",
          "icon": "beaker",
          "pattern": "**/*test*",
          "exclude": ["node_modules/**", "*.log"]
        },
        {
          "name": "📖 Documentation",
          "type": "group",
          "icon": "book",
          "children": [
            {
              "name": "Docs",
              "type": "filter",
              "pattern": "docs/**/*.md"
            }
          ]
        }
      ]
    }
  ]
}
```

## 🎯 Quick Demo

## 🛠️ Releasing a New Local Version

If you make code changes and want to create a new patch release and install it locally, use the provided `release-and-install.ps1` script. It will:

- Bump the patch version in `package.json` (or accept an explicit version)
- Compile the TypeScript code
- Package the extension into a `.vsix`
- Install the `.vsix` locally in your VS Code
- Commit the version bump and `.vsix` to git and create a tag (optional)
- Push commits and tag to `origin` (optional)

Quick usage (from the repository root):

```powershell
# Bump patch, package, install, commit, tag, and push
./release-and-install.ps1

# Dry run / local only: bump & package, but don't tag or push
./release-and-install.ps1 -NoPush -NoTag

# Specify explicit version
./release-and-install.ps1 -Version 1.2.3 -NoPush -NoTag
```

If you only want to build and install quickly without committing or tagging, use `quick-install.ps1`:

```powershell
./quick-install.ps1
```

Notes:
- The release script renames the generated `.vsix` to `navigation-<version>.vsix` and commits it. If you don't want the `.vsix` in git, run with `-NoPush` and manually remove the file before committing, or edit the script.
- Make sure you have `code` (VS Code CLI) available in your PATH for automatic install.

Releases folder
---------------

After running the release script, the generated `.vsix` is moved into the `releases/` folder at the repository root and the file is added to git. Example:

```
releases/navigation-1.0.2.vsix
```

If you prefer not to track built artifacts in git, either remove the file before committing or run the script with `-NoPush` and clean up the file.

Release quick installer
-----------------------

Each release will include a small `quick-install.ps1` placed alongside the `.vsix` in the `releases/` folder. This script finds the latest `.vsix` in the same folder and runs the VS Code CLI to install it. This is useful for users who download release artifacts directly from GitHub.

Note: The extension artifacts are not signed. On some platforms you may need to use the VS Code UI to "Install from VSIX..." if the automatic install via `code --install-extension` is blocked.


To quickly try out the extension with a comprehensive example, copy the configuration from `navigation-demo.json` in this repository:

1. **Copy the demo config**: Open `navigation-demo.json` and copy its contents
2. **Open VS Code settings**: `Ctrl+,` (Cmd+, on Mac)
3. **Search for "navigation"**
4. **Edit the "Navigation: Groups" setting**
5. **Paste the demo configuration**
6. **Save and see the navigation panel populate**

The demo configuration showcases:
- 📁 **File organization** with exact file paths
- 🔍 **Pattern matching** for TypeScript, JSON, and Markdown files
- 📂 **Nested groups** for logical organization
- 🎨 **Various icons** and display options
- ⚡ **Quick access** groups for frequently used files

## Configuration Types

### NavigationGroupConfig
- `name`: Display name for the group
- `icon`: VS Code icon name (optional)
- `expanded`: Whether expanded by default (optional)
- `children`: Array of NavigationItemConfig

### NavigationItemConfig
- `name`: Display name
- `type`: "files" | "filter" | "group"
- `icon`: VS Code icon name (optional)

**For type "files":**
- `files`: Array of exact file paths

**For type "filter":**
- `pattern`: Glob pattern to match files
- `exclude`: Array of patterns to exclude (optional)

**For type "group":**
- `children`: Array of nested NavigationItemConfig

## Getting Started

The extension starts with an empty configuration. Configure navigation groups through VS Code settings or use the "Configure Navigation Groups" command from the navigation panel.

## Commands

- **Navigation: Refresh** - Manually refresh the navigation tree
- **Navigation: Toggle** - Show/hide the navigation panel  
- **Navigation: Configure Navigation Groups** - Opens configuration file for editing
  - **Workspace**: Opens `.vscode/settings.json` (preferred for project-specific config)
  - **User Settings**: Opens VS Code settings if no workspace config exists
  - **Demo Helper**: Offers to open `navigation-demo.json` for examples

## Pattern Matching

The filter type supports simple glob patterns:
- `*` - Matches any characters except path separators
- `**` - Matches any characters including path separators (recursive)
- `?` - Matches single character
- `{a,b}` - Matches either 'a' or 'b'

Examples:
- `src/**/*.ts` - All TypeScript files in src directory and subdirectories
- `test/**/test*.{cpp,h}` - All test files with .cpp or .h extension
- `docs/**/*.md` - All Markdown files in docs directory


## 📦 Installation & Quick Start

### 🚀 Option 1: Try it Now (Clone & Bootstrap) - **Recommended for Developers**
Experience the extension immediately with full demo:

```bash
# Clone the repository
git clone https://github.com/hailangx/navigation.git
cd navigation

# Run the bootstrap script (automatically sets everything up)
./bootstrap.ps1
```

The bootstrap script will:
- ✅ Install all dependencies
- ✅ Compile the TypeScript code  
- ✅ Package the extension
- ✅ Install it locally in VS Code
- ✅ Activate the demo configuration

**After bootstrapping, just reload VS Code and see the Navigation panel in action!**

### 📥 Option 2: Manual Installation (End Users)
1. Download the latest `navigation-1.0.0.vsix` file from the [Releases page](https://github.com/hailangx/navigation/releases)
2. Open VS Code
3. Go to Extensions view (`Ctrl+Shift+X`)
4. Click on the `...` menu in the Extensions view
5. Select "Install from VSIX..."
6. Choose the downloaded `.vsix` file

### 🛠️ Option 3: Build from Source
```bash
git clone https://github.com/hailangx/navigation.git
cd navigation
npm install
npm run build
code --install-extension navigation-1.0.0.vsix
```


## Development

```bash
# Install dependencies
npm install

# Compile TypeScript
npm run compile

# Watch for changes
npm run watch
```

## License

MIT License
