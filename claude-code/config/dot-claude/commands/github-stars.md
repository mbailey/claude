# GitHub Stars

Identify and read the relevant file based on ARGUMENTS (clarify with the user if unsure). Compile a list of all github repo urls in the file and then in parallel check for the current numbers of stars and forks. Update the document with the totals immediately after each url using concise format.

## Usage
```
/github-stars [file-path]
/github-stars README.md
/github-stars docs/resources.md
```

## Instructions

1. **Identify the target file**:
   - Use the ARGUMENTS to determine which file to process
   - If no file is specified or unclear, ask the user to clarify
   - Read the specified file to find GitHub repository URLs

2. **Extract GitHub URLs**:
   - Search for patterns matching GitHub repository URLs:
     - `https://github.com/owner/repo`
     - `github.com/owner/repo`
     - Markdown links containing GitHub URLs
   - Create a list of unique repository URLs

3. **Fetch repository data in parallel**:
   - For each GitHub URL, use ONE of these methods:
   
   **Method A - GitHub Stargazers/Forks Pages (Most Reliable)**:
   - Use WebFetch on `https://github.com/owner/repo/stargazers` for star count
   - Use WebFetch on `https://github.com/owner/repo/forks` for fork count
   - Look for the counts in page titles, headers, or navigation elements
   - These dedicated pages have cleaner, more consistent formatting than main repo page
   
   **Method B - Direct GitHub Page**:
   - Use WebFetch on the repository URL (e.g., `https://github.com/owner/repo`)
   - Look for these patterns in the HTML:
     - Stars: Find text containing "Star" with a number (e.g., "12.3k stars", "1,234")
     - Forks: Find text containing "Fork" with a number (e.g., "456 forks")
   - The numbers are usually in the repository header/stats section
   
   **Method C - GitHub API (if available)**:
   - Use WebFetch on `https://api.github.com/repos/owner/repo`
   - Extract `stargazers_count` and `forks_count` from the JSON response
   - Note: May have rate limits without authentication
   
   **Method D - Web Search (fallback)**:
   - Search for "{owner}/{repo} github stars forks"
   - Extract numbers from search results
   
   - Process all URLs concurrently using multiple tool calls in one message
   - Handle repositories that may have been deleted or made private

4. **Update the document**:
   - For each GitHub URL found, append the stats in a concise format
   - **Smart formatting based on context**:
     - If URL is in a shell command (like `git clone`, `docker pull`, `wget`, etc.): Add as comment `# [★ stars | ⚡ forks]`
     - If URL is in markdown link or plain text: Add inline `[★ stars | ⚡ forks]`
     - If URL spans multiple lines or in code blocks: Add comment on same line or next line
   - Preserve the existing formatting and structure
   - Only add the stats, don't modify other content

## Parameters

{{#if ARGUMENTS}}
- **ARGUMENTS**: {{ARGUMENTS}} - The file path or pattern to search for GitHub URLs
{{/if}}

## Examples

### Input file content:
```markdown
Check out these repositories:
- [Claude Code](https://github.com/anthropics/claude-code)
- FastAPI: https://github.com/tiangolo/fastapi

## Installation
```bash
git clone https://github.com/tiangolo/fastapi
docker pull registry/image-from-github.com/owner/repo
```
```

### After running `/github-stars README.md`:
```markdown
Check out these repositories:
- [Claude Code](https://github.com/anthropics/claude-code) [★ 1.2k | ⚡ 89]
- FastAPI: https://github.com/tiangolo/fastapi [★ 67.3k | ⚡ 5.7k]

## Installation
```bash
git clone https://github.com/tiangolo/fastapi # [★ 67.3k | ⚡ 5.7k]
docker pull registry/image-from-github.com/owner/repo # [★ 234 | ⚡ 45]
```
```

## Notes

- Requires web access to fetch current repository statistics
- Handles various GitHub URL formats (with/without https, in markdown links)
- Updates are made inline, preserving document structure
- Uses parallel processing for efficiency with multiple URLs
- Stats are added in a concise, scannable format
- If stats already exist, they will be updated with current values

## Technical Details

### Number Formatting
- Use 'k' for thousands (e.g., 1.2k instead of 1,234)
- Use 'M' for millions (e.g., 1.5M instead of 1,500,000)
- Round to 1 decimal place for readability
- Examples: 1.2k, 15.7k, 234, 1.5M

### URL Pattern Matching
- Extract owner and repo from patterns like:
  - `https://github.com/owner/repo`
  - `github.com/owner/repo`
  - `https://github.com/owner/repo/blob/main/file.md` → extract `owner/repo`
  - `[Link text](https://github.com/owner/repo)` → extract URL from markdown
- Ignore non-repository URLs like:
  - `github.com/docs/`
  - `github.com/settings/`
  - `github.com` (no path)

### Error Handling
- If a repository is not found (404): Skip or mark as `[Repository not found]`
- If access is denied (private repo): Mark as `[Private repository]`
- If rate limited: Fall back to web search method
- If network error: Retry once, then skip if still failing

## Technical Details

### Number Formatting
- Use 'k' for thousands (e.g., 1.2k instead of 1,234)
- Use 'M' for millions (e.g., 1.5M instead of 1,500,000)
- Round to 1 decimal place for readability
- Examples: 1.2k, 15.7k, 234, 1.5M

### URL Pattern Matching
- Extract owner and repo from patterns like:
  - `https://github.com/owner/repo`
  - `github.com/owner/repo`
  - `https://github.com/owner/repo/blob/main/file.md` → extract `owner/repo`
  - `[Link text](https://github.com/owner/repo)` → extract URL from markdown
- Ignore non-repository URLs like:
  - `github.com/docs/`
  - `github.com/settings/`
  - `github.com` (no path)

### Error Handling
- If a repository is not found (404): Skip or mark as `[Repository not found]`
- If access is denied (private repo): Mark as `[Private repository]`
- If rate limited: Fall back to web search method
- If network error: Retry once, then skip if still failing