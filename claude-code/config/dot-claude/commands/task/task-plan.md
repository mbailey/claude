# Task Plan

Create a structured implementation plan with phases, timelines, and dependencies.

## Usage
```
task/plan [description/file/directory]
```

## Instructions

**First, read the shared configuration**: [Task Commands Configuration](./_config.md)

When the user runs this command:

1. **Analyze the scope** from ARGUMENTS:
   - Parse the project description, file content, or directory structure
   - Identify major components and deliverables
   - Assess complexity and interdependencies

2. **Create a phased implementation plan**:
   - **Phase breakdown**: 3-5 logical implementation phases
   - **Timeline estimates**: Rough effort estimates per phase
   - **Dependencies**: Clear prerequisite relationships
   - **Milestones**: Concrete deliverables and checkpoints
   - **Risk mitigation**: Identify and plan for potential blockers

3. **Format as structured markdown**:
   ```markdown
   # Implementation Plan: [Project Name]
   
   ## Phase 1: Foundation (Week 1-2)
   - [ ] Core infrastructure setup
   - [ ] Basic data models
   - **Deliverable**: Working skeleton with tests
   
   ## Phase 2: Core Features (Week 3-4) 
   - [ ] Main functionality implementation
   - [ ] API endpoints
   - **Dependencies**: Phase 1 complete
   - **Deliverable**: MVP with core features
   ```

4. **Include planning metadata**:
   - Overall timeline estimate
   - Resource requirements
   - Critical path identification
   - Success criteria for each phase

## Parameters

{{#if ARGUMENTS}}
- **ARGUMENTS**: {{ARGUMENTS}}
{{/if}}

## Examples

```
task/plan "E-commerce checkout flow with payment integration"
task/plan ./requirements/user-dashboard-spec.md
task/plan ./src/api/
```

## Notes

- Balance detail with flexibility - plans should guide but not constrain
- Include both development and validation tasks in each phase
- Consider team capacity and skill requirements
- Plan for iterative feedback and refinement
- Include deployment and rollout considerations