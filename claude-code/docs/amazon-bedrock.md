# Using Claude Code on Amazon Bedrock

Use AWS-hosted Claude models to power Claude Code.

## Resources

- [AWS Community: Claude Code on Amazon Bedrock Quick Setup Guide](https://community.aws/content/2tXkZKrZzlrlu0KfH8gST5Dkppq/claude-code-on-amazon-bedrock-quick-setup-guide?lang=en)

## Prerequisites

### Required

- AWS Account with Amazon Bedrock access
- Enabled Claude models:
  - Claude 3.7 Sonnet
  - Claude 3.5 Haiku
- Node.js 18+

### Optional

- git 2.23+ (for repository workflows)
- GitHub or GitLab CLI (for PR workflows)
- ripgrep (for enhanced file search)

## Setup Instructions

1. Install Claude Code:

   ```bash
   npm install -g @anthropic-ai/claude-code
   ```

2. Configure environment variables:

   ```bash
   # Use Bedrock instead of Anthropic API
   export CLAUDE_CODE_USE_BEDROCK=1

   # Specify model version (Sonnet recommended)
   export ANTHROPIC_MODEL='us.anthropic.claude-3-7-sonnet-20250219-v1:0'

   # Optional: Disable prompt caching for development
   export DISABLE_PROMPT_CACHING=0
   ```

3. Launch Claude Code:
   ```bash
   claude
   ```

## Quick Start

Source the environment file to set up all variables at once:

```bash
source shell/env
claude
```

