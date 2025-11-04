# Jupyter Notebook Project File Structure

This document describes the recommended file structure for projects that use Jupyter notebooks for analysis, research, and operational workflows.

## Core Principles

1. **Notebooks are interfaces, not libraries** - Keep executable logic in scripts and libraries
2. **Clean root directory** - Minimize files at the project root
3. **Clear data flow** - Separate raw data, processed data, and outputs
4. **Version control friendly** - Structured to work well with git

## Recommended Structure

```
project-root/
├── README.md              # Project overview and quick start
├── pyproject.toml         # UV-based Python dependencies
├── .python-version        # Python version (for UV)
├── .env.example           # Example environment variables
├── .gitignore            # Git ignore patterns
│
├── *.ipynb               # Notebooks at root for visibility
│
├── scripts/              # Executable CLI scripts
│   ├── extract.sh        # Data extraction
│   ├── process.sh        # Data processing
│   └── generate-report.py # Report generation
│
├── lib/                  # Reusable Python modules
│   ├── __init__.py
│   ├── data_processing.py
│   └── visualization.py
│
├── data/                 # Data directory (gitignored except .gitkeep)
│   ├── raw/             # Original, immutable data
│   ├── processed/       # Cleaned, transformed data
│   └── .gitkeep
│
├── reports/             # Generated outputs (gitignored except .gitkeep)
│   ├── latest/          # Symlink to most recent report
│   ├── 2025-10-27/      # Dated report directories
│   └── .gitkeep
│
├── docs/                # Additional documentation
│   ├── schemas.md       # Data schemas
│   └── setup.md         # Setup instructions
│
└── .archive/            # Deprecated notebooks and code
    └── old-notebook.ipynb
```

## File Organization Rules

### Root Directory

**Keep at root (high visibility):**
- Active Jupyter notebooks (*.ipynb)
- README.md
- Configuration files (pyproject.toml, .env.example)
- Makefile (if used)

**Move to subdirectories:**
- Executable scripts → `scripts/`
- Python libraries → `lib/`
- Documentation → `docs/`
- Deprecated files → `.archive/`

### Notebooks

**Naming conventions:**
- Use descriptive, hyphenated names: `alarm-day-hour-pattern.ipynb`
- Include workflow purpose: `data-extraction.ipynb`, `visualization-report.ipynb`
- Date-stamped variants for significant versions: `analysis-2025-10-27.ipynb`

**Location:**
- Keep at project root for maximum visibility
- Move outdated notebooks to `.archive/` rather than deleting

### Scripts Directory

**Purpose:** Executable code that can run without Jupyter

**Contents:**
- Shell scripts for data processing (`process-logs.sh`)
- Python CLI scripts (`generate-report.py`)
- Helper scripts for common tasks
- All scripts should be executable: `chmod +x scripts/*`

**Benefits:**
- Notebooks can shell out to scripts: `!./scripts/process.sh`
- Scripts can be run independently for automation
- Code reusability across notebooks and CI/CD

### Lib Directory

**Purpose:** Reusable Python modules imported by notebooks and scripts

**Contents:**
- Data processing functions
- Visualization helpers
- Database connection utilities
- Business logic

**Pattern:**
```python
# In notebook
from lib.data_processing import clean_alarm_data
from lib.db_credentials import get_connection

df = clean_alarm_data(raw_df)
conn = get_connection()
```

### Data Directory

**Structure:**
```
data/
├── raw/              # Original data (never modified)
│   └── logs/
├── processed/        # Cleaned, transformed data
│   └── alarms_*.csv.gz
└── .gitkeep         # Keep directory in git
```

**Rules:**
- Add `data/` to .gitignore (except .gitkeep)
- Never modify files in `raw/`
- **Always compress processed data** - Use .csv.gz (pandas handles automatically), .parquet, or similar
- Use dated filenames: `alarms_2025-10-27.csv.gz`
- Compression saves space and git handles compressed files well

**Compression example:**
```python
# Pandas reads and writes gzipped files automatically
df.to_csv("data/processed/alarms_2025-10-27.csv.gz", compression='gzip', index=False)
df = pd.read_csv("data/processed/alarms_2025-10-27.csv.gz", compression='gzip')
```

### Reports Directory

**Structure:**
```
reports/
├── .gitkeep
├── latest/          # Symlink to most recent
├── 2025-10-27/      # Dated directories
│   ├── alarm_events_by_time.html
│   └── routing_summary.html
└── 2025-10-26/
```

**Pattern:**
```python
from datetime import datetime
from pathlib import Path

today = datetime.now().strftime('%Y-%m-%d')
report_dir = Path("reports") / today
report_dir.mkdir(parents=True, exist_ok=True)

# Create latest symlink
latest_link = Path("reports/latest")
if latest_link.exists():
    latest_link.unlink()
latest_link.symlink_to(today, target_is_directory=True)
```

## Example Projects

### S3 Lock Extender
```
s3-lock-extender/
├── README.md
├── pyproject.toml
├── S3-Lock-Extension-Workflow.ipynb  # Main notebook
├── scripts/
│   ├── download-latest-inventory.sh
│   ├── generate-manifests.sh
│   └── create-batch-job.sh
├── docs/
│   └── setup-al2023.md
└── data/              # gitignored
```

### Alarm Analysis (Current Project - To Be Improved)
```
alarm-analysis/
├── README.md
├── pyproject.toml
├── alarm-etl.ipynb               # Data extraction
├── alarm-postgres-analysis.ipynb # Database queries
├── alarm-day-hour-pattern.ipynb  # Visualization
├── generate-reports.ipynb        # Report generation
├── scripts/
│   ├── extract
│   ├── process
│   └── analyze
├── lib/
│   └── db_credentials.py
├── data/
│   ├── raw/
│   └── processed/
└── reports/
```

## Git Integration

### .gitignore Pattern
```gitignore
# Virtual environments
.venv/
venv/

# Data and outputs (keep .gitkeep)
data/**
!data/.gitkeep
!data/raw/.gitkeep
!data/processed/.gitkeep
reports/**
!reports/.gitkeep

# Jupyter
.ipynb_checkpoints/

# Python
__pycache__/
*.pyc
*.pyo

# Environment
.env

# UV
uv.lock
```

### Pre-commit Hooks

Use pre-commit hooks to:
- Strip notebook outputs (unless explicitly needed)
- Clean notebook metadata
- Run code formatters

**Skip hooks when outputs are needed:**
```bash
SKIP=jupyter git commit -m "Add notebook with outputs"
```

## Migration Guide

When reorganizing an existing project:

1. **Audit root directory**
   ```bash
   ls -1 | wc -l  # Count files at root
   ```

2. **Move files to appropriate directories**
   - Scripts → `scripts/`
   - Docs → `docs/`
   - Old notebooks → `.archive/`

3. **Update imports in notebooks**
   ```python
   # Before
   import alarm_analysis

   # After
   from lib import alarm_analysis
   ```

4. **Update script paths**
   ```python
   # In notebook
   !./scripts/process.sh  # Not ./process.sh
   ```

5. **Test everything still works**
   ```bash
   # Run notebooks
   jupyter nbconvert --execute *.ipynb --to notebook

   # Run scripts
   ./scripts/process.sh
   ```

## Benefits

- **Clarity**: Easy to find notebooks and understand project structure
- **Maintainability**: Reusable code in lib/ and scripts/
- **Collaboration**: Clear conventions for team members
- **Automation**: Scripts can run in CI/CD without Jupyter
- **Token efficiency**: Organized structure makes it easier for AI to navigate
