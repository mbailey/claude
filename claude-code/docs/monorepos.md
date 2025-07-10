# Using Claude with Monorepos

Claude can handle large monorepos, but there are tradeoffs:

Opening at the root:

- Pros: Access to all packages, better cross-package modifications
- Cons: More context to process, potentially slower responses, higher costs

Opening in a subdirectory:

- Pros: Focused context, faster responses, lower costs
- Cons: Limited access to other packages

Opening in the monorepo root is reasonable if you regularly need to work across
packages. For occasional cross-package edits, you might just relaunch Claude in
the root when needed.
