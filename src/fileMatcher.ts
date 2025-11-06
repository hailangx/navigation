// File matching utilities for Navigation extension

import * as vscode from 'vscode';
import * as path from 'path';
import * as fs from 'fs';

/**
 * Simple glob pattern matching utility
 */
export class FileMatcher {
    /**
     * Converts a simple glob pattern to RegExp
     * Supports: * (any chars), ** (any dirs), ? (single char)
     */
    private static globToRegex(pattern: string): RegExp {
        const escaped = pattern
            .replace(/\\/g, '/')  // Normalize path separators
            .replace(/[.+^${}()|[\]\\]/g, '\\$&')  // Escape regex special chars except * and ?
            .replace(/\*\*/g, '§DOUBLESTAR§')  // Temporarily replace **
            .replace(/\*/g, '[^/]*')  // * matches any chars except /
            .replace(/§DOUBLESTAR§/g, '.*')  // ** matches any chars including /
            .replace(/\?/g, '.');  // ? matches single char
        
        return new RegExp(`^${escaped}$`, 'i');
    }

    /**
     * Tests if a file path matches a glob pattern
     */
    static matches(filePath: string, pattern: string): boolean {
        const normalizedPath = filePath.replace(/\\/g, '/');
        const regex = this.globToRegex(pattern);
        return regex.test(normalizedPath);
    }

    /**
     * Tests if a file path matches any of the exclude patterns
     */
    static isExcluded(filePath: string, excludePatterns: string[] = []): boolean {
        return excludePatterns.some(pattern => this.matches(filePath, pattern));
    }

    /**
     * Finds all files in workspace that match a pattern
     */
    static async findFiles(pattern: string, exclude: string[] = []): Promise<string[]> {
        const workspaceFolders = vscode.workspace.workspaceFolders;
        if (!workspaceFolders || workspaceFolders.length === 0) {
            return [];
        }

        const results: string[] = [];
        const workspaceRoot = workspaceFolders[0].uri.fsPath;

        try {
            // Use VS Code's built-in file search for better performance
            const vscodePattern = pattern.replace(/\\/g, '/');
            const excludePattern = exclude.length > 0 ? `{${exclude.join(',')}}` : undefined;
            
            const uris = await vscode.workspace.findFiles(vscodePattern, excludePattern, 1000);
            
            for (const uri of uris) {
                const relativePath = path.relative(workspaceRoot, uri.fsPath).replace(/\\/g, '/');
                if (!this.isExcluded(relativePath, exclude)) {
                    results.push(relativePath);
                }
            }
        } catch (error) {
            // Fallback to manual traversal if VS Code search fails
            console.warn('VS Code file search failed, using fallback:', error);
            await this.traverseDirectory(workspaceRoot, '', pattern, exclude, results);
        }

        return results.sort();
    }

    /**
     * Manual directory traversal fallback
     */
    private static async traverseDirectory(
        basePath: string,
        relativePath: string,
        pattern: string,
        exclude: string[],
        results: string[]
    ): Promise<void> {
        const fullPath = path.join(basePath, relativePath);
        
        try {
            const stat = await fs.promises.stat(fullPath);
            
            if (stat.isFile()) {
                if (this.matches(relativePath, pattern) && !this.isExcluded(relativePath, exclude)) {
                    results.push(relativePath);
                }
            } else if (stat.isDirectory()) {
                const entries = await fs.promises.readdir(fullPath);
                
                for (const entry of entries) {
                    const childRelativePath = relativePath ? `${relativePath}/${entry}` : entry;
                    
                    // Skip if directory is excluded
                    if (this.isExcluded(childRelativePath, exclude)) {
                        continue;
                    }
                    
                    await this.traverseDirectory(basePath, childRelativePath, pattern, exclude, results);
                }
            }
        } catch (error) {
            // Skip files/dirs we can't access
            console.warn(`Cannot access ${fullPath}:`, error);
        }
    }

    /**
     * Checks if a file exists in the workspace
     */
    static async fileExists(filePath: string): Promise<boolean> {
        const workspaceFolders = vscode.workspace.workspaceFolders;
        if (!workspaceFolders || workspaceFolders.length === 0) {
            return false;
        }

        const workspaceRoot = workspaceFolders[0].uri.fsPath;
        const fullPath = path.join(workspaceRoot, filePath);
        
        try {
            const stat = await fs.promises.stat(fullPath);
            return stat.isFile();
        } catch {
            return false;
        }
    }
}