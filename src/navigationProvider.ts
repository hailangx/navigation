import * as vscode from 'vscode';
import * as path from 'path';
import { getNavigationConfig, NavigationGroupConfig, NavigationItemConfig } from './config';
import { FileMatcher } from './fileMatcher';

export class NavigationProvider implements vscode.TreeDataProvider<NavigationItem> {
    private _onDidChangeTreeData: vscode.EventEmitter<NavigationItem | undefined | null | void> = new vscode.EventEmitter<NavigationItem | undefined | null | void>();
    readonly onDidChangeTreeData: vscode.Event<NavigationItem | undefined | null | void> = this._onDidChangeTreeData.event;

    constructor(private workspaceRoot: string) {}

    refresh(): void {
        this._onDidChangeTreeData.fire();
    }

    getTreeItem(element: NavigationItem): vscode.TreeItem {
        return element;
    }

    async getChildren(element?: NavigationItem): Promise<NavigationItem[]> {
        if (!this.workspaceRoot) {
            vscode.window.showInformationMessage('No workspace folder found');
            return [];
        }

        if (element) {
            // If the element already has children cached, return them
            if (element.children) {
                return element.children;
            }
            
            // Otherwise, get children for this element
            return this.getChildItems(element);
        } else {
            return this.getRootItems();
        }
    }

    private async getRootItems(): Promise<NavigationItem[]> {
        const config = getNavigationConfig();
        const items: NavigationItem[] = [];

        for (const group of config.groups) {
            const item = new NavigationItem(
                group.name,
                vscode.TreeItemCollapsibleState.Expanded,
                'group',
                group.icon || 'folder',
                group
            );
            items.push(item);
        }

        return items;
    }

    private async getChildItems(element: NavigationItem): Promise<NavigationItem[]> {
        if (!element.config || element.type !== 'group') {
            return [];
        }

        const items: NavigationItem[] = [];
        const children = element.config.children || [];

        for (const child of children) {
            await this.processChildItem(child, items);
        }

        return items;
    }

    private async processChildItem(childConfig: NavigationItemConfig, items: NavigationItem[]): Promise<void> {
        switch (childConfig.type) {
            case 'files':
                await this.addFileItems(childConfig, items);
                break;
            case 'filter':
                await this.addFilterItems(childConfig, items);
                break;
            case 'group':
                await this.addGroupItem(childConfig, items);
                break;
        }
    }

    private async addFileItems(config: NavigationItemConfig, items: NavigationItem[]): Promise<void> {
        if (!config.files) return;

        // Create a group item that contains the files
        const groupItem = new NavigationItem(
            config.name,
            vscode.TreeItemCollapsibleState.Expanded,
            'fileGroup',
            config.icon || 'folder-opened',
            config
        );

        // Add individual file items as children
        const fileItems: NavigationItem[] = [];
        for (const filePath of config.files) {
            if (await FileMatcher.fileExists(filePath)) {
                const fileName = path.basename(filePath);
                const fileItem = new NavigationItem(
                    fileName,
                    vscode.TreeItemCollapsibleState.None,
                    'file',
                    this.getFileIcon(fileName)
                );

                fileItem.resourceUri = vscode.Uri.file(path.join(this.workspaceRoot, filePath));
                fileItem.command = {
                    command: 'navigation.openFile',
                    title: 'Open File',
                    arguments: [fileItem.resourceUri]
                };
                fileItem.tooltip = filePath;
                fileItems.push(fileItem);
            }
        }

        if (fileItems.length > 0) {
            // Cache the children in the group item
            groupItem.children = fileItems;
            items.push(groupItem);
        }
    }

    private async addFilterItems(config: NavigationItemConfig, items: NavigationItem[]): Promise<void> {
        if (!config.pattern) return;

        const matchedFiles = await FileMatcher.findFiles(config.pattern, config.exclude || []);
        if (matchedFiles.length === 0) return;

        // Create a group item for the filter results
        const groupItem = new NavigationItem(
            `${config.name} (${matchedFiles.length})`,  
            vscode.TreeItemCollapsibleState.Expanded,
            'filterGroup',
            config.icon || 'search',
            config
        );

        // Add individual file items
        const fileItems: NavigationItem[] = [];
        for (const filePath of matchedFiles) {
            const fileName = path.basename(filePath);
            const fileItem = new NavigationItem(
                fileName,
                vscode.TreeItemCollapsibleState.None,
                'file',
                this.getFileIcon(fileName)
            );

            fileItem.resourceUri = vscode.Uri.file(path.join(this.workspaceRoot, filePath));
            fileItem.command = {
                command: 'navigation.openFile',
                title: 'Open File',
                arguments: [fileItem.resourceUri]
            };
            fileItem.tooltip = filePath;
            fileItems.push(fileItem);
        }

        // Cache the children in the group item
        groupItem.children = fileItems;
        items.push(groupItem);
    }

    private async addGroupItem(config: NavigationItemConfig, items: NavigationItem[]): Promise<void> {
        const groupItem = new NavigationItem(
            config.name,
            vscode.TreeItemCollapsibleState.Expanded,
            'group',
            config.icon || 'folder',
            config
        );
        items.push(groupItem);
    }

    private getFileIcon(fileName: string): string {
        const ext = path.extname(fileName).toLowerCase();
        switch (ext) {
            case '.cpp':
            case '.c':
                return 'file-code';
            case '.h':
            case '.hpp':
                return 'symbol-class';
            case '.md':
                return 'markdown';
            case '.json':
                return 'json';
            case '.ts':
                return 'symbol-method';
            case '.js':
                return 'symbol-function';
            default:
                return 'file';
        }
    }
}

export class NavigationItem extends vscode.TreeItem {
    public children?: NavigationItem[];

    constructor(
        public readonly label: string,
        public readonly collapsibleState: vscode.TreeItemCollapsibleState,
        public readonly type: 'group' | 'fileGroup' | 'filterGroup' | 'file',
        public readonly icon?: string,
        public readonly config?: NavigationItemConfig | NavigationGroupConfig
    ) {
        super(label, collapsibleState);
        this.tooltip = this.label;
        this.contextValue = type;

        if (icon) {
            this.iconPath = new vscode.ThemeIcon(icon);
        }
    }
}
