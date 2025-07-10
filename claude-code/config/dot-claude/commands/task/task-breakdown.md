# Task Breakdown

Create a markdown unordered list of subtasks from a description, file, or directory.

## Usage
```
task/breakdown [file/directory/description]
```

## Instructions

**First, read the shared configuration**: [Task Commands Configuration](./_config.md)

When the user runs this command:

1. **Analyze the input** from ARGUMENTS:
   - If a file path: read and analyze the file content
   - If a directory: explore structure and identify key components
   - If a description: break down the described work

2. **Create a hierarchical task breakdown**:
   - Generate 5-15 specific, actionable subtasks
   - Use markdown unordered list format (one item per line)
   - Start with high-level tasks, then add sub-items where needed
   - Each task should be:
     - Specific and actionable
     - Estimatable in scope (2-8 hours ideal)
     - Testable/verifiable when complete

3. **Format as clean markdown**:
   ```markdown
   - Main task category
     - Specific subtask
     - Another specific subtask
   - Another main category
     - Subtask with clear deliverable
   ```

4. **Include task metadata**:
   - Priority indicators (🔴 High, 🟡 Medium, 🟢 Low)
   - Dependencies between tasks
   - Estimated effort where helpful

## Parameters

{{#if ARGUMENTS}}
- **ARGUMENTS**: {{ARGUMENTS}}
{{/if}}

## Examples

```
task/breakdown "Build user authentication system"
task/breakdown ./src/components/UserDashboard.js
task/breakdown ./docs/requirements.md
```

## Notes

- Focus on actionable tasks rather than abstract concepts
- Break large tasks into smaller, manageable pieces
- Consider both implementation and validation tasks
- Include setup, development, testing, and documentation tasks
- Order tasks by logical dependencies when possible