# Notebook Project Assessment

This document provides criteria and checklists for assessing the quality and maturity of Jupyter notebook projects.

## Assessment Philosophy

A well-organized notebook project should:
1. **Work without Jupyter** - Business logic in scripts/lib
2. **Be easy to navigate** - Clean structure, clear documentation
3. **Be reproducible** - Anyone can run it
4. **Be maintainable** - Easy to update and extend
5. **Be presentation-ready** - Professional quality for sharing

## Quick Assessment Checklist

Use this checklist to evaluate a notebook project:

### File Structure (5 points)

- [ ] **Root directory is clean** - Only notebooks and essential config files at root
- [ ] **Notebooks are visible** - All active .ipynb files at root level
- [ ] **Documentation present** - README.md exists and is informative
- [ ] **Subdirectories organized** - scripts/, lib/, data/, reports/ properly used
- [ ] **Deprecated content archived** - Old notebooks in .archive/ not deleted

**Score:** ___/5

### Code Organization (5 points)

- [ ] **Logic separated** - Business logic in lib/ or scripts/, not embedded in notebooks
- [ ] **Scripts are CLI-ready** - Can run scripts without opening Jupyter
- [ ] **Imports are modular** - `from lib import module` pattern used
- [ ] **No code duplication** - Reusable functions in lib/, called from notebooks
- [ ] **Notebooks are interfaces** - Notebooks orchestrate, don't implement

**Score:** ___/5

### Data Management (4 points)

- [ ] **Data directory structure** - data/raw/ and data/processed/ present
- [ ] **Raw data immutable** - Original data never modified
- [ ] **Processed data organized** - Clear naming with dates or versioning
- [ ] **Data gitignored** - .gitkeep present but data files ignored

**Score:** ___/4

### Reproducibility (5 points)

- [ ] **Dependencies documented** - pyproject.toml with all dependencies
- [ ] **Python version specified** - .python-version file present
- [ ] **Environment variables documented** - .env.example provided if needed
- [ ] **"Restart & Run All" works** - Notebooks execute cleanly top to bottom
- [ ] **No hardcoded paths** - Uses Path() and configuration variables

**Score:** ___/5

### Version Control (4 points)

- [ ] **Proper .gitignore** - data/, reports/, .venv/ ignored
- [ ] **Outputs managed** - Default to stripped, or clear strategy for outputs
- [ ] **Clean commits** - No giant notebook diffs from outputs
- [ ] **Keep files tracked** - .gitkeep in empty directories

**Score:** ___/4

### Token Efficiency (4 points)

- [ ] **Outputs stripped by default** - Git filter (`.gitattributes`), pre-commit hook, or documented manual process
- [ ] **Summary outputs** - Print summaries, not raw dataframes
- [ ] **Outputs saved to files** - Visualizations saved, not just displayed
- [ ] **Efficient data loading** - Feedback without dumping data

**Score:** ___/4

**Note on output stripping**: Check both pre-commit hooks AND `.gitattributes` for git filter configuration:
```bash
# Check for pre-commit hook
test -f .pre-commit-config.yaml && grep nbstripout .pre-commit-config.yaml

# Check for git filter (repo-level or global)
git config --list | grep nbstrip
cat .gitattributes 2>/dev/null | grep ipynb
```

Both approaches are valid:
- **Git filter** (`.gitattributes` + `filter.nbstripout.*`): Strips on commit, keeps outputs in working directory
- **Pre-commit hook**: Strips before commit, modifies working directory
- Either is acceptable; both is redundant

### Presentation Quality (5 points)

- [ ] **Title and overview** - First cell explains purpose
- [ ] **Section headers** - Markdown cells organize content
- [ ] **Visual feedback** - Uses emojis (✅ ⚠️ 💡) and formatting
- [ ] **Error handling** - Graceful failures with helpful messages
- [ ] **Professional styling** - Charts have titles, labels, good colors

**Score:** ___/5

### Documentation (3 points)

- [ ] **README comprehensive** - Setup instructions, purpose, usage
- [ ] **Code comments** - Complex logic explained
- [ ] **Usage examples** - Clear how to run the project

**Score:** ___/3

## Overall Score

**Total: ___/35**

- **30-35**: Excellent - Production-ready notebook project
- **25-29**: Good - Solid structure, minor improvements needed
- **20-24**: Fair - Functional but needs organization work
- **15-19**: Poor - Significant restructuring needed
- **<15**: Failing - Major issues, not usable by others

## Detailed Assessment Guidelines

### File Structure Assessment

**Look for:**
```
project-root/
├── *.ipynb                    # ✅ Notebooks visible at root
├── README.md                  # ✅ Documentation present
├── pyproject.toml             # ✅ Dependencies defined
├── scripts/                   # ✅ CLI scripts directory
├── lib/                       # ✅ Python modules directory
├── data/                      # ✅ Data directory
│   ├── raw/                   # ✅ Raw data subdirectory
│   └── processed/             # ✅ Processed data subdirectory
├── reports/                   # ✅ Outputs directory
└── docs/                      # ✅ Additional documentation
```

**Red flags:**
- More than 8-10 files at root level
- No README.md
- Scripts mixed with notebooks at root
- Documentation files (.md) cluttering root
- No clear data organization

**Assessment questions:**
1. Can I immediately see what notebooks are available?
2. Is there a clear README explaining the project?
3. Are supporting files organized in subdirectories?
4. Would a new user know where to find things?

### Code Organization Assessment

**Good patterns:**
```python
# In notebook
from lib.data_processing import clean_alarm_data
from lib.visualization import create_pattern_chart

df = clean_alarm_data(raw_df)
fig = create_pattern_chart(df)
```

**Bad patterns:**
```python
# In notebook - all logic embedded
def clean_alarm_data(df):
    # 50 lines of processing logic
    return cleaned_df

def create_pattern_chart(df):
    # 100 lines of visualization code
    return fig
```

**Assessment questions:**
1. Can the core logic run without Jupyter?
2. Are functions reusable across notebooks?
3. Is business logic separated from presentation?
4. Would tests be easy to write?

### Data Management Assessment

**Good:**
```
data/
├── raw/
│   └── alarm-router-2025-10-24.log.gz     # Original, never modified
└── processed/
    ├── alarms_2025-10-24.csv.gz          # Dated processed files
    └── routing_2025-10-24.csv.gz
```

**Bad:**
```
data/
├── alarms.csv                              # ❌ No versioning
├── alarms_backup.csv                       # ❌ Manual backups
├── alarms_new.csv                          # ❌ Unclear naming
└── raw_data_do_not_delete.csv             # ❌ No organization
```

**Assessment questions:**
1. Is it clear what data is original vs processed?
2. Can you identify when data was extracted/processed?
3. Is data organized logically?
4. Would it be easy to reprocess from raw?

### Reproducibility Assessment

**Test:**
1. Clone the repository
2. Run: `uv sync` (or equivalent)
3. Run: `jupyter nbconvert --execute *.ipynb --to notebook`
4. Check if all notebooks execute without errors

**Assessment questions:**
1. Are all dependencies specified?
2. Does "Restart & Run All" work?
3. Are there any hardcoded paths to fix?
4. Would this work on a different machine?

### Token Efficiency Assessment

**Efficient notebook:**
```python
# Cell output
✅ Loaded 2,055 alarms from 11 daily files
Date range: 2025-10-13 to 2025-10-24
Unique alarms: 68
✅ Saved visualization to reports/2025-10-27/alarm_pattern.html
```

**Inefficient notebook:**
```python
# Cell output (displays entire dataframe)
[2055 rows × 12 columns dataframe display]

# Cell output (large base64 plotly chart)
<plotly.graph_objs._figure.Figure object at 0x...>
[50KB of base64 encoded image data]
```

**Assessment questions:**
1. Are outputs stripped or minimal?
2. Do cells print summaries instead of raw data?
3. Are large outputs saved to files?
4. Would an AI assistant struggle with context?

### Presentation Quality Assessment

**Professional notebook:**
- Clear title and purpose
- Organized sections with markdown headers
- Visual feedback (✅ ⚠️ 💡)
- Error handling with helpful messages
- Formatted output (numbers with commas)
- Professional charts with titles and labels

**Rough notebook:**
- No title or context
- Code cells only, no markdown
- Silent execution (no feedback)
- Cryptic error messages
- Raw unformatted output
- Charts with default styling

**Assessment questions:**
1. Could this be shown to stakeholders?
2. Is it clear what each section does?
3. Are errors handled gracefully?
4. Would someone understand the findings?

## Common Issues and Recommendations

### Issue: Root Directory Too Cluttered

**Symptoms:**
- 15+ files at root
- Markdown docs mixed with notebooks
- Scripts at root level

**Recommendations:**
1. Create docs/ directory for markdown files
2. Move scripts to scripts/
3. Archive old notebooks to .archive/
4. Keep only active notebooks and config at root

### Issue: Logic Embedded in Notebooks

**Symptoms:**
- Long function definitions in cells
- Same code duplicated across notebooks
- Can't run logic without Jupyter

**Recommendations:**
1. Extract functions to lib/ modules
2. Create CLI scripts for common operations
3. Import and call from notebooks
4. Write tests for lib/ functions

### Issue: Poor Data Organization

**Symptoms:**
- Files named "data_new.csv", "data_final.csv"
- Unclear what data is current
- Processed data mixed with raw

**Recommendations:**
1. Create data/raw/ and data/processed/
2. Use dated filenames: data_2025-10-27.csv
3. Never modify files in data/raw/
4. Document data lineage

### Issue: Not Reproducible

**Symptoms:**
- Cells must run out of order
- Hardcoded paths
- Missing dependencies
- Works on one machine only

**Recommendations:**
1. Ensure "Restart & Run All" works
2. Use Path() and configuration
3. Document dependencies in pyproject.toml
4. Include .python-version

### Issue: Token Inefficient

**Symptoms:**
- Large notebook file sizes
- Outputs with full dataframes
- Base64 images in outputs

**Recommendations:**
1. Add pre-commit hook to strip outputs
2. Print summaries, not raw data
3. Save visualizations to files
4. Use SKIP=jupyter when outputs needed

## Assessment Template

Use this template when providing assessment feedback:

```markdown
# Notebook Project Assessment: [Project Name]

## Summary
[Brief overview of the project and its current state]

## Scores
- File Structure: X/5
- Code Organization: X/5
- Data Management: X/4
- Reproducibility: X/5
- Version Control: X/4
- Token Efficiency: X/4
- Presentation Quality: X/5
- Documentation: X/3

**Total: XX/35** - [Rating]

## Strengths
1. [What's working well]
2. [Positive aspects]
3. [Good practices observed]

## Issues Found
1. **[Issue category]**: [Description]
   - Impact: [How this affects usability]
   - Recommendation: [What to do]

2. **[Issue category]**: [Description]
   - Impact: [How this affects usability]
   - Recommendation: [What to do]

## Recommended Actions

### High Priority
1. [Critical issue to fix first]
2. [Important improvement]

### Medium Priority
1. [Good to have improvement]
2. [Organization task]

### Low Priority
1. [Nice to have enhancement]
2. [Polish task]

## Next Steps
[Concrete action items to improve the project]
```

## Continuous Improvement

Track improvements over time:

1. **Initial assessment** - Document current state
2. **Implement improvements** - Address high-priority issues
3. **Re-assess** - Check progress
4. **Iterate** - Continue improving

Goal: Move from "Fair" → "Good" → "Excellent" over time.

## Evolution Paths

### Early Stage (Score: 15-20)
- **Focus**: Basic structure and reproducibility
- **Actions**: Create directories, separate code, add README
- **Goal**: Make it work reliably

### Growing Stage (Score: 21-27)
- **Focus**: Organization and efficiency
- **Actions**: Clean up structure, improve documentation, add tests
- **Goal**: Make it maintainable

### Mature Stage (Score: 28-35)
- **Focus**: Polish and presentation
- **Actions**: Professional styling, comprehensive docs, optimizations
- **Goal**: Make it shareable and impressive

## Learning from Assessment

After assessing a project, capture learnings:

1. **What worked well?** - Patterns to reuse
2. **What didn't work?** - Anti-patterns to avoid
3. **What was surprising?** - Edge cases to remember
4. **What would you do differently?** - Process improvements

Use these learnings to:
- Update this assessment guide
- Improve templates and examples
- Refine best practices
- Teach others
