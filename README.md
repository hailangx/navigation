# Navigation Extension

A configurable VS Code extension for organizing files into custom navigation trees in the Explorer panel.

## 📦 Installation

### Option 1: Manual Installation (Recommended)
1. Download the latest `navigation-1.0.0.vsix` file from the [Releases page](https://github.com/hailangx/navigation/releases)
2. Open VS Code
3. Go to Extensions view (`Ctrl+Shift+X`)
4. Click on the `...` menu in the Extensions view
5. Select "Install from VSIX..."
6. Choose the downloaded `.vsix` file

### Option 2: From Source
1. Clone this repository
2. Run `npm install`
3. Run `npm run compile`
4. Run `vsce package` to create the `.vsix` file
5. Install the generated `.vsix` file following the steps above

## Features

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

The extension starts with an empty configuration. Add navigation groups through VS Code settings or use the "Add Navigation Group" command from the navigation panel.

## Commands

- **Navigation: Refresh** - Manually refresh the navigation tree
- **Navigation: Toggle** - Show/hide the navigation panel
- **Navigation: Add Group** - Add a new navigation group via UI

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

## Installation

1. Copy the extension folder to your VS Code extensions directory
2. Run `npm install` to install dependencies
3. Run `npm run compile` to build the extension
4. Reload VS Code
5. The "📂 Navigation" panel will appear in the Explorer tab

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

ISC License