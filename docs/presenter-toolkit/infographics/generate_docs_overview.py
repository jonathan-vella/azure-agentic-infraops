#!/usr/bin/env python3
"""
Documentation Overview Infographic Generator

This script generates an infographic showing the documentation structure
and navigation paths for the GitHub Copilot IT Pro repository.

Requirements:
    pip install matplotlib numpy pillow

Usage:
    python generate_docs_overview.py

Output:
    - docs-overview-infographic.png (high-res)
    - docs-overview-infographic-web.png (web optimized)
"""

import matplotlib.pyplot as plt
import matplotlib.patches as patches
from matplotlib.patches import FancyBboxPatch, FancyArrowPatch, Circle, ConnectionPatch
import numpy as np
from pathlib import Path

# Color palette
COLORS = {
    'primary': '#0078D4',      # Azure blue
    'secondary': '#50E6FF',    # Light azure
    'accent': '#00B294',       # Teal
    'success': '#107C10',      # Green
    'warning': '#FFB900',      # Yellow
    'purple': '#8764B8',       # Purple
    'orange': '#F7630C',       # Orange
    'dark': '#201F1E',         # Near black
    'light': '#F3F2F1',        # Light gray
    'white': '#FFFFFF',
}


def create_docs_overview():
    """Generate the documentation overview infographic."""
    
    # Create figure (landscape for overview)
    fig = plt.figure(figsize=(16, 10), facecolor=COLORS['white'])
    ax = fig.add_axes([0, 0, 1, 1])
    ax.set_xlim(0, 16)
    ax.set_ylim(0, 10)
    ax.axis('off')
    
    # === HEADER ===
    header_bg = FancyBboxPatch(
        (0, 9), 16, 1,
        boxstyle="square,pad=0",
        facecolor=COLORS['primary'],
        edgecolor='none'
    )
    ax.add_patch(header_bg)
    
    ax.text(8, 9.6, 'Documentation Navigator', 
            fontsize=28, fontweight='bold', color=COLORS['white'],
            ha='center', va='center')
    ax.text(8, 9.2, 'Find the Right Resource for Your Audience', 
            fontsize=14, color=COLORS['secondary'],
            ha='center', va='center')
    
    # === AUDIENCE PATHS (Top Row) ===
    audiences = [
        ('IT Pros', 'Learn & Build', COLORS['primary'], 'the-itpro-copilot-story.md'),
        ('Executives', 'Pitch & Approve', COLORS['purple'], 'executive-pitch.md'),
        ('Skeptics', 'Verify & Validate', COLORS['success'], 'time-savings-evidence.md'),
        ('Partners', 'Demo & Sell', COLORS['orange'], 'Presenter Toolkit'),
    ]
    
    x_positions = [2, 6, 10, 14]
    
    for i, (audience, action, color, doc) in enumerate(audiences):
        x = x_positions[i]
        
        # Audience circle
        circle = Circle((x, 7.8), 0.5, facecolor=color, edgecolor='none')
        ax.add_patch(circle)
        
        # Icon placeholder (using first letter)
        ax.text(x, 7.8, audience[0], fontsize=20, fontweight='bold',
                color=COLORS['white'], ha='center', va='center')
        
        # Labels
        ax.text(x, 7.0, audience, fontsize=12, fontweight='bold',
                color=COLORS['dark'], ha='center', va='center')
        ax.text(x, 6.6, action, fontsize=10, color=color,
                ha='center', va='center', style='italic')
        
        # Document card
        card = FancyBboxPatch(
            (x - 1.5, 5.3), 3, 1.0,
            boxstyle="round,pad=0.03,rounding_size=0.1",
            facecolor=COLORS['white'],
            edgecolor=color,
            linewidth=2
        )
        ax.add_patch(card)
        
        # Truncate long doc names
        display_doc = doc if len(doc) < 25 else doc[:22] + '...'
        ax.text(x, 5.8, display_doc, fontsize=9, fontweight='bold',
                color=COLORS['dark'], ha='center', va='center')
        
        # Arrow from circle to card
        arrow = FancyArrowPatch(
            (x, 7.25), (x, 6.35),
            arrowstyle='->,head_length=0.15,head_width=0.1',
            color=color,
            linewidth=2
        )
        ax.add_patch(arrow)
    
    # === DOCUMENT TYPES (Middle Section) ===
    ax.text(8, 4.6, 'Document Types', 
            fontsize=16, fontweight='bold', color=COLORS['dark'],
            ha='center', va='center')
    
    doc_types = [
        ('Narrative Story', '10-15 min', 'Engaging story format', COLORS['primary']),
        ('Executive Pitch', '5 min', 'Quick decision support', COLORS['purple']),
        ('Evidence Base', 'Reference', 'Research & methodology', COLORS['success']),
        ('Toolkit', 'Practical', 'Templates & tools', COLORS['orange']),
    ]
    
    for i, (dtype, duration, desc, color) in enumerate(doc_types):
        x = x_positions[i]
        
        # Type box
        box = FancyBboxPatch(
            (x - 1.5, 3.3), 3, 1.0,
            boxstyle="round,pad=0.03,rounding_size=0.1",
            facecolor=color,
            edgecolor='none',
            alpha=0.15
        )
        ax.add_patch(box)
        
        ax.text(x, 4.0, dtype, fontsize=10, fontweight='bold',
                color=color, ha='center', va='center')
        ax.text(x, 3.7, duration, fontsize=9, color=COLORS['dark'],
                ha='center', va='center')
        ax.text(x, 3.45, desc, fontsize=8, color=COLORS['dark'],
                ha='center', va='center', style='italic')
    
    # === RESOURCES SECTION (Bottom) ===
    resources_bg = FancyBboxPatch(
        (0.5, 0.8), 15, 2.2,
        boxstyle="round,pad=0.05,rounding_size=0.15",
        facecolor=COLORS['light'],
        edgecolor='none'
    )
    ax.add_patch(resources_bg)
    
    ax.text(8, 2.7, 'Supporting Resources', 
            fontsize=14, fontweight='bold', color=COLORS['dark'],
            ha='center', va='center')
    
    resources = [
        ('ROI Calculator', 'Calculate savings', '$'),
        ('Pilot Checklist', 'Plan evaluation', '✓'),
        ('Infographics', 'Visual assets', '📊'),
        ('Demo Guide', 'Presentation tips', '🎤'),
        ('Scenarios', 'Hands-on learning', '🧪'),
    ]
    
    x_start = 1.5
    x_gap = 2.8
    
    for i, (name, desc, icon) in enumerate(resources):
        x = x_start + (i * x_gap)
        
        # Resource card
        card = FancyBboxPatch(
            (x - 1.1, 1.0), 2.4, 1.4,
            boxstyle="round,pad=0.03,rounding_size=0.1",
            facecolor=COLORS['white'],
            edgecolor=COLORS['primary'],
            linewidth=1.5
        )
        ax.add_patch(card)
        
        ax.text(x + 0.1, 2.05, icon, fontsize=14, ha='center', va='center')
        ax.text(x + 0.1, 1.65, name, fontsize=9, fontweight='bold',
                color=COLORS['dark'], ha='center', va='center')
        ax.text(x + 0.1, 1.35, desc, fontsize=8, color=COLORS['dark'],
                ha='center', va='center')
    
    # === FOOTER ===
    ax.text(8, 0.4, 'github.com/jonathan-vella/github-copilot-itpro/docs', 
            fontsize=10, color=COLORS['dark'], style='italic',
            ha='center', va='center')
    
    return fig


def save_infographic(fig, output_dir: Path):
    """Save the infographic in multiple formats."""
    
    output_dir.mkdir(parents=True, exist_ok=True)
    
    # High-res
    print_path = output_dir / 'docs-overview-infographic.png'
    fig.savefig(print_path, dpi=300, bbox_inches='tight',
                facecolor=COLORS['white'], edgecolor='none')
    print(f"✅ Saved: {print_path}")
    
    # Web-optimized
    web_path = output_dir / 'docs-overview-infographic-web.png'
    fig.savefig(web_path, dpi=150, bbox_inches='tight',
                facecolor=COLORS['white'], edgecolor='none')
    print(f"✅ Saved: {web_path}")


def main():
    """Main entry point."""
    print("🎨 Generating Documentation Overview Infographic...")
    print("-" * 50)
    
    script_dir = Path(__file__).parent
    output_dir = script_dir / 'generated'
    
    fig = create_docs_overview()
    save_infographic(fig, output_dir)
    
    print("-" * 50)
    print("✨ Complete!")
    
    plt.close(fig)


if __name__ == '__main__':
    main()
