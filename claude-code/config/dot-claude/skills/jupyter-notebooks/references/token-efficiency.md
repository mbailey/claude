# Token Efficiency for Jupyter Notebooks

This document describes techniques for working with Jupyter notebooks in a token-efficient manner, ensuring AI assistants can effectively read, analyze, and modify notebooks without consuming excessive context.

## Core Problem

Jupyter notebooks store outputs (dataframes, plots, logs) as JSON data within the `.ipynb` file. When an AI reads a notebook:

- **Code cells**: ~100-500 tokens each
- **Output cells with data**: Can be 10,000+ tokens each
- **Large visualizations**: Can be 50,000+ tokens (base64 encoded images)

A simple notebook with a few dataframe outputs can easily consume 100,000+ tokens just from outputs.

## Solutions

### 1. Strategic Output Stripping

**Pre-commit Hooks** (Recommended for most workflows)

Use Jupyter pre-commit hooks to automatically strip outputs:

```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/kynan/nbstripout
    rev: 0.6.1
    hooks:
      - id: nbstripout
```

**Selective Output Preservation**

When outputs ARE needed (for demos, reports, sharing):

```bash
# Skip the jupyter hook for this commit
SKIP=jupyter git commit -m "Add notebook with visualization outputs"
```

**Manual Stripping**

```bash
# Strip all outputs
jupyter nbconvert --clear-output --inplace *.ipynb

# Or using nbstripout
nbstripout notebook.ipynb
```

### 2. Query Notebooks Without Reading Outputs

Use `jq` to query notebook structure without loading large outputs into context.

#### Compare Code Cells Only (Ignore Outputs)

```bash
# Extract just the code from cells
jq '.cells[] | select(.cell_type == "code") | .source' notebook1.ipynb > code1.json
jq '.cells[] | select(.cell_type == "code") | .source' notebook2.ipynb > code2.json

# Compare
diff code1.json code2.json
```

#### Count Cells by Type

```bash
jq '.cells | group_by(.cell_type) | map({type: .[0].cell_type, count: length})' notebook.ipynb
```

#### Extract Cell Metadata Only

```bash
# See what's in the notebook without reading outputs
jq '.cells[] | {
  cell_type,
  execution_count,
  has_output: (.outputs | length > 0)
}' notebook.ipynb
```

#### Check Notebook for Large Outputs

```bash
# Find cells with large outputs (>10KB when serialized)
jq '.cells[] | select(.outputs | length > 0) | {
  index: .execution_count,
  output_size: (.outputs | tostring | length)
} | select(.output_size > 10000)' notebook.ipynb
```

### 3. Structured Reading Pattern

When AI must read a notebook with outputs, use a staged approach:

**Stage 1: Metadata scan (minimal tokens)**
```bash
# Get cell count, types, and structure
jq '{
  cell_count: (.cells | length),
  cell_types: (.cells | group_by(.cell_type) | map({type: .[0].cell_type, count: length})),
  has_outputs: (.cells | map(select(.outputs | length > 0)) | length > 0)
}' notebook.ipynb
```

**Stage 2: Code-only read (moderate tokens)**
```python
# Read notebook but examine only code cells
from Read tool with file_path parameter
# AI filters to code cells mentally or via jq
```

**Stage 3: Selective output reading (high tokens - only when necessary)**
```bash
# Read specific cell's output
jq '.cells[5].outputs' notebook.ipynb
```

### 4. AI Instruction Patterns

When asking AI to work with notebooks, give token-efficient instructions:

**Good (token efficient):**
```
Compare the code cells between alarm-day-hour-pattern.ipynb and
alarm-day-hour-pattern-2025-10-27.ipynb. Use jq to extract just
the source code, ignore outputs.
```

**Bad (token wasteful):**
```
Read both notebooks and tell me what changed.
```

**Good (staged approach):**
```
1. Use jq to check if only outputs changed
2. If code changed, read the notebooks to analyze differences
```

**Bad (loads everything):**
```
Read the notebook and analyze it.
```

### 5. Output Management in Notebooks

#### Display Large Data Efficiently

**Instead of this (wasteful):**
```python
# Shows entire dataframe in output
df_alarms
```

**Do this (efficient):**
```python
# Show summary only
print(f"Loaded {len(df_alarms):,} alarms")
print(f"Columns: {', '.join(df_alarms.columns)}")
print(f"Date range: {df_alarms['timestamp'].min()} to {df_alarms['timestamp'].max()}")
```

#### Save Outputs to Files Instead of Cells

**Instead of this:**
```python
# Large visualization rendered in cell output
fig.show()
```

**Do this:**
```python
# Save to file, show confirmation only
fig.write_html(report_dir / "visualization.html")
print(f"✅ Saved visualization to {report_dir}/visualization.html")
```

#### Use Compression for Data Outputs

```python
# Save processed data compressed
df.to_csv("data/processed/alarms.csv.gz", compression='gzip', index=False)
print(f"✅ Saved {len(df):,} records to alarms.csv.gz ({file_size_mb:.1f} MB)")
```

### 6. Notebook Cell Organization

Organize cells to minimize re-reading:

```python
# Cell 1: Imports and setup (read once)
import pandas as pd
from pathlib import Path

# Cell 2: Configuration (read once)
DATA_DIR = Path("data")
REPORT_DIR = Path("reports")

# Cell 3: Data loading with summary output (efficient)
df = pd.read_csv(DATA_DIR / "alarms.csv.gz")
print(f"✅ Loaded {len(df):,} rows")

# Cell 4: Analysis with minimal output
result = analyze_alarms(df)
print("✅ Analysis complete")

# Cell 5: Save outputs (no cell output, saves to files)
result.to_csv(REPORT_DIR / "summary.csv", index=False)
```

## Token Budget Examples

### Typical Token Costs

**Small notebook (outputs stripped):**
- 10 code cells × 200 tokens = 2,000 tokens
- 5 markdown cells × 100 tokens = 500 tokens
- **Total: ~2,500 tokens**

**Same notebook with outputs:**
- Code cells: 2,000 tokens
- Markdown cells: 500 tokens
- 3 dataframe outputs × 5,000 tokens = 15,000 tokens
- 2 plotly charts × 30,000 tokens = 60,000 tokens
- **Total: ~77,500 tokens** (31× more!)

### Reading Strategy by Task

**Task: "Check if code changed"**
- Use jq to compare code cells only
- **Budget: <100 tokens** (just the jq command output)

**Task: "Review notebook structure"**
- Read metadata and code cells only
- **Budget: ~3,000 tokens**

**Task: "Analyze visualization outputs"**
- Must read outputs
- **Budget: 50,000+ tokens**
- **Strategy**: Read one notebook at a time, specific cells only

## Best Practices Summary

1. **Default to outputs stripped** - Use pre-commit hooks
2. **Query before reading** - Use jq to check structure first
3. **Read code only when possible** - Outputs rarely needed for code analysis
4. **Stage your reads** - Metadata → code → outputs (if needed)
5. **Efficient output cells** - Print summaries, not raw data
6. **Save outputs to files** - Not to cell outputs
7. **Compress data files** - Use .gz, .parquet
8. **Clear instructions** - Tell AI exactly what to read and what to skip

## Tools Reference

### jq Patterns for Notebooks

```bash
# Cell count by type
jq '.cells | group_by(.cell_type) | map({type: .[0].cell_type, count: length})'

# Code cells only
jq '.cells[] | select(.cell_type == "code") | .source'

# Check for outputs
jq '.cells | map(select(.outputs | length > 0)) | length'

# Get cell by index
jq '.cells[3]'

# List execution counts
jq '.cells[] | select(.cell_type == "code") | .execution_count'
```

### Bash Tool Integration

When working with AI assistants:

```bash
# Efficient: Compare code only
jq '.cells[] | select(.cell_type == "code") | .source' notebook1.ipynb > /tmp/code1.json
jq '.cells[] | select(.cell_type == "code") | .source' notebook2.ipynb > /tmp/code2.json
diff /tmp/code1.json /tmp/code2.json

# Inefficient: Reading full notebooks with outputs
# (Avoid this unless outputs are specifically needed)
```

## AI Assistant Integration

When delegating notebook tasks to AI agents:

**Efficient delegation:**
```
Use jq to compare code cells in alarm-pattern.ipynb and alarm-pattern-new.ipynb.
Only read the full notebooks if the code differs.
```

**Token-aware instructions:**
```
The notebook has large outputs. Read only cells 1-4 (imports and setup).
Skip cells with visualization outputs.
```

## Troubleshooting

### "Notebook is too large to read"

1. Check file size: `ls -lh notebook.ipynb`
2. Count outputs: `jq '.cells | map(select(.outputs | length > 0)) | length' notebook.ipynb`
3. Strip outputs: `jupyter nbconvert --clear-output --inplace notebook.ipynb`
4. Try again

### "AI read the wrong parts"

- Be explicit: "Read cells 1-3 only, skip output cells"
- Use jq to extract exactly what's needed
- Stage the reading: structure → code → outputs

### "Need outputs for presentation"

- Keep outputs stripped in main branch
- Create dated snapshot with outputs: `notebook-2025-10-27.ipynb`
- Or: Export to HTML for sharing instead of committing with outputs

## Conclusion

Token efficiency with notebooks is about:
1. **Minimizing output storage** (pre-commit hooks)
2. **Querying structure before reading** (jq)
3. **Reading only what's needed** (code vs outputs)
4. **Organizing notebooks for efficient reading** (summaries not raw data)

This allows AI assistants to work effectively with notebooks without consuming excessive context budget.
