Read project CONVENTIONS.md and README.md to understand structure and conventions. 
Check for CONVENTIONS.md in: current directory, parent directories, and .conventions/ subdirectory.

{{#if ARGUMENTS}}
**PRIMARY FOCUS AREA: {{ARGUMENTS}}**

First, identify if the argument is a file or directory and read relevant documentation:
- If it's a directory, read any README.md, CLAUDE.md, or documentation files in that directory
- If it's a file, read the file and any README.md in the same directory
- Look for related configuration files, tests, or documentation
- Understand the purpose and context of this specific area

Then provide focused context for this area while maintaining awareness of the broader project structure.
{{/if}}

Then run this optimized bash command to get comprehensive project context:

```bash
# Find repo root and cache paths
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
IS_GIT=$(git rev-parse --git-dir >/dev/null 2>&1 && echo "yes" || echo "no")
echo "=== REPO ROOT: $REPO_ROOT ==="
echo "=== CURRENT DIR: $(pwd) ==="
{{#if ARGUMENTS}}
echo "=== FOCUS AREA: {{ARGUMENTS}} ==="
{{/if}}

# Fast project structure using git ls-files (for git repos) or tree
echo -e "\n=== PROJECT STRUCTURE ==="
if [ "$IS_GIT" = "yes" ]; then
    # Much faster for git repos - reads from index
    git ls-files | grep -E "^[^/]+(/[^/]+){0,2}/?$" | sort -u | head -50
else
    # Fallback for non-git projects
    tree -L 3 -d --gitignore 2>/dev/null || find . -maxdepth 3 -type d | sort
fi

# Single-pass file discovery
echo -e "\n=== KEY PROJECT FILES ==="
if [ "$IS_GIT" = "yes" ]; then
    # Find all important files in one pass
    git ls-files | grep -E "(CONVENTIONS\.md|README\.md|CLAUDE\.md|package\.json|Cargo\.toml|pyproject\.toml|requirements\.txt|Gemfile|go\.mod|tsconfig\.json|\.env\.example)$" | head -20
    # Also check .conventions directory explicitly
    [ -d "$REPO_ROOT/.conventions" ] && find "$REPO_ROOT/.conventions" -name "CONVENTIONS.md" 2>/dev/null
else
    # Non-git fallback
    find "$REPO_ROOT" -maxdepth 3 \( -name "CONVENTIONS.md" -o -name "README.md" -o -name "CLAUDE.md" -o -name "package.json" -o -name "*.toml" \) 2>/dev/null | head -20
fi

# Recent changes
echo -e "\n=== RECENT CHANGES ==="
[ "$IS_GIT" = "yes" ] && git log --oneline -5 || echo "Not a git repository"
```

This optimized version:
- Uses git ls-files for 10-100x faster performance in git repos
- Single-pass file discovery reduces filesystem traversals
- Explicitly checks .conventions directory for CONVENTIONS.md
- Caches git status check to avoid repeated calls
- Falls back gracefully for non-git projects
{{#if ARGUMENTS}}
- Focused analysis of the specified area: {{ARGUMENTS}}
{{/if}}
