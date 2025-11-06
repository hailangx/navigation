# Change Log

All notable changes to the "Navigation" extension will be documented in this file.

## [1.0.2] - 2025-11-06

### Fixed
- Fixed `scripts/dev-install.ps1` so the extension folder name is derived from `package.json` (publisher, name, version) which allows unpacked developer installs to register correctly in VS Code.
- Release automation now moves generated `.vsix` artifacts into the `releases/` folder and supports test flags (`-NoPush`, `-NoTag`, `-SkipInstall`) used during local verification.
- Consolidated developer PowerShell scripts into the `scripts/` folder and moved the quick installer to `releases/quick-install.ps1` to avoid confusion between dev vs release installers.
- Added `LICENSE` so `vsce package` completes successfully during packaging.

### Changed
- Package version was bumped to `1.0.2` during release tests.
- README and demo configuration updated to include a sample config and usage notes.

### Notes
- Planned: add an `icon` reference (`navigation.png`) to `package.json` and re-package; pending confirmation.

## [1.0.0] - 2025-11-06

### Added
- Initial release of Navigation extension
- Configurable navigation groups in VS Code Explorer
- Support for three organization types:
  - **Files**: Exact file paths for precise control
  - **Filter**: Pattern-based file matching with glob support
  - **Group**: Nested navigation groups
- Auto-refresh when files change in workspace
- VS Code icon theme support
- Explorer integration with custom tree view
- Commands for refreshing and managing navigation groups

### Features
- Custom file organization hierarchies
- Pattern-based file filtering with exclude support
- Nested group structures
- Real-time workspace file monitoring
- Configurable icons and display names