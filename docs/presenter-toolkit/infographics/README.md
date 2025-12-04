# Infographics Generator

> **Python scripts for generating professional visual assets for GitHub Copilot presentations.**

---

## Quick Start

### Prerequisites

```bash
# Install required Python packages
pip install matplotlib numpy pillow
```

### Generate All Assets

```bash
cd docs/presenter-toolkit/infographics

# Generate all infographics
python generate_infographic.py
python generate_before_after.py
python generate_workflow_diagram.py
python generate_waf_scorecard.py
python generate_roi_calculator.py
python generate_one_slide.py
python generate_docs_overview.py
python generate_exec_banner.py
```

### Output

Generated files are saved to `./generated/`:

| File                               | Format  | Use Case                    |
| ---------------------------------- | ------- | --------------------------- |
| `workflow-diagram.png`             | 300 DPI | 4-step agent workflow       |
| `workflow-diagram-web.png`         | 150 DPI | Web, presentations          |
| `waf-scorecard.png`                | 300 DPI | WAF alignment radar chart   |
| `waf-scorecard-web.png`            | 150 DPI | Web, presentations          |
| `roi-calculator.png`               | 300 DPI | ROI/value infographic       |
| `roi-calculator-web.png`           | 150 DPI | Web, presentations          |
| `time-savings-infographic.png`     | 300 DPI | Print, large displays       |
| `time-savings-infographic-web.png` | 150 DPI | Web, presentations          |
| `time-savings-infographic.pdf`     | Vector  | Scalable printing           |
| `before-after-poster.png`          | 300 DPI | Print, workshop walls       |
| `before-after-poster-web.png`      | 150 DPI | Web, presentations          |
| `before-after-poster.pdf`          | Vector  | Scalable printing           |
| `executive-one-slide.png`          | 300 DPI | Executive summary slide     |
| `executive-one-slide-web.png`      | 150 DPI | Web, presentations          |
| `docs-overview-infographic.png`    | 300 DPI | Documentation navigation    |
| `exec-pitch-banner.png`            | 150 DPI | Banner for presentations    |

---

## Available Scripts

### 1. Workflow Diagram (`generate_workflow_diagram.py`) ⭐ NEW

**What it creates:** The core 4-step agent workflow diagram showing:

- @plan → azure-principal-architect → bicep-plan → bicep-implement
- Approval gates between each step
- Optional integrations (MCP, diagrams, ADR)
- Color-coded steps with descriptions

**Dimensions:** 16" × 9" (presentation slide)

### 2. WAF Scorecard (`generate_waf_scorecard.py`) ⭐ NEW

**What it creates:** A radar chart showing Well-Architected Framework alignment:

- 5 WAF pillars with scores
- Overall WAF score badge
- Score legend
- Azure WAF branding

**Dimensions:** 12" × 8" (presentation slide)

### 3. ROI Calculator (`generate_roi_calculator.py`) ⭐ NEW

**What it creates:** ROI and value proposition infographic showing:

- Key metrics ($19/mo, Week 1 break-even, 39:1 ROI)
- Time savings by task (bar chart)
- Annual value calculation
- Research citations

**Dimensions:** 14" × 7" (wide format)

### 4. Time Savings Infographic (`generate_infographic.py`)

**What it creates:** A portrait-oriented infographic showing:

- Headline stat (80-85% time savings)
- Task-by-task breakdown with before/after bars
- Project showcase cards
- Research backing citations
- Call-to-action footer

**Dimensions:** 12" × 18" (poster size)

### 2. Before/After Poster (`generate_before_after.py`)

**What it creates:** A landscape comparison poster showing:

- Side-by-side workflow comparison
- 6-step "before" workflow (red)
- 4-step "after" workflow (green)
- Key benefits and stats bar

**Dimensions:** 20" × 12" (wide format)

---

## Customization

### Changing Colors

Edit the `COLORS` dictionary in each script:

```python
COLORS = {
    'primary': '#0078D4',      # Azure blue
    'secondary': '#50E6FF',    # Light azure
    'success': '#107C10',      # Green
    'danger': '#D13438',       # Red
    # ... add your brand colors
}
```

### Changing Data

Modify the data arrays in each script:

```python
# In generate_infographic.py
tasks = [
    ('IaC Development', 45, 10, '78%'),  # (name, before_min, after_min, savings)
    ('Automation Scripts', 60, 15, '75%'),
    # ... add your measured data
]
```

### Changing Dimensions

Adjust the figure size in `create_infographic()` or `create_before_after_poster()`:

```python
fig = plt.figure(figsize=(12, 18), ...)  # (width, height) in inches
```

---

## Advanced Usage

### Batch Generation

```bash
# Generate all infographics in one go
for script in generate_*.py; do
    python "$script"
done
```

### Custom Output Directory

```python
# In your script
output_dir = Path('/custom/path/to/output')
save_infographic(fig, output_dir)
```

### Different DPI Settings

```python
# For higher quality print
fig.savefig(path, dpi=600, ...)

# For smaller web files
fig.savefig(path, dpi=72, ...)
```

---

## Troubleshooting

### "No module named matplotlib"

```bash
pip install matplotlib numpy pillow
```

### Fonts look wrong

The scripts use system fonts. On Linux:

```bash
sudo apt-get install fonts-dejavu
```

### Colors don't match Azure brand

The scripts use official Azure colors. If you need exact brand compliance,
reference: https://brand.azure.com/

---

## Files

```
infographics/
├── README.md                       # This file
├── generate_workflow_diagram.py    # ⭐ 4-step agent workflow diagram
├── generate_waf_scorecard.py       # ⭐ WAF alignment radar chart
├── generate_roi_calculator.py      # ⭐ ROI and value proposition
├── generate_infographic.py         # Time savings infographic generator
├── generate_before_after.py        # Before/after poster generator
└── generated/                      # Output directory (created on run)
    ├── workflow-diagram.png        # 16x9 workflow (300 DPI)
    ├── workflow-diagram-web.png    # Web version (150 DPI)
    ├── workflow-diagram.pdf        # Vector PDF
    ├── waf-scorecard.png           # WAF radar chart (300 DPI)
    ├── waf-scorecard-web.png       # Web version (150 DPI)
    ├── roi-calculator.png          # ROI infographic (300 DPI)
    ├── roi-calculator-web.png      # Web version (150 DPI)
    ├── time-savings-infographic.png
    ├── time-savings-infographic-web.png
    ├── time-savings-infographic.pdf
    ├── before-after-poster.png
    ├── before-after-poster-web.png
    └── before-after-poster.pdf
```

---

## Document Info

|                  |                           |
| ---------------- | ------------------------- |
| **Created**      | November 2025             |
| **Python**       | 3.8+                      |
| **Dependencies** | matplotlib, numpy, pillow |
| **Maintainer**   | Repository maintainers    |
