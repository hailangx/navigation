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
        const groupName = await vscode.window.showInputBox({
            prompt: 'Enter group name',
            placeHolder: 'My Navigation Group'
        });

        if (!groupName) return;

        const config = getNavigationConfig();
        config.groups.push({
            name: groupName,
            icon: 'folder',
            expanded: true,
            children: []
        });

        await saveNavigationConfig(config);
        provider.refresh();
        vscode.window.showInformationMessage(`Added navigation group: ${groupName}`);
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