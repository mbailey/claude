# Claude Web - Browser Interface

Access Claude through the web interface at claude.ai - the official web application for Claude AI.

## Key Features

- No installation required - runs in any modern browser
- Full conversation history with search
- Projects for organizing related conversations
- Artifacts for code, documents, and interactive content
- Custom instructions per project
- File uploads (images, PDFs, text files)
- Export conversations
- Team workspaces (Pro/Team plans)

## Quickstart

```bash
# Open Claude in your default browser
open https://claude.ai

# Or navigate directly to:
# New conversation: https://claude.ai/new
# Your chats: https://claude.ai/chats
```

## Browser Requirements

### Supported Browsers
- Chrome 90+
- Firefox 88+
- Safari 14+
- Edge 90+

### Mobile Browsers
- iOS Safari 14+
- Chrome for Android
- Samsung Internet

## Features

### Projects
- Organize conversations by topic or purpose
- Custom instructions per project
- Shared knowledge base within project
- Pin important conversations

### Artifacts
- Interactive code execution
- Live preview for HTML/CSS/JavaScript
- Markdown rendering
- SVG visualization
- Syntax highlighting

### File Uploads
- Images: JPEG, PNG, GIF, WebP
- Documents: PDF, TXT, MD, CSV
- Code files: Most programming languages
- Max file size: 10MB per file
- Multiple files per message

### Keyboard Shortcuts
- `Cmd/Ctrl + Enter`: Send message
- `Cmd/Ctrl + K`: New conversation
- `Cmd/Ctrl + /`: Toggle sidebar
- `Shift + Enter`: New line in input
- `Esc`: Cancel editing

## Usage Tips

### Effective Prompting
- Use Projects for context persistence
- Upload relevant files for better responses
- Use custom instructions for consistent behavior
- Break complex tasks into steps

### Managing Conversations
- Star important chats
- Use search to find past conversations
- Export valuable conversations
- Archive completed projects

### Performance Tips
- Clear browser cache if experiencing issues
- Use desktop browser for best performance
- Close unused tabs to free memory
- Disable browser extensions if having problems

## Account & Plans

### Free Plan
- Limited messages per day
- Access to Claude 3.5 Sonnet
- Basic features

### Pro Plan ($20/month)
- 5x more usage
- Access to Claude 3 Opus
- Priority access during high traffic
- Projects feature

### Team Plan
- Everything in Pro
- Centralized billing
- Team workspace
- Admin controls

## Browser-Specific Tips

### Chrome
- Install as PWA for app-like experience
- Use Chrome profiles for multiple accounts

### Safari
- Enable cross-site tracking for full features
- Add to dock for quick access

### Firefox
- Disable tracking protection if issues arise
- Use containers for account separation

## Bookmarklets

Save these as bookmarks for quick actions:

```javascript
// Quick new chat
javascript:window.location='https://claude.ai/new'

// Export current conversation
javascript:(() => {
  const button = document.querySelector('[aria-label="Export conversation"]');
  if(button) button.click();
})();
```

## Troubleshooting

### Login Issues
- Clear cookies for claude.ai
- Try incognito/private mode
- Disable VPN if using one
- Check if cookies are enabled

### Performance Issues
- Update browser to latest version
- Clear browser cache
- Disable hardware acceleration
- Try different browser

### Feature Issues
- Ensure JavaScript is enabled
- Check browser console for errors
- Disable ad blockers
- Update browser

## Documentation

- **Main Site**: [claude.ai](https://claude.ai)
- **Help Center**: [support.anthropic.com](https://support.anthropic.com)
- **Status Page**: [status.anthropic.com](https://status.anthropic.com)
- **Privacy**: [Privacy Policy](https://www.anthropic.com/privacy)

## Tips & Tricks

### Power User Features
1. Use `@` to reference previous messages
2. Drag and drop files directly into chat
3. Use markdown for formatting
4. Create templates with Projects
5. Keyboard navigation for efficiency

### Privacy Features
- No training on your data (Pro/Team)
- Delete conversations anytime
- Export all your data
- Control data retention settings