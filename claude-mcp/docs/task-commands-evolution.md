# Task Commands Evolution Plan

Migration strategy from Claude commands to MCP server for task management workflows.

## Current Architecture (Phase 1)

### File Structure
```
~/.claude/commands/task/
├── breakdown.md      # Command: Create subtask lists from descriptions
├── plan.md          # Command: Create implementation plans with phases
├── _config.md       # Shared configuration and conventions
└── README.md        # Documentation and future command ideas
```

### Benefits of Current Approach
- **Immediate value** - Works with existing Claude command infrastructure
- **Simple maintenance** - Easy to update and version control
- **Clear documentation** - Configuration co-located with commands
- **Low complexity** - No additional server setup required

## Future Architecture (Phase 2)

### MCP Server Structure
```
task-mcp-server/
├── src/
│   ├── prompts/
│   │   ├── breakdown.md     # Lifted from current breakdown.md
│   │   ├── plan.md          # Lifted from current plan.md
│   │   ├── estimate.md      # Time/effort estimation prompts
│   │   ├── dependencies.md  # Dependency mapping prompts
│   │   └── track.md         # Progress tracking prompts
│   ├── resources/
│   │   ├── config.yaml      # Migrated from _config.md
│   │   ├── templates/
│   │   │   ├── breakdown-template.md
│   │   │   ├── plan-template.md
│   │   │   ├── user-story-template.md
│   │   │   └── retrospective-template.md
│   │   └── examples/
│   │       ├── sample-breakdown.md
│   │       └── sample-plan.md
│   └── tools/
│       ├── file-manager.js      # Create/read task files
│       ├── template-loader.js   # Dynamic template instantiation
│       ├── progress-tracker.js  # Status updates and metrics
│       ├── dependency-graph.js  # Task relationship mapping
│       └── git-integration.js   # Branch/PR/commit integration
└── package.json
```

## Migration Strategy

### Phase 1 → Phase 2 Component Mapping

**Commands → Prompts**:
- `breakdown.md` → `prompts/breakdown.md` (instruction logic)
- `plan.md` → `prompts/plan.md` (planning workflows)
- Future commands → Additional prompt files

**Configuration → Resources**:
- `_config.md` → `resources/config.yaml` (structured configuration)
- Template structures → `resources/templates/` (reusable components)
- Examples → `resources/examples/` (reference materials)

**New Capabilities → Tools**:
- File system operations for `docs/tasks/` structure
- Template instantiation with variable substitution
- Cross-task relationship tracking
- External system integrations

### Migration Benefits

**Enhanced Functionality**:
1. **Stateful operations** - Track task relationships across sessions
2. **Automated file management** - Directory creation, file organization
3. **Template engine** - Dynamic content with variable substitution
4. **Cross-command integration** - Plans reference breakdowns, estimates
5. **External integrations** - Project management tools, git workflows

**Improved User Experience**:
- Reduced manual file management
- Consistent formatting and structure
- Automated progress tracking
- Better discoverability of related tasks

## File Location Standards

### Current (Commands)
All task documents created in:
- **Breakdowns**: `docs/tasks/breakdowns/TASK_NAME.md`
- **Plans**: `docs/tasks/plans/PLAN_NAME.md`
- **Templates**: `docs/tasks/templates/TEMPLATE_NAME.md`

### Future (MCP Server)
Enhanced organization with:
- **Automated directory creation**
- **Template-based file generation**
- **Cross-reference management**
- **Status tracking integration**

## Command Inventory

### Implemented
- `/task/breakdown` - Subtask decomposition
- `/task/plan` - Implementation planning

### Future Commands (→ MCP Prompts)
- `/task/estimate` - Time/effort estimation
- `/task/dependencies` - Critical path analysis
- `/task/template` - Common task patterns
- `/task/track` - Progress monitoring
- `/task/review` - Retrospective analysis

## Implementation Timeline

**Phase 1 (Current)**:
- ✅ Basic command structure
- ✅ Shared configuration
- ✅ Documentation framework
- 🔄 Command refinement based on usage

**Phase 2 (MCP Migration)**:
- 📋 MCP server scaffolding
- 📋 Prompt migration and enhancement
- 📋 Resource organization
- 📋 Tool development
- 📋 Integration testing
- 📋 Documentation update

## Success Metrics

**Phase 1**:
- Commands successfully generate useful task breakdowns
- Configuration reduces repetition across commands
- User adoption and feedback collection

**Phase 2**:
- Reduced manual file management overhead
- Improved task tracking and progress visibility
- Better integration with existing development workflows
- Enhanced template reusability and customization

## Related Documentation

- [Task Commands README](~/.claude/commands/task/README.md)
- [Task Configuration](~/.claude/commands/task/_config.md)
- [Spec Command](~/.claude/commands/spec.md) - Related workflow integration