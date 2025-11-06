// Configuration types and utilities for Navigation extension

export interface NavigationGroupConfig {
    name: string;
    icon?: string;
    expanded?: boolean;
    children?: NavigationItemConfig[];
}

export interface NavigationItemConfig {
    name: string;
    type: 'group' | 'files' | 'filter';
    icon?: string;
    files?: string[];           // For type 'files' - exact file paths
    pattern?: string;           // For type 'filter' - glob pattern
    exclude?: string[];         // Patterns to exclude
    children?: NavigationItemConfig[];  // For type 'group'
}

export interface NavigationConfig {
    groups: NavigationGroupConfig[];
}

/**
 * Default configuration - empty groups for generic use
 */
export const DEFAULT_CONFIG: NavigationConfig = {
    groups: []
};

/**
 * Gets the navigation configuration from VS Code settings or returns default
 */
export function getNavigationConfig(): NavigationConfig {
    const vscode = require('vscode');
    const config = vscode.workspace.getConfiguration('navigation');
    const groups = config.get('groups', []) as NavigationGroupConfig[];
    
    return { groups };
}

/**
 * Saves navigation configuration to VS Code settings
 */
export async function saveNavigationConfig(config: NavigationConfig): Promise<void> {
    const vscode = require('vscode');
    const workspaceConfig = vscode.workspace.getConfiguration('navigation');
    await workspaceConfig.update('groups', config.groups, vscode.ConfigurationTarget.Workspace);
}