# Task Commands

A collection of commands for task management, planning, and breakdown.

## Available Commands

### [`/task/breakdown`](./breakdown.md)
Create a markdown unordered list of subtasks from a description, file, or directory.
- Generates 5-15 specific, actionable subtasks
- Uses hierarchical markdown list format
- Includes priority indicators and dependencies

### [`/task/plan`](./plan.md)
Create a structured implementation plan with phases, timelines, and dependencies.
- Breaks work into 3-5 logical phases
- Includes timeline estimates and milestones
- Maps dependencies and critical path

## Usage Examples

```bash
# Break down a feature into subtasks
/task/breakdown "Build user authentication system"

# Create implementation plan from requirements
/task/plan ./docs/requirements.md

# Plan work for a specific component
/task/plan ./src/components/UserDashboard.js
```

## Future Commands (Suggested)

### `/task/estimate`
Time/effort estimation for tasks and projects.
- Analyze task complexity and provide time estimates
- Consider team capacity and skill requirements
- Use historical data patterns for accuracy
- Generate confidence intervals for estimates

### `/task/dependencies`
Map task dependencies and identify critical path.
- Visualize task relationships and blockers
- Identify critical path through project
- Suggest parallelization opportunities
- Generate dependency graphs (mermaid format)

### `/task/template`
Generate task templates for common development patterns.
- Predefined templates for features, bugs, refactoring
- Customizable checklists for different work types
- Include standard validation and testing tasks
- Support for different project methodologies

### `/task/track`
Track progress and update task status.
- Monitor task completion and blockers
- Generate progress reports and metrics
- Update project timelines based on actuals
- Identify scope creep and plan adjustments

### `/task/review`
Review completed tasks and extract learnings.
- Analyze what went well and what could improve
- Extract patterns for future estimation
- Document lessons learned and best practices
- Generate retrospective insights

## Command Conventions

All task commands follow these patterns:

- **Input flexibility**: Accept file paths, directories, or text descriptions
- **Markdown output**: Generate clean, readable markdown formats
- **Actionable results**: Focus on specific, testable deliverables
- **Metadata inclusion**: Add priorities, estimates, and dependencies where relevant
- **Hierarchical structure**: Use nested lists and clear organization

## Related Commands

- `/spec` - Create comprehensive project specifications
- `/review-task` - Code and task review workflows
- `/commit` - Git commit with task tracking integration
