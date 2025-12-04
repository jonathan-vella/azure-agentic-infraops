#!/usr/bin/env python3
"""
Agentic InfraOps - ROI Calculator Infographic Generator

Creates a professional infographic showing return on investment:
- $19/user/month investment
- Week 1 break-even
- 39:1 annual ROI
- Time savings breakdown

Requirements:
    pip install matplotlib numpy

Usage:
    python generate_roi_calculator.py

Output:
    - roi-calculator.png (high-res for presentations)
    - roi-calculator-web.png (optimized for web)
"""

import matplotlib.pyplot as plt
import matplotlib.patches as patches
from matplotlib.patches import FancyBboxPatch, Circle, FancyArrowPatch
import numpy as np
from pathlib import Path

# Color palette (Azure-inspired)
COLORS = {
    'primary': '#0078D4',      # Azure blue
    'secondary': '#50E6FF',    # Light azure
    'accent': '#00B294',       # Teal
    'warning': '#FFB900',      # Yellow
    'danger': '#D13438',       # Red
    'success': '#107C10',      # Green
    'purple': '#5C2D91',       # Purple
    'orange': '#D83B01',       # Orange
    'dark': '#201F1E',         # Near black
    'light': '#F3F2F1',        # Light gray
    'white': '#FFFFFF',
    'gold': '#D4A017',         # Gold for ROI
}

# ROI Data
MONTHLY_COST = 19  # per user
HOURS_SAVED_PER_WEEK = 8
HOURLY_RATE = 75  # IT Pro average
WEEKS_TO_BREAKEVEN = 1
ANNUAL_ROI = 39  # 39:1

# Time savings by task
TASK_SAVINGS = [
    {'task': 'IaC Development', 'before': 6.0, 'after': 1.5, 'color': COLORS['primary']},
    {'task': 'Documentation', 'before': 4.0, 'after': 0.5, 'color': COLORS['success']},
    {'task': 'Troubleshooting', 'before': 3.0, 'after': 1.0, 'color': COLORS['orange']},
    {'task': 'Code Review', 'before': 2.0, 'after': 0.5, 'color': COLORS['purple']},
    {'task': 'Learning New Tech', 'before': 5.0, 'after': 2.0, 'color': COLORS['accent']},
]


def create_roi_calculator():
    """Generate the ROI calculator infographic."""
    
    # Create figure (wide format for presentations)
    fig = plt.figure(figsize=(14, 7), facecolor=COLORS['white'])
    ax = fig.add_axes([0, 0, 1, 1])
    ax.set_xlim(0, 14)
    ax.set_ylim(0, 7)
    ax.axis('off')
    
    # === HEADER ===
    ax.text(7, 6.6, 'GitHub Copilot ROI Calculator', fontsize=24, fontweight='bold',
            color=COLORS['primary'], ha='center', va='center')
    ax.text(7, 6.15, 'Quantified value for IT Professionals', fontsize=12,
            color=COLORS['dark'], ha='center', va='center', style='italic')
    
    # === TOP ROW: KEY METRICS ===
    metrics = [
        {'value': f'${MONTHLY_COST}', 'label': 'Per User/Month', 'sublabel': 'Investment', 
         'color': COLORS['primary'], 'x': 2},
        {'value': f'Week {WEEKS_TO_BREAKEVEN}', 'label': 'Break-Even', 'sublabel': 'Time to Value',
         'color': COLORS['success'], 'x': 5.5},
        {'value': f'{ANNUAL_ROI}:1', 'label': 'Annual ROI', 'sublabel': 'Return on Investment',
         'color': COLORS['gold'], 'x': 9},
        {'value': f'{HOURS_SAVED_PER_WEEK}hrs', 'label': 'Saved/Week', 'sublabel': 'Per IT Pro',
         'color': COLORS['accent'], 'x': 12},
    ]
    
    for m in metrics:
        # Metric box
        box = FancyBboxPatch((m['x'] - 1.3, 4.6), 2.6, 1.3,
                             boxstyle="round,pad=0.05,rounding_size=0.15",
                             facecolor=COLORS['light'], edgecolor=m['color'],
                             linewidth=3, transform=ax.transData)
        ax.add_patch(box)
        
        # Value (large)
        ax.text(m['x'], 5.4, m['value'], fontsize=22, fontweight='bold',
                color=m['color'], ha='center', va='center')
        
        # Label
        ax.text(m['x'], 5.0, m['label'], fontsize=10, fontweight='bold',
                color=COLORS['dark'], ha='center', va='center')
        
        # Sublabel
        ax.text(m['x'], 4.75, m['sublabel'], fontsize=8,
                color=COLORS['dark'], ha='center', va='center', alpha=0.7)
    
    # === LEFT SECTION: TIME SAVINGS BAR CHART ===
    ax.text(3.5, 4.1, '⏱️ Weekly Hours by Task', fontsize=12, fontweight='bold',
            color=COLORS['dark'], ha='center', va='center')
    
    bar_height = 0.4
    bar_start_y = 3.4
    bar_max_width = 4.5
    
    for i, task in enumerate(TASK_SAVINGS):
        y = bar_start_y - i * 0.65
        
        # Task label
        ax.text(0.3, y, task['task'], fontsize=9, color=COLORS['dark'],
                ha='left', va='center')
        
        # Before bar (gray)
        before_width = (task['before'] / 8) * bar_max_width
        ax.add_patch(FancyBboxPatch((1.8, y - bar_height/2), before_width, bar_height,
                                    boxstyle="round,pad=0.02,rounding_size=0.05",
                                    facecolor=COLORS['light'], edgecolor=COLORS['dark'],
                                    linewidth=0.5, alpha=0.5))
        ax.text(1.8 + before_width + 0.1, y, f'{task["before"]}h', fontsize=8,
                color=COLORS['dark'], ha='left', va='center', alpha=0.6)
        
        # After bar (colored)
        after_width = (task['after'] / 8) * bar_max_width
        ax.add_patch(FancyBboxPatch((1.8, y - bar_height/2), after_width, bar_height,
                                    boxstyle="round,pad=0.02,rounding_size=0.05",
                                    facecolor=task['color'], edgecolor='none'))
        
        # Savings indicator
        savings = task['before'] - task['after']
        savings_pct = (savings / task['before']) * 100
        ax.text(6.5, y, f'-{savings:.1f}h ({savings_pct:.0f}%)', fontsize=8,
                color=COLORS['success'], ha='left', va='center', fontweight='bold')
    
    # Legend for bars
    ax.add_patch(FancyBboxPatch((1.8, 0.55), 0.3, 0.2,
                                boxstyle="round,pad=0.02,rounding_size=0.02",
                                facecolor=COLORS['light'], edgecolor=COLORS['dark'],
                                linewidth=0.5, alpha=0.5))
    ax.text(2.2, 0.65, 'Before', fontsize=7, color=COLORS['dark'], ha='left', va='center')
    
    ax.add_patch(FancyBboxPatch((3.2, 0.55), 0.3, 0.2,
                                boxstyle="round,pad=0.02,rounding_size=0.02",
                                facecolor=COLORS['primary'], edgecolor='none'))
    ax.text(3.6, 0.65, 'After (with Copilot)', fontsize=7, color=COLORS['dark'], 
            ha='left', va='center')
    
    # === RIGHT SECTION: ANNUAL VALUE ===
    ax.text(10.5, 4.1, '💰 Annual Value Per IT Pro', fontsize=12, fontweight='bold',
            color=COLORS['dark'], ha='center', va='center')
    
    # Calculate annual value
    hours_saved_annually = HOURS_SAVED_PER_WEEK * 52
    value_saved = hours_saved_annually * HOURLY_RATE
    annual_cost = MONTHLY_COST * 12
    net_value = value_saved - annual_cost
    
    value_items = [
        {'label': 'Hours Saved', 'value': f'{hours_saved_annually:,}', 'unit': 'hours/year',
         'color': COLORS['primary']},
        {'label': 'Value Created', 'value': f'${value_saved:,}', 'unit': f'@ ${HOURLY_RATE}/hr',
         'color': COLORS['success']},
        {'label': 'License Cost', 'value': f'-${annual_cost}', 'unit': 'per year',
         'color': COLORS['danger']},
        {'label': 'Net Value', 'value': f'${net_value:,}', 'unit': 'per IT Pro/year',
         'color': COLORS['gold']},
    ]
    
    for i, item in enumerate(value_items):
        y = 3.5 - i * 0.7
        x = 8.5
        
        # Background for last item (Net Value)
        if i == len(value_items) - 1:
            ax.add_patch(FancyBboxPatch((x - 0.3, y - 0.3), 4.6, 0.6,
                                        boxstyle="round,pad=0.02,rounding_size=0.1",
                                        facecolor=COLORS['light'], edgecolor=item['color'],
                                        linewidth=2))
        
        # Label
        ax.text(x, y, item['label'] + ':', fontsize=10, color=COLORS['dark'],
                ha='left', va='center')
        
        # Value
        ax.text(x + 2.5, y, item['value'], fontsize=12, fontweight='bold',
                color=item['color'], ha='left', va='center')
        
        # Unit
        ax.text(x + 4, y, item['unit'], fontsize=8, color=COLORS['dark'],
                ha='left', va='center', alpha=0.7)
    
    # === BOTTOM: RESEARCH CITATION ===
    ax.text(7, 0.25, '📊 Based on GitHub/Accenture research: 55% faster coding, 75% improved focus, 88% maintained flow',
            fontsize=8, color=COLORS['dark'], ha='center', va='center', style='italic')
    
    # === FOOTER ===
    ax.text(13.5, 0.25, 'aka.ms/agenticinfraops', fontsize=8,
            color=COLORS['dark'], ha='right', va='center', style='italic')
    
    return fig


def main():
    """Generate and save the ROI calculator infographic."""
    output_dir = Path(__file__).parent / 'generated'
    output_dir.mkdir(exist_ok=True)
    
    print("🎨 Generating ROI Calculator Infographic...")
    
    fig = create_roi_calculator()
    
    # Save high-res PNG (for presentations)
    fig.savefig(output_dir / 'roi-calculator.png', dpi=300, 
                bbox_inches='tight', facecolor='white', edgecolor='none')
    print(f"  ✅ Saved: {output_dir / 'roi-calculator.png'}")
    
    # Save web-optimized version
    fig.savefig(output_dir / 'roi-calculator-web.png', dpi=150,
                bbox_inches='tight', facecolor='white', edgecolor='none')
    print(f"  ✅ Saved: {output_dir / 'roi-calculator-web.png'}")
    
    plt.close(fig)
    print("✅ ROI calculator generation complete!")


if __name__ == '__main__':
    main()
