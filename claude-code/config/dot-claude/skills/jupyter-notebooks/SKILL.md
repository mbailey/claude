---
name: jupyter-notebooks
description: Create, review, and organize Jupyter notebook projects with UV-based workflows. Use when creating new notebooks, reviewing existing notebooks, organizing notebook projects, or improving presentation quality. Covers file structure, token-efficient notebook handling, presentation patterns, and CLI/library integration.
---

# Jupyter Notebooks

## Overview

This skill provides guidance for working with Jupyter notebook projects that follow professional development practices:
- **Clean file structure** with notebooks as interfaces to reusable scripts and libraries
- **Token-efficient workflows** for AI assistants reading and modifying notebooks
- **Presentation-ready patterns** for demos, team sharing, and documentation
- **UV-based Python management** with portable, reproducible environments

## When to Use This Skill

Use this skill when:
- Creating a new Jupyter notebook or notebook-based project
- Reviewing or editing existing notebooks
- Organizing a notebook project's file structure
- Preparing notebooks for presentation or sharing
- Improving notebook maintainability

## Core Philosophy

**Notebooks are interfaces, not libraries.**

Notebooks provide an interactive interface for exploration and presentation, but executable logic should live in:
- `scripts/` - CLI scripts that can run without Jupyter
- `lib/` - Reusable Python modules imported by notebooks and scripts

This enables:
- Code reuse across multiple notebooks
- Testing without running notebooks
- Automation in CI/CD pipelines
- Better version control

## Quick Start

### Creating a New Notebook Project

1. **Initialize with UV** (standard Python tool)
   ```bash
   # Create project directory
   mkdir alarm-analysis && cd alarm-analysis

   # Initialize UV project
   uv init

   # Add dependencies
   uv add jupyter pandas plotly
   ```

2. **Set up directory structure**
   ```bash
   mkdir -p scripts lib data/{raw,processed} reports docs .archive
   touch data/.gitkeep reports/.gitkeep
   ```

3. **Create .gitignore**
   ```gitignore
   # Virtual environments
   .venv/

   # Data and outputs (keep .gitkeep)
   data/**
   !data/.gitkeep
   reports/**
   !reports/.gitkeep

   # Jupyter
   .ipynb_checkpoints/

   # Python
   __pycache__/
   *.pyc

   # Environment
   .env

   # UV
   uv.lock
   ```

4. **Start Jupyter**
   ```bash
   uv run jupyter notebook
   ```

5. **Refer to references for detailed patterns:**
   - See `references/file-structure.md` for complete directory organization
   - See `references/presentation-patterns.md` for notebook structure and styling
   - See `references/token-efficiency.md` for AI-friendly notebook practices

### Reviewing an Existing Notebook

**Token-efficient review workflow:**

1. **Check structure without reading outputs**
   ```bash
   # See cell types and counts
   jq '.cells | group_by(.cell_type) | map({type: .[0].cell_type, count: length})' notebook.ipynb

   # Check if outputs are present
   jq '.cells | map(select(.outputs | length > 0)) | length' notebook.ipynb
   ```

2. **Compare code changes only**
   ```bash
   # Extract code cells to compare
   jq '.cells[] | select(.cell_type == "code") | .source' notebook1.ipynb > /tmp/code1.json
   jq '.cells[] | select(.cell_type == "code") | .source' notebook2.ipynb > /tmp/code2.json
   diff /tmp/code1.json /tmp/code2.json
   ```

3. **Read notebook if needed**
   - Use Read tool only after confirming what needs to be read
   - For large notebooks, read specific cell ranges
   - See `references/token-efficiency.md` for detailed techniques

### Organizing a Notebook Project

Follow the structure pattern from `references/file-structure.md`:

**Root directory (visible, essential files only):**
- Active notebooks (*.ipynb)
- README.md
- pyproject.toml
- .env.example
- Makefile (optional)

**Subdirectories (organized by purpose):**
- `scripts/` - Executable CLI scripts
- `lib/` - Reusable Python modules
- `data/` - Data files (gitignored)
- `reports/` - Generated outputs (gitignored)
- `docs/` - Additional documentation
- `.archive/` - Deprecated notebooks

**Migration steps:**
1. Audit root directory: `ls -1 | wc -l`
2. Move scripts to `scripts/`, docs to `docs/`, old notebooks to `.archive/`
3. Update imports in notebooks: `from lib import module_name`
4. Test everything still works

## UV-Based Workflow

### Why UV?

UV is the standard Python tool for:
- Fast, reproducible dependency management
- Single-file script execution without installation
- Tool installation without polluting global Python
- Cross-platform compatibility

### Common UV Patterns

**Run script without installing:**
```bash
uvx notebook-runner notebook.ipynb
```

**Add dependency:**
```bash
uv add plotly pandas duckdb
```

**Install tool globally:**
```bash
uv tool install jupyterlab
```

**Run notebook with dependencies:**
```bash
uv run jupyter notebook
```

**Single-file script with dependencies:**
```python
# /// script
# requires-python = ">=3.11"
# dependencies = [
#     "pandas",
#     "plotly",
# ]
# ///

import pandas as pd
import plotly.express as px

# Script code here
```

Run with: `uv run script.py`

## Token-Efficient Workflows

When working with notebooks through AI assistants:

### Default: Strip Outputs

**Use pre-commit hooks:**
```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/kynan/nbstripout
    rev: 0.6.1
    hooks:
      - id: nbstripout
```

**When outputs are needed:**
```bash
SKIP=jupyter git commit -m "Add notebook with visualization outputs"
```

### Query Before Reading

**Check structure first:**
```bash
jq '.cells | group_by(.cell_type) | map({type: .[0].cell_type, count: length})' notebook.ipynb
```

**Read code only:**
```bash
jq '.cells[] | select(.cell_type == "code") | .source' notebook.ipynb
```

### Efficient Cell Outputs

**Write summaries, not raw data:**
```python
# Instead of: df_alarms  (displays entire dataframe)

# Do this: (summary only)
print(f"✅ Loaded {len(df_alarms):,} alarms")
print(f"Columns: {', '.join(df_alarms.columns)}")
print(f"Date range: {df_alarms['timestamp'].min()} to {df_alarms['timestamp'].max()}")
```

**Save outputs to files:**
```python
# Instead of: fig.show()  (large base64 in output)

# Do this: (save to file, show confirmation)
fig.write_html(report_dir / "visualization.html")
print(f"✅ Saved visualization to {report_dir}/visualization.html")
```

See `references/token-efficiency.md` for complete guidance.

## Presentation Patterns

### Notebook Structure for Demos

1. **Title and overview** - Context and purpose
2. **Setup** - Imports and configuration
3. **Data loading** - With feedback and error handling
4. **Summary** - High-level statistics
5. **Visualizations** - With descriptions and usage tips
6. **Conclusions** - Key findings

### Professional Output

**Use visual feedback:**
```python
print("✅ Success")
print("⚠️  Warning")
print("❌ Error")
print("📊 Summary")
print("💡 Tip")
print("ℹ️  Note")
```

**Format numbers:**
```python
print(f"Total: {count:,}")  # 2,055 instead of 2055
```

**Save with dates:**
```python
from datetime import datetime

today = datetime.now().strftime('%Y-%m-%d')
report_dir = Path("reports") / today
report_dir.mkdir(parents=True, exist_ok=True)

fig.write_html(report_dir / "chart.html")

# Create 'latest' symlink
latest = Path("reports/latest")
if latest.exists():
    latest.unlink()
latest.symlink_to(today, target_is_directory=True)
```

See `references/presentation-patterns.md` for complete patterns and templates.

## Resources

### references/file-structure.md
Detailed guidance on:
- Recommended directory structure
- File organization rules
- Git integration patterns
- Migration guides for existing projects
- Example project structures

**Load when:** Creating new projects, reorganizing existing projects, or establishing file conventions.

### references/token-efficiency.md
Comprehensive techniques for:
- Strategic output stripping
- Querying notebooks without reading outputs
- Structured reading patterns
- jq patterns for notebook analysis
- Output management in cells

**Load when:** Working with notebooks through AI assistants, optimizing context usage, or implementing efficient workflows.

### references/presentation-patterns.md
Patterns for professional notebooks:
- Notebook structure for presentations
- Visual design patterns
- Interactive elements
- Error handling
- Code vs markdown cells
- Professional styling

**Load when:** Preparing notebooks for demos, team sharing, or documentation.

## Best Practices Summary

1. **Structure**: Notebooks at root, logic in `scripts/` and `lib/`
2. **Dependencies**: Use UV for reproducible Python environments
3. **Version control**: Strip outputs by default, use pre-commit hooks
4. **Token efficiency**: Query structure before reading, save outputs to files
5. **Presentation**: Add context, use visual feedback, handle errors gracefully
6. **Reproducibility**: Ensure "Restart & Run All" works
7. **Data flow**: raw → processed → reports
8. **Git friendly**: Ignore data/reports, keep structure via .gitkeep

## Example Workflow

```bash
# 1. Create project
mkdir my-analysis && cd my-analysis
uv init
uv add jupyter pandas plotly

# 2. Set up structure
mkdir -p scripts lib data/{raw,processed} reports
touch data/.gitkeep reports/.gitkeep

# 3. Create notebook
uv run jupyter notebook

# 4. As you work:
# - Keep logic in lib/ and scripts/
# - Save outputs to reports/ with dates
# - Use visual feedback (✅, ⚠️, 💡)
# - Strip outputs before committing

# 5. Before presenting:
# - Run "Restart & Run All" to test
# - Add context and documentation
# - Consider exporting to HTML
jupyter nbconvert --to html --execute notebook.ipynb
```

## Quick Reference

**File organization:**
- Notebooks: project root
- Scripts: `scripts/`
- Libraries: `lib/`
- Data: `data/raw/`, `data/processed/`
- Reports: `reports/YYYY-MM-DD/`
- Archive: `.archive/`

**UV commands:**
- `uv init` - Initialize project
- `uv add <package>` - Add dependency
- `uv run <command>` - Run with dependencies
- `uvx <tool>` - Run tool without installing

**Token efficiency:**
- Strip outputs: pre-commit hook or `nbconvert --clear-output`
- Query structure: `jq '.cells | group_by(.cell_type)'`
- Compare code: `jq '.cells[] | select(.cell_type == "code") | .source'`

**Presentation:**
- Emojis: ✅ ⚠️ ❌ 📊 💡 ℹ️
- Format numbers: `{count:,}`
- Save with dates: `reports/YYYY-MM-DD/`
- Test: `jupyter nbconvert --execute`
