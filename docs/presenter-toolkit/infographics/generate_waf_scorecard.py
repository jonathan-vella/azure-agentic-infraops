#!/usr/bin/env python3
"""
Agentic InfraOps - WAF Scorecard Generator

Creates a professional radar chart showing Well-Architected Framework alignment
with scores for each of the 5 WAF pillars.

Requirements:
    pip install matplotlib numpy

Usage:
    python generate_waf_scorecard.py

Output:
    - waf-scorecard.png (high-res for presentations)
    - waf-scorecard-web.png (optimized for web)
"""

import matplotlib.pyplot as plt
import matplotlib.patches as patches
from matplotlib.patches import FancyBboxPatch, Circle, Wedge
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
    # WAF pillar colors
    'security': '#D13438',     # Red
    'reliability': '#0078D4',  # Blue
    'performance': '#107C10',  # Green
    'cost': '#FFB900',         # Yellow
    'operations': '#5C2D91',   # Purple
}

# WAF Pillar data
WAF_PILLARS = [
    {'name': 'Security', 'score': 9, 'color': COLORS['security'], 'icon': '🔒'},
    {'name': 'Reliability', 'score': 8, 'color': COLORS['reliability'], 'icon': '🛡️'},
    {'name': 'Performance', 'score': 8, 'color': COLORS['performance'], 'icon': '⚡'},
    {'name': 'Cost Optimization', 'score': 7, 'color': COLORS['cost'], 'icon': '💰'},
    {'name': 'Operational Excellence', 'score': 8, 'color': COLORS['operations'], 'icon': '⚙️'},
]


def create_waf_scorecard():
    """Generate the WAF scorecard with radar chart."""
    
    # Create figure
    fig = plt.figure(figsize=(12, 8), facecolor=COLORS['white'])
    
    # Main axes for the radar chart
    ax_radar = fig.add_axes([0.25, 0.15, 0.5, 0.7], polar=True)
    
    # Overlay axes for decorations
    ax = fig.add_axes([0, 0, 1, 1])
    ax.set_xlim(0, 12)
    ax.set_ylim(0, 8)
    ax.axis('off')
    
    # === HEADER ===
    ax.text(6, 7.5, 'Well-Architected Framework Alignment', fontsize=20, fontweight='bold',
            color=COLORS['primary'], ha='center', va='center')
    ax.text(6, 7.0, 'Agentic InfraOps generates WAF-aligned infrastructure', fontsize=11,
            color=COLORS['dark'], ha='center', va='center', style='italic')
    
    # === RADAR CHART ===
    # Number of pillars
    N = len(WAF_PILLARS)
    
    # Angles for each pillar (evenly spaced)
    angles = [n / float(N) * 2 * np.pi for n in range(N)]
    angles += angles[:1]  # Complete the loop
    
    # Scores (normalized to 0-10)
    scores = [p['score'] for p in WAF_PILLARS]
    scores += scores[:1]  # Complete the loop
    
    # Max score line (10)
    max_scores = [10] * N
    max_scores += max_scores[:1]
    
    # Configure radar chart
    ax_radar.set_theta_offset(np.pi / 2)  # Start from top
    ax_radar.set_theta_direction(-1)  # Clockwise
    
    # Draw the outline (max score boundary)
    ax_radar.plot(angles, max_scores, 'o-', linewidth=1, color=COLORS['light'], alpha=0.5)
    ax_radar.fill(angles, max_scores, alpha=0.1, color=COLORS['light'])
    
    # Draw the actual scores
    ax_radar.plot(angles, scores, 'o-', linewidth=3, color=COLORS['primary'])
    ax_radar.fill(angles, scores, alpha=0.25, color=COLORS['primary'])
    
    # Add score points with pillar colors
    for i, pillar in enumerate(WAF_PILLARS):
        ax_radar.plot(angles[i], scores[i], 'o', markersize=12, 
                     color=pillar['color'], markeredgecolor='white', markeredgewidth=2)
    
    # Set labels
    ax_radar.set_xticks(angles[:-1])
    ax_radar.set_xticklabels([])  # We'll add custom labels
    
    # Set radial limits
    ax_radar.set_ylim(0, 10)
    ax_radar.set_yticks([2, 4, 6, 8, 10])
    ax_radar.set_yticklabels(['2', '4', '6', '8', '10'], fontsize=8, color=COLORS['dark'])
    
    # Add grid
    ax_radar.grid(True, color=COLORS['light'], linestyle='-', linewidth=0.5)
    
    # === PILLAR LABELS (around the radar) ===
    label_positions = [
        (6, 6.3),      # Security (top)
        (9.5, 4.5),    # Reliability (right)
        (8.5, 1.5),    # Performance (bottom-right)
        (3.5, 1.5),    # Cost (bottom-left)
        (2.5, 4.5),    # Operations (left)
    ]
    
    for i, pillar in enumerate(WAF_PILLARS):
        x, y = label_positions[i]
        
        # Pillar name with icon
        ax.text(x, y, f"{pillar['icon']} {pillar['name']}", fontsize=10, fontweight='bold',
                color=pillar['color'], ha='center', va='center')
        
        # Score badge
        ax.text(x, y - 0.35, f"{pillar['score']}/10", fontsize=9,
                color=COLORS['dark'], ha='center', va='center',
                bbox=dict(boxstyle='round,pad=0.2', facecolor='white', 
                         edgecolor=pillar['color'], linewidth=1.5))
    
    # === OVERALL SCORE BADGE ===
    # Large circle for overall score
    overall_score = sum(p['score'] for p in WAF_PILLARS) / len(WAF_PILLARS)
    
    circle = Circle((10.5, 6.5), 0.8, facecolor=COLORS['primary'], edgecolor='white', linewidth=3)
    ax.add_patch(circle)
    ax.text(10.5, 6.7, f"{overall_score:.1f}", fontsize=24, fontweight='bold',
            color='white', ha='center', va='center')
    ax.text(10.5, 6.2, '/10', fontsize=12, color='white', ha='center', va='center')
    ax.text(10.5, 5.5, 'Overall WAF\nScore', fontsize=9, fontweight='bold',
            color=COLORS['primary'], ha='center', va='center')
    
    # === LEGEND / KEY ===
    ax.text(1.5, 6.5, 'Score Legend', fontsize=10, fontweight='bold',
            color=COLORS['dark'], ha='center', va='center')
    
    legend_items = [
        ('9-10', 'Excellent', COLORS['success']),
        ('7-8', 'Good', COLORS['primary']),
        ('5-6', 'Needs Work', COLORS['warning']),
        ('1-4', 'Critical', COLORS['danger']),
    ]
    
    for i, (score, label, color) in enumerate(legend_items):
        y = 6.0 - i * 0.4
        ax.add_patch(FancyBboxPatch((0.5, y - 0.12), 0.4, 0.24,
                                    boxstyle="round,pad=0.02,rounding_size=0.05",
                                    facecolor=color, edgecolor='none'))
        ax.text(1.1, y, f"{score}: {label}", fontsize=8, color=COLORS['dark'],
                ha='left', va='center')
    
    # === FOOTER ===
    ax.text(6, 0.3, 'Generated by Agentic InfraOps  •  aka.ms/agenticinfraops', 
            fontsize=9, color=COLORS['dark'], ha='center', va='center', style='italic')
    
    # Azure WAF badge
    ax.text(10.5, 0.5, '🏛️ Azure Well-Architected', fontsize=8, fontweight='bold',
            color=COLORS['primary'], ha='center', va='center')
    
    return fig


def main():
    """Generate and save the WAF scorecard."""
    output_dir = Path(__file__).parent / 'generated'
    output_dir.mkdir(exist_ok=True)
    
    print("🎨 Generating WAF Scorecard...")
    
    fig = create_waf_scorecard()
    
    # Save high-res PNG (for presentations)
    fig.savefig(output_dir / 'waf-scorecard.png', dpi=300, 
                bbox_inches='tight', facecolor='white', edgecolor='none')
    print(f"  ✅ Saved: {output_dir / 'waf-scorecard.png'}")
    
    # Save web-optimized version
    fig.savefig(output_dir / 'waf-scorecard-web.png', dpi=150,
                bbox_inches='tight', facecolor='white', edgecolor='none')
    print(f"  ✅ Saved: {output_dir / 'waf-scorecard-web.png'}")
    
    plt.close(fig)
    print("✅ WAF scorecard generation complete!")


if __name__ == '__main__':
    main()
