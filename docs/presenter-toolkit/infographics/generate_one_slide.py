#!/usr/bin/env python3
"""
Executive One-Slide Summary Generator

Creates a professional "one slide" infographic for the executive pitch.

Requirements:
    pip install matplotlib numpy pillow

Usage:
    python generate_one_slide.py
"""

import matplotlib.pyplot as plt
import matplotlib.patches as patches
from matplotlib.patches import FancyBboxPatch, FancyArrowPatch, Circle
import numpy as np
from pathlib import Path

# Color palette
COLORS = {
    'primary': '#0078D4',
    'secondary': '#50E6FF',
    'success': '#107C10',
    'warning': '#FFB900',
    'dark': '#201F1E',
    'light': '#F3F2F1',
    'white': '#FFFFFF',
}


def create_one_slide():
    """Generate the one-slide executive summary."""
    
    fig = plt.figure(figsize=(14, 8), facecolor=COLORS['white'])
    ax = fig.add_axes([0, 0, 1, 1])
    ax.set_xlim(0, 14)
    ax.set_ylim(0, 8)
    ax.axis('off')
    
    # === HEADER ===
    header_bg = FancyBboxPatch(
        (0, 6.8), 14, 1.2,
        boxstyle="square,pad=0",
        facecolor=COLORS['primary'],
        edgecolor='none'
    )
    ax.add_patch(header_bg)
    
    ax.text(7, 7.5, 'GitHub Copilot for IT Pros', 
            fontsize=28, fontweight='bold', color=COLORS['white'],
            ha='center', va='center')
    ax.text(7, 7.0, 'The Efficiency Multiplier', 
            fontsize=14, color=COLORS['secondary'],
            ha='center', va='center')
    
    # === PROBLEM → SOLUTION → RESULT ===
    sections = [
        ('PROBLEM', 'Architects design\nbut can\'t implement', COLORS['dark'], '#FFEBEE'),
        ('SOLUTION', 'AI-assisted\ninfrastructure development', COLORS['primary'], '#E3F2FD'),
        ('RESULT', '78-88% time savings\non repetitive tasks', COLORS['success'], '#E8F5E9'),
    ]
    
    x_positions = [2.3, 7, 11.7]
    
    for i, (title, desc, color, bg_color) in enumerate(sections):
        x = x_positions[i]
        
        # Section box
        box = FancyBboxPatch(
            (x - 2, 4.8), 4, 1.7,
            boxstyle="round,pad=0.05,rounding_size=0.15",
            facecolor=bg_color,
            edgecolor=color,
            linewidth=2
        )
        ax.add_patch(box)
        
        ax.text(x, 6.2, title, fontsize=12, fontweight='bold',
                color=color, ha='center', va='center')
        ax.text(x, 5.5, desc, fontsize=11, color=COLORS['dark'],
                ha='center', va='center', linespacing=1.3)
    
    # Arrows between sections
    for i in range(2):
        arrow = FancyArrowPatch(
            (x_positions[i] + 2.1, 5.6), (x_positions[i+1] - 2.1, 5.6),
            arrowstyle='->,head_length=0.2,head_width=0.15',
            color=COLORS['primary'],
            linewidth=3
        )
        ax.add_patch(arrow)
    
    # === BEFORE → WITH COPILOT → IMPACT ===
    ax.text(7, 4.3, 'The Transformation', 
            fontsize=14, fontweight='bold', color=COLORS['dark'],
            ha='center', va='center')
    
    # Three comparison boxes
    comparisons = [
        ('BEFORE', '45 min', 'per task', '#FFCDD2', '#C62828'),
        ('WITH COPILOT', '10 min', 'per task', '#C8E6C9', '#2E7D32'),
        ('IMPACT', '78%', 'time saved', '#BBDEFB', '#1565C0'),
    ]
    
    x_positions = [3.5, 7, 10.5]
    
    for i, (title, value, subtitle, bg_color, text_color) in enumerate(comparisons):
        x = x_positions[i]
        
        # Box
        box = FancyBboxPatch(
            (x - 1.5, 2.5), 3, 1.5,
            boxstyle="round,pad=0.05,rounding_size=0.15",
            facecolor=bg_color,
            edgecolor='none'
        )
        ax.add_patch(box)
        
        ax.text(x, 3.75, title, fontsize=10, fontweight='bold',
                color=text_color, ha='center', va='center')
        ax.text(x, 3.25, value, fontsize=24, fontweight='bold',
                color=text_color, ha='center', va='center')
        ax.text(x, 2.75, subtitle, fontsize=10,
                color=COLORS['dark'], ha='center', va='center')
    
    # Arrows
    arrow1 = FancyArrowPatch(
        (5.1, 3.25), (5.4, 3.25),
        arrowstyle='->,head_length=0.15,head_width=0.1',
        color=COLORS['dark'],
        linewidth=2
    )
    ax.add_patch(arrow1)
    
    arrow2 = FancyArrowPatch(
        (8.6, 3.25), (8.9, 3.25),
        arrowstyle='->,head_length=0.15,head_width=0.1',
        color=COLORS['dark'],
        linewidth=2
    )
    ax.add_patch(arrow2)
    
    ax.text(5.25, 3.25, '=', fontsize=16, fontweight='bold',
            color=COLORS['dark'], ha='center', va='center')
    ax.text(8.75, 3.25, '=', fontsize=16, fontweight='bold',
            color=COLORS['dark'], ha='center', va='center')
    
    # === BOTTOM STATS BAR ===
    stats_bg = FancyBboxPatch(
        (0.5, 0.8), 13, 1.4,
        boxstyle="round,pad=0.05,rounding_size=0.1",
        facecolor=COLORS['light'],
        edgecolor='none'
    )
    ax.add_patch(stats_bg)
    
    stats = [
        ('Evidence', 'Stanford, Forrester, MIT, McKinsey'),
        ('Investment', '$19/user/month'),
        ('ROI', 'Break-even in Week 1'),
    ]
    
    x_positions = [3, 7, 11]
    
    for i, (label, value) in enumerate(stats):
        x = x_positions[i]
        ax.text(x, 1.7, label, fontsize=11, fontweight='bold',
                color=COLORS['primary'], ha='center', va='center')
        ax.text(x, 1.25, value, fontsize=11, color=COLORS['dark'],
                ha='center', va='center')
    
    # Dividers
    ax.plot([5, 5], [1.0, 1.9], color=COLORS['primary'], linewidth=1, alpha=0.3)
    ax.plot([9, 9], [1.0, 1.9], color=COLORS['primary'], linewidth=1, alpha=0.3)
    
    # === FOOTER ===
    ax.text(7, 0.4, 'github.com/jonathan-vella/github-copilot-itpro', 
            fontsize=9, color=COLORS['dark'], style='italic',
            ha='center', va='center')
    
    return fig


def save_slide(fig, output_dir: Path):
    """Save the slide in multiple formats."""
    
    output_dir.mkdir(parents=True, exist_ok=True)
    
    # High-res
    print_path = output_dir / 'executive-one-slide.png'
    fig.savefig(print_path, dpi=300, bbox_inches='tight',
                facecolor=COLORS['white'], edgecolor='none')
    print(f"✅ Saved: {print_path}")
    
    # Web-optimized
    web_path = output_dir / 'executive-one-slide-web.png'
    fig.savefig(web_path, dpi=150, bbox_inches='tight',
                facecolor=COLORS['white'], edgecolor='none')
    print(f"✅ Saved: {web_path}")


def main():
    print("🎨 Generating Executive One-Slide Summary...")
    print("-" * 50)
    
    script_dir = Path(__file__).parent
    output_dir = script_dir / 'generated'
    
    fig = create_one_slide()
    save_slide(fig, output_dir)
    
    print("-" * 50)
    print("✨ Complete!")
    
    plt.close(fig)


if __name__ == '__main__':
    main()
