import * as vscode from 'vscode';
import { NavigationProvider } from './navigationProvider';
import { getNavigationConfig, saveNavigationConfig, DEFAULT_CONFIG } from './config';

export function activate(context: vscode.ExtensionContext) {
    const rootPath = vscode.workspace.workspaceFolders && vscode.workspace.workspaceFolders.length > 0
        ? vscode.workspace.workspaceFolders[0].uri.fsPath
        : '';

    if (!rootPath) {
        vscode.window.showErrorMessage('Navigation: No workspace folder found');
        return;
    }

    // Create the tree data provider
    const provider = new NavigationProvider(rootPath);
    
    // Register the tree view
    const treeView = vscode.window.createTreeView('navigationFiles', {
        treeDataProvider: provider,
        showCollapseAll: true
    });

    // Set context to show the view
    vscode.commands.executeCommand('setContext', 'navigation:enabled', true);

    // Register commands
    const refreshCommand = vscode.commands.registerCommand('navigation.refresh', () => {
        provider.refresh();
    });

    const openFileCommand = vscode.commands.registerCommand('navigation.openFile', (resourceUri) => {
        if (resourceUri) {
            vscode.window.showTextDocument(resourceUri);
        }
    });

    const toggleCommand = vscode.commands.registerCommand('navigation.toggle', () => {
        // Toggle the context to show/hide the view
        const currentContext = context.workspaceState.get('navigation:enabled', true);
        const newContext = !currentContext;
        context.workspaceState.update('navigation:enabled', newContext);
        vscode.commands.executeCommand('setContext', 'navigation:enabled', newContext);
        
        if (newContext) {
            vscode.window.showInformationMessage('Navigation enabled');
        } else {
            vscode.window.showInformationMessage('Navigation disabled');
        }
    });

    const addGroupCommand = vscode.commands.registerCommand('navigation.addGroup', async () => {
        try {
            // Try to open workspace settings first (preferred)
            const workspaceFolders = vscode.workspace.workspaceFolders;
            if (workspaceFolders && workspaceFolders.length > 0) {
                const workspaceUri = workspaceFolders[0].uri;
                const settingsPath = vscode.Uri.joinPath(workspaceUri, '.vscode', 'settings.json');
                
                try {
                    // Check if workspace settings file exists
                    await vscode.workspace.fs.stat(settingsPath);
                    
                    // Open the workspace settings file
                    const document = await vscode.workspace.openTextDocument(settingsPath);
                    await vscode.window.showTextDocument(document);
                    
                    // Show helpful message with instructions
                    vscode.window.showInformationMessage(
                        'Edit "navigation.groups" in this workspace settings file. See navigation-demo.json for examples.',
                        'Open Demo Config'
                    ).then(selection => {
                        if (selection === 'Open Demo Config') {
                            const demoPath = vscode.Uri.joinPath(workspaceUri, 'navigation-demo.json');
                            vscode.workspace.openTextDocument(demoPath).then(doc => {
                                return vscode.window.showTextDocument(doc, vscode.ViewColumn.Beside);
                            }, () => {
                                vscode.window.showWarningMessage('Demo config file not found. Check the repository for navigation-demo.json');
                            });
                        }
                    });
                    
                    return;
                } catch (error) {
                    // Workspace settings file doesn't exist, we'll create it or fall back to user settings
                }
            }
            
            // Fallback: Open user settings with navigation configuration
            await vscode.commands.executeCommand('workbench.action.openSettings', 'navigation.groups');
            
            vscode.window.showInformationMessage(
                'Configure navigation groups in settings. Search for "navigation" to find the setting.',
                'Show Example'
            ).then(selection => {
                if (selection === 'Show Example') {
                    vscode.window.showInformationMessage(
                        'Example: Add this to your settings.json:\n' +
                        '{\n' +
                        '  "navigation.groups": [\n' +
                        '    {\n' +
                        '      "name": "📁 My Files",\n' +
                        '      "icon": "folder",\n' +
                        '      "expanded": true,\n' +
                        '      "children": [\n' +
                        '        {\n' +
                        '          "name": "Source Code",\n' +
                        '          "type": "filter",\n' +
                        '          "pattern": "src/**/*.ts"\n' +
                        '        }\n' +
                        '      ]\n' +
                        '    }\n' +
                        '  ]\n' +
                        '}'
                    );
                }
            });
            
        } catch (error) {
            vscode.window.showErrorMessage(`Failed to open configuration: ${error}`);
        }
    });

    // Initialize default configuration if none exists
    const initializeConfig = async () => {
        const config = getNavigationConfig();
        if (config.groups.length === 0) {
            vscode.window.showInformationMessage('Navigation: Ready to use. Configure navigation groups in workspace settings.');
        }
    };

    // Watch for configuration changes
    const configWatcher = vscode.workspace.onDidChangeConfiguration(event => {
        if (event.affectsConfiguration('navigation.groups')) {
            provider.refresh();
        }
    });

    // Auto-refresh when workspace files change
    const fileWatcher = vscode.workspace.createFileSystemWatcher('**/*.{cpp,h,md,ts,js}');
    fileWatcher.onDidChange(() => provider.refresh());
    fileWatcher.onDidCreate(() => provider.refresh());
    fileWatcher.onDidDelete(() => provider.refresh());

    // Initialize on startup
    initializeConfig();

    // Add commands to subscriptions
    context.subscriptions.push(
        treeView, 
        refreshCommand, 
        openFileCommand, 
        toggleCommand, 
        addGroupCommand,
        configWatcher,
        fileWatcher
    );
}

export function deactivate() {
    vscode.commands.executeCommand('setContext', 'navigation:enabled', false);
}