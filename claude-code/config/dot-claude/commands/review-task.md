# Review ServiceNow Task

You are reviewing ServiceNow ticket(s) provided in $ARGUMENTS. Each ticket is stored as a markdown file in the project directory structure. Process multiple tickets in parallel if provided.

## Usage
```
review-task SCTASK12345
review-task INC12345 CHG67890 SCTASK11111
```

## Ticket Directory Mapping

Map ticket IDs to their corresponding directories in PROJECT_ROOT/tickets/:

- **SCTASK** → `tickets/tasks/`
- **INC** → `tickets/incidents/` 
- **CHG** → `tickets/changes/`
- **RITM** → `tickets/requests/`
- **REQ** → `tickets/requests/`
- **PRB** → `tickets/problems/`
- **KB** → `tickets/knowledge/`
- **CTASK** → `tickets/change-tasks/`
- **STASK** → `tickets/standard-tasks/`

## File Location Logic

For each ticket ID, locate the corresponding markdown file using this priority order:

1. **Check for ticket directory first**: Look for a directory that starts with the ticket ID in the mapped location
   - If found, read the `README.md` file within that directory
   - Example: `tickets/tasks/SCTASK12345/README.md` or `tickets/tasks/SCTASK12345-description/README.md`

2. **Check for direct markdown file**: Look for a file that starts with the ticket ID
   - Example: `tickets/tasks/SCTASK12345.md` or `tickets/tasks/SCTASK12345-description.md`

3. **Conflict detection**: If both a ticket directory and direct file exist for the same ticket ID:
   - **WARN the user** about the conflict
   - Process the ticket directory (README.md) as it takes priority
   - Note the conflict in your review output

## Output File Generation

For each ticket reviewed, create or update a ticket review file:

- **File naming**: Append `_ticket-review` before the file extension of the source file
- **Examples**:
  - `tickets/tasks/SCTASK12345.md` → `tickets/tasks/SCTASK12345_ticket-review.md`
  - `tickets/tasks/SCTASK12345/README.md` → `tickets/tasks/SCTASK12345/README_ticket-review.md`
  - `tickets/incidents/INC67890-description.md` → `tickets/incidents/INC67890-description_ticket-review.md`

## Related Tickets Discovery

Before analyzing each ticket, search for similar tickets to learn from previous work:

1. **Extract key terms** from the ticket title and description (technologies, services, error messages, etc.)
2. **Search for similar tickets** using bash tools:
   - Use `grep` to search ticket content for key terms
   - Use `find` to locate tickets with similar naming patterns
   - Focus search on tickets of the same type first, then expand to related types
3. **Token conservation strategy**:
   - Only read tickets with high-confidence matches (filename contains key terms OR grep shows multiple matches)
   - Prioritize recently modified tickets (they may have current solutions)
   - Limit to top 3-5 most relevant matches
4. **Learn from similar tickets**:
   - Look for resolution patterns, common issues, and successful approaches
   - Note any SOPs or procedures referenced in similar tickets
   - Identify potential gotchas or complications mentioned
5. **Markdown link formatting for related tickets**:
   - **Determine the relative path** from the ticket review file location to the referenced ticket
   - **Use exact filenames** as found in the file system (including full descriptive names)
   - **Format examples**:
     - Same directory: `[SCTASK12345](SCTASK12345-description.md)`
     - Different directory: `[INC67890](../incidents/INC67890-description.md)`
     - Ticket directory: `[CHG12345](../changes/CHG12345-description/README.md)`

## Analysis Instructions

1. **Locate and read** the ticket markdown file(s) using the file location logic above
2. **Search for related tickets** using the discovery process above
3. **Identify the core issue** and categorize the request type
4. **Assess completeness** of information provided
5. **Determine resolution approach** based on available SOPs, best practices, and learnings from similar tickets
6. **Provide actionable recommendations**
7. **Create or update** the corresponding ticket review file with your analysis
8. **Process multiple tickets concurrently** if multiple ticket IDs are provided

## Review Output Format

### Summary
- **Ticket Type**: [SCTASK/INC/CHG/etc.]
- **Category**: [AWS/Azure/Network/Security/etc.]
- **Priority Assessment**: [Critical/High/Medium/Low with justification]
- **Estimated Effort**: [Simple/Medium/Complex with time estimate]

### Related Tickets
- **Similar Tickets Found**: List with proper markdown links and brief descriptions
  - Use format: `[TICKET_ID](relative/path/to/exact-filename.md): Brief description`
  - Ensure relative paths are correct from the ticket review file location
  - Use exact filenames as found in the file system
- **Key Learnings**: Insights from previous similar tickets
- **Successful Approaches**: What worked in similar cases
- **Common Pitfalls**: Issues to avoid based on historical tickets

### Analysis
- **Current Status**: Brief assessment of ticket state
- **Key Requirements**: Bullet points of what needs to be delivered
- **Dependencies**: Any blockers or prerequisites identified
- **Risk Assessment**: Potential issues or complications

### Notes
- **Concise description of problem**: [1-2 sentence summary of the core issue]
- **Proposed way to resolve the ticket**: [Step-by-step approach or reference to standard process]
- **Relevant SOP**: [Link to applicable documentation from ../docs/sops/]

### Recommendations
- **Immediate Actions**: What should be done first
- **Additional Information Needed**: Any clarifications required from requestor
- **Alternative Approaches**: Other ways to solve the problem if applicable
- **Follow-up Items**: Post-resolution tasks or monitoring needed

### Quality Checks
- [ ] All required information present
- [ ] Solution approach is clearly defined
- [ ] Appropriate SOP referenced
- [ ] Risks and dependencies identified
- [ ] Success criteria established

## Available SOPs Reference

Key SOPs available in ../docs/sops/:
- AWS account management: `../docs/sops/aws/account/`
- Azure subscription process: `../docs/sops/azure-subscription-creation-process/`
- Certificate management: `../docs/sops/certs/`
- DNS operations: `../docs/sops/aws/route53/` and `../docs/sops/azure/private-dns/`
- ServiceNow processes: `../docs/sops/snow/`

When referencing SOPs, use markdown links in the format: `[SOP Name](../docs/sops/path/to/file.md)`