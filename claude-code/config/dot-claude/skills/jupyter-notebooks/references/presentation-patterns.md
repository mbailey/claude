# Notebook Presentation Patterns

This document describes patterns for creating presentation-ready Jupyter notebooks for demos, team sharing, and documentation.

## Core Principles

1. **Tell a story** - Guide the reader through a narrative
2. **Show, don't dump** - Display insights, not raw data
3. **Make it reproducible** - Anyone should be able to run it
4. **Keep it evergreen** - Use patterns that stay relevant

## Notebook Structure for Presentations

### Title and Overview

**Pattern:**
```markdown
# Alarm Day/Hour Pattern Analysis

This notebook analyzes alarm events by day and hour to identify:
- Temporal patterns in alarm frequency
- High-frequency alarms requiring attention
- Routing patterns to different destinations

**Data source**: Digital Alarm Router logs (2025-10-13 to 2025-10-24)
**Updated**: 2025-10-27
```

**Why:**
- Immediate context for anyone opening the notebook
- Sets expectations for what they'll see
- Shows data freshness

### Configuration and Setup

**Pattern:**
```python
# Setup
import pandas as pd
import plotly.graph_objects as go
from pathlib import Path
from datetime import datetime

# Directories
DATA_DIR = Path.cwd() / "data"
REPORTS_DIR = Path.cwd() / "reports"

print("✅ Setup complete")
```

**Why:**
- All configuration in one place
- Easy to modify for different environments
- Confirmation that imports worked

### Data Loading with Feedback

**Bad (silent loading):**
```python
df_alarms = pd.read_csv("alarms.csv.gz")
```

**Good (informative loading):**
```python
# Load processed alarm data
alarms_files = sorted(glob.glob(str(DATA_DIR / "processed" / "alarms_*.csv.gz")))

if not alarms_files:
    print(f"⚠️  No processed data found in {DATA_DIR / 'processed'}")
    print(f"\nRun: make process")
else:
    dfs = [pd.read_csv(f, compression='gzip') for f in alarms_files]
    df_alarms = pd.concat(dfs, ignore_index=True)
    df_alarms['timestamp'] = pd.to_datetime(df_alarms['timestamp'])

    print(f"✅ Loaded {len(alarms_files)} daily files with {len(df_alarms):,} total alarms")
    print(f"Date range: {df_alarms['timestamp'].min()} to {df_alarms['timestamp'].max()}")
    print(f"Unique alarms: {df_alarms['alarm_name'].nunique()}")
```

**Why:**
- Shows what data was loaded
- Provides debugging context
- Confirms data quality/completeness
- Actionable error message if data missing

### Data Summary Sections

**Pattern:**
```python
# Data Summary
if "df_alarms" in locals():
    print(f"📊 Data Summary")
    print(f"═" * 60)
    print(f"Total alarm events: {len(df_alarms):,}")
    print(f"Unique alarms: {df_alarms['alarm_name'].nunique()}")
    print(f"Date range: {df_alarms['timestamp'].min().date()} to {df_alarms['timestamp'].max().date()}")
    print(f"Days covered: {(df_alarms['timestamp'].max() - df_alarms['timestamp'].min()).days + 1}")
```

**Why:**
- Quick validation of data loaded correctly
- Context for interpreting visualizations
- Professional formatting with emojis and separators

### Visualizations with Descriptions

**Pattern:**
```markdown
## Alarm Events by Day and Hour

This visualization shows when alarms occur throughout the week:
- **Circle markers**: ALARM state
- **X markers**: OK state
- **Diamond markers**: INSUFFICIENT_DATA state

Use the dropdown menu to filter by alarm state.
```

```python
# Create visualization
fig = go.Figure()
# ... visualization code ...

# Save and display
html_path = REPORTS_DIR / today / "alarm_events_by_time.html"
fig.write_html(html_path)

print(f"✅ Saved interactive chart to: {html_path}")
print(f"\n💡 Tips:")
print(f"   - Use dropdown menu to filter by alarm state")
print(f"   - Double-click legend item to isolate that alarm")
print(f"   - Hover for details")

fig.show()
```

**Why:**
- Markdown explains what to look for
- Code saves output to file (persistence)
- Print statement confirms save and provides usage tips
- Interactive visualization shown inline

### Progressive Disclosure

Organize content from high-level to detailed:

1. **Executive summary** - Key findings in markdown
2. **Overview visualizations** - Broad patterns
3. **Detailed analysis** - Drill-down views
4. **Technical details** - Data processing code

**Example structure:**
```
1. Title and Overview
2. Key Findings (markdown summary)
3. Setup and Data Loading
4. High-Level Visualization (alarm patterns)
5. Detailed Analysis (specific alarms)
6. Routing Analysis (where alarms went)
7. Technical Notes (data processing details)
```

## Visual Design Patterns

### Use Emojis for Scanability

```python
print("✅ Data loaded successfully")
print("⚠️  Warning: Missing data for 2025-10-15")
print("❌ Error: Could not connect to database")
print("📊 Summary statistics")
print("💡 Tip: Use dropdown to filter")
print("ℹ️  Note: Data refreshed daily")
```

**Why:**
- Instant visual categorization
- More engaging than plain text
- Easy to scan when re-running cells

### Numbered Formatting for Large Numbers

```python
# Bad
print(f"Total alarms: {total_alarms}")  # Output: Total alarms: 2055

# Good
print(f"Total alarms: {total_alarms:,}")  # Output: Total alarms: 2,055
```

### Visual Separators

```python
print(f"📊 Data Summary")
print(f"═" * 60)  # Double line
print(f"Total alarms: {count:,}")
print(f"─" * 60)  # Single line
```

## Interactive Elements

### Dropdown Menus for Filtering

```python
# Create visibility configurations
def make_visibility(states_to_show):
    return [trace.legendgroup in states_to_show for trace in fig.data]

fig.update_layout(
    updatemenus=[
        dict(
            buttons=[
                dict(label="All States",
                     method="update",
                     args=[{"visible": make_visibility(['ALARM', 'OK', 'INSUFFICIENT_DATA'])}]),
                dict(label="ALARM Only",
                     method="update",
                     args=[{"visible": make_visibility(['ALARM'])}]),
            ],
            direction="down",
            showactive=True,
            x=0.01,
            y=1.08
        )
    ]
)
```

### Legend Interactivity

```python
fig.update_layout(
    legend=dict(
        title="Click to filter",
        groupclick="toggleitem"  # Click group to toggle all in group
    )
)
```

## Output Management for Presentations

### Save Outputs to Dated Directories

```python
from datetime import datetime

today = datetime.now().strftime('%Y-%m-%d')
report_dir = REPORTS_DIR / today
report_dir.mkdir(parents=True, exist_ok=True)

# Save visualization
fig.write_html(report_dir / "alarm_pattern.html")

# Create/update 'latest' symlink
latest_link = REPORTS_DIR / "latest"
if latest_link.is_symlink() or latest_link.exists():
    latest_link.unlink()
latest_link.symlink_to(today, target_is_directory=True)

print(f"✅ Saved report to: {report_dir}")
print(f"💡 View latest: reports/latest/alarm_pattern.html")
```

**Why:**
- Historical reports preserved
- Always know where latest is
- Can compare across days

### Export Notebook as HTML

For sharing with non-technical stakeholders:

```bash
# Export with outputs
jupyter nbconvert --to html --execute notebook.ipynb

# Or via Makefile
make export-notebook
```

Add to Makefile:
```makefile
export-notebook:
    jupyter nbconvert --to html --execute *.ipynb --output-dir=reports/latest/
```

## Code Cells vs Markdown Cells

### When to Use Markdown

- **Section headers**: `## Data Loading`
- **Explanations**: What the next analysis does
- **Key findings**: Summarize insights
- **Instructions**: How to use the notebook
- **Documentation**: Data schemas, assumptions

### When to Use Code Comments

- **Code clarification**: `# Filter to last 30 days`
- **TODO items**: `# TODO: Add error handling`
- **Inline documentation**: Parameter descriptions

**Balance:**
- Markdown: Tell the story (why)
- Code comments: Explain implementation (how)

## Cells for Easy Demo Flow

### One Concept Per Cell

**Bad (too much in one cell):**
```python
# Load data, process it, visualize it, save output all in one cell
```

**Good (separate concerns):**
```python
# Cell 1: Load data
# Cell 2: Process data
# Cell 3: Create visualization
# Cell 4: Save and display
```

**Why:**
- Can re-run individual steps
- Easier to debug
- Better for presentations (step through)

### Cell Execution Order

**Use "Restart & Run All" test:**
```bash
jupyter nbconvert --execute --to notebook --inplace notebook.ipynb
```

**Ensure:**
- Cells run in order
- No out-of-order dependencies
- Each cell is idempotent (can re-run safely)

## Error Handling for Presentation

### Graceful Failure Messages

**Bad:**
```python
df = pd.read_csv("data.csv")  # Crashes with ugly traceback
```

**Good:**
```python
try:
    df = pd.read_csv(DATA_DIR / "data.csv")
    print(f"✅ Loaded {len(df):,} records")
except FileNotFoundError:
    print(f"❌ Error: Data file not found")
    print(f"\nPlease run data extraction first:")
    print(f"  make extract")
    print(f"\nOr run the data-extraction.ipynb notebook")
    df = None
```

### Dependency Checks

```python
# Check required data exists before proceeding
if 'df_alarms' not in locals():
    print("⚠️  Alarm data not loaded. Please run the previous cell first.")
else:
    # Continue with analysis
    print(f"📊 Analyzing {len(df_alarms):,} alarm events...")
```

## Styling for Professional Output

### Plotly Chart Defaults

```python
# Professional theme
fig.update_layout(
    title=dict(
        text='Alarm Events by Day and Hour',
        x=0.5,
        xanchor='center',
        font=dict(size=20)
    ),
    xaxis_title='Date (Day of Week)',
    yaxis_title='Hour of Day (0-24)',
    height=700,
    hovermode='closest',
    showlegend=True,
    legend=dict(
        title="Alarm Name (count)",
        yanchor="top",
        y=0.99,
        xanchor="left",
        x=1.02
    ),
    font=dict(family="Arial, sans-serif", size=12),
    plot_bgcolor='white',
    paper_bgcolor='white'
)
```

### Color Schemes

```python
# Use qualitative palettes for categorical data
colors = px.colors.qualitative.Plotly + px.colors.qualitative.Set2

# Semantic colors for states
state_colors = {
    'ALARM': '#FF6B6B',      # Red
    'OK': '#51CF66',          # Green
    'INSUFFICIENT_DATA': '#FFA500'  # Orange
}
```

## Notebook Metadata

### Add Context in First Cell

```python
"""
Alarm Day/Hour Pattern Analysis
================================

Author: Mike Bailey
Created: 2025-10-13
Updated: 2025-10-27

Purpose:
- Analyze alarm frequency patterns by day and hour
- Identify high-frequency alarms
- Visualize routing to different destinations

Data Source:
- Digital Alarm Router CloudWatch logs
- Processed via alarm-etl.ipynb
- Date range: 2025-10-13 to 2025-10-24

Dependencies:
- pandas
- plotly
- Processed alarm data in data/processed/

To run:
1. Ensure data is processed (make process)
2. Run cells in order
3. View outputs in reports/latest/
"""
```

## Presentation Checklist

Before sharing a notebook:

- [ ] Clear title and purpose in first markdown cell
- [ ] All cells run in order (Restart & Run All)
- [ ] Data loading includes feedback and error handling
- [ ] Visualizations have clear titles and labels
- [ ] Key findings summarized in markdown
- [ ] Outputs saved to files (not just displayed)
- [ ] No hardcoded paths (use Path() and configuration)
- [ ] Code cells have descriptive comments
- [ ] Large outputs stripped (unless needed for demo)
- [ ] Professional styling on charts
- [ ] Usage tips included
- [ ] Export to HTML works cleanly

## Templates

### Basic Analysis Notebook

```markdown
# Title of Analysis

Brief description of what this notebook does.

**Data source**: Where the data comes from
**Date range**: Start to end
**Updated**: Last update date
```

```python
# Setup
import pandas as pd
from pathlib import Path

DATA_DIR = Path.cwd() / "data"
print("✅ Setup complete")
```

```python
# Load data with feedback
try:
    df = pd.read_csv(DATA_DIR / "processed" / "data.csv.gz")
    print(f"✅ Loaded {len(df):,} records")
except FileNotFoundError:
    print("❌ Data not found. Run: make process")
    df = None
```

```markdown
## Analysis

Description of what we're analyzing
```

```python
# Perform analysis
if df is not None:
    result = df.groupby('category').size()
    print(result)
```

### Visualization Notebook

```python
# Create visualization
fig = go.Figure()
# ... add traces ...

# Save
today = datetime.now().strftime('%Y-%m-%d')
report_dir = Path("reports") / today
report_dir.mkdir(parents=True, exist_ok=True)

output_path = report_dir / "visualization.html"
fig.write_html(output_path)

print(f"✅ Saved to: {output_path}")
print(f"💡 Tip: Interactive - hover for details")

fig.show()
```

## Advanced Patterns

### Hidden Cells for Utility Functions

```python
# Utility functions (can collapse in presentation)
def format_duration(seconds):
    """Format seconds as human-readable duration"""
    if seconds < 60:
        return f"{seconds:.0f}s"
    elif seconds < 3600:
        return f"{seconds/60:.0f}m"
    else:
        return f"{seconds/3600:.1f}h"

# Add Cell → Cell Type → Raw to hide in HTML export
```

### Table of Contents

For long notebooks:

```markdown
## Table of Contents

1. [Setup](#Setup)
2. [Data Loading](#Data-Loading)
3. [Analysis](#Analysis)
4. [Visualizations](#Visualizations)
5. [Conclusions](#Conclusions)
```

### Parameter Cells

For notebooks run with different configurations:

```python
# Parameters (edit these)
START_DATE = "2025-10-13"
END_DATE = "2025-10-27"
TOP_N_ALARMS = 20
DESTINATION_FILTER = "ms_teams"  # or "all"

# Validate
assert pd.to_datetime(START_DATE) <= pd.to_datetime(END_DATE)
print(f"✅ Configuration validated")
```

## Conclusion

Great presentation notebooks:
1. Tell a clear story from start to finish
2. Provide context and guidance
3. Handle errors gracefully
4. Save outputs for sharing
5. Look professional and polished
6. Are reproducible by others

Focus on the audience experience - what do they need to understand and what would make it easiest for them?
