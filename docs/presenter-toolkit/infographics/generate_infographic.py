#!/usr/bin/env python3
"""
GitHub Copilot for IT Pros - Time Savings Infographic Generator

This script generates a professional infographic showing time savings
data from GitHub Copilot adoption for IT Professionals.

Requirements:
    pip install matplotlib numpy pillow

Usage:
    python generate_infographic.py

Output:
    - time-savings-infographic.png (high-res for print)
    - time-savings-infographic-web.png (optimized for web)
"""

import matplotlib.pyplot as plt
import matplotlib.patches as patches
from matplotlib.patches import FancyBboxPatch, Circle
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
    'dark': '#201F1E',         # Near black
    'light': '#F3F2F1',        # Light gray
    'white': '#FFFFFF',
    'gradient_start': '#0078D4',
    'gradient_end': '#50E6FF',
}

def create_infographic():
    """Generate the main infographic."""
    
    # Create figure with specific dimensions (portrait, poster-style)
    fig = plt.figure(figsize=(12, 18), facecolor=COLORS['white'])
    
    # Remove axes
    ax = fig.add_axes([0, 0, 1, 1])
    ax.set_xlim(0, 12)
    ax.set_ylim(0, 18)
    ax.axis('off')
    
    # === HEADER SECTION ===
    # Background rectangle for header
    header_bg = FancyBboxPatch(
        (0, 16), 12, 2,
        boxstyle="square,pad=0",
        facecolor=COLORS['primary'],
        edgecolor='none'
    )
    ax.add_patch(header_bg)
    
    # Title
    ax.text(6, 17.2, 'GitHub Copilot for IT Pros', 
            fontsize=28, fontweight='bold', color=COLORS['white'],
            ha='center', va='center')
    ax.text(6, 16.5, 'Time Savings at a Glance', 
            fontsize=18, color=COLORS['secondary'],
            ha='center', va='center')
    
    # === HEADLINE STAT ===
    ax.text(6, 15.2, '80-85%', 
            fontsize=72, fontweight='bold', color=COLORS['primary'],
            ha='center', va='center')
    ax.text(6, 14.4, 'Average Time Saved on Infrastructure Tasks', 
            fontsize=14, color=COLORS['dark'],
            ha='center', va='center')
    
    # === TASK BREAKDOWN SECTION ===
    ax.text(6, 13.5, 'Time Savings by Task Type', 
            fontsize=16, fontweight='bold', color=COLORS['dark'],
            ha='center', va='center')
    
    # Task data
    tasks = [
        ('IaC Development', 45, 10, '78%'),
        ('Automation Scripts', 60, 15, '75%'),
        ('Troubleshooting', 30, 5, '83%'),
        ('Documentation', 120, 20, '83%'),
    ]
    
    y_pos = 12.8
    for task, before, after, savings in tasks:
        # Task label
        ax.text(1, y_pos, task, fontsize=11, color=COLORS['dark'], va='center')
        
        # Before bar (gray)
        before_width = before / 20  # Scale factor
        bar_before = FancyBboxPatch(
            (4.5, y_pos - 0.15), before_width, 0.3,
            boxstyle="round,pad=0.02,rounding_size=0.1",
            facecolor=COLORS['light'],
            edgecolor=COLORS['dark'],
            linewidth=0.5
        )
        ax.add_patch(bar_before)
        ax.text(4.5 + before_width + 0.1, y_pos, f'{before} min', 
                fontsize=9, color=COLORS['dark'], va='center')
        
        # After bar (green)
        after_width = after / 20
        bar_after = FancyBboxPatch(
            (4.5, y_pos - 0.55), after_width, 0.3,
            boxstyle="round,pad=0.02,rounding_size=0.1",
            facecolor=COLORS['success'],
            edgecolor='none'
        )
        ax.add_patch(bar_after)
        ax.text(4.5 + after_width + 0.1, y_pos - 0.4, f'{after} min', 
                fontsize=9, color=COLORS['success'], fontweight='bold', va='center')
        
        # Savings badge
        badge = Circle((11, y_pos - 0.2), 0.4, 
                       facecolor=COLORS['accent'], edgecolor='none')
        ax.add_patch(badge)
        ax.text(11, y_pos - 0.2, savings, 
                fontsize=10, fontweight='bold', color=COLORS['white'],
                ha='center', va='center')
        
        y_pos -= 1.2
    
    # Legend
    ax.add_patch(FancyBboxPatch((4.5, 8.3), 0.3, 0.2, 
                                boxstyle="round,pad=0.02", 
                                facecolor=COLORS['light'], edgecolor=COLORS['dark'], linewidth=0.5))
    ax.text(4.9, 8.4, 'Before Copilot', fontsize=9, color=COLORS['dark'], va='center')
    ax.add_patch(FancyBboxPatch((7, 8.3), 0.3, 0.2, 
                                boxstyle="round,pad=0.02", 
                                facecolor=COLORS['success'], edgecolor='none'))
    ax.text(7.4, 8.4, 'With Copilot', fontsize=9, color=COLORS['dark'], va='center')
    
    # === PROJECT SHOWCASE ===
    ax.text(6, 7.6, 'Real Projects Built by Non-Developers', 
            fontsize=16, fontweight='bold', color=COLORS['dark'],
            ha='center', va='center')
    
    projects = [
        ('SAIF', '3-tier security app', '3-4 mo', '3 wks', '85%'),
        ('PostgreSQL HA', 'K8s automation', '2-3 mo', '2 wks', '83%'),
        ('Brain Trek', '16-module curriculum', '2-3 mo', '3 wks', '80%'),
    ]
    
    x_positions = [2, 6, 10]
    for i, (name, desc, before, after, savings) in enumerate(projects):
        x = x_positions[i]
        
        # Project card
        card = FancyBboxPatch(
            (x - 1.5, 5.5), 3, 1.8,
            boxstyle="round,pad=0.05,rounding_size=0.15",
            facecolor=COLORS['white'],
            edgecolor=COLORS['primary'],
            linewidth=2
        )
        ax.add_patch(card)
        
        ax.text(x, 6.9, name, fontsize=12, fontweight='bold', 
                color=COLORS['primary'], ha='center', va='center')
        ax.text(x, 6.5, desc, fontsize=9, color=COLORS['dark'], 
                ha='center', va='center')
        ax.text(x, 6.0, f'{before} → {after}', fontsize=10, 
                color=COLORS['dark'], ha='center', va='center')
        
        # Savings highlight
        ax.text(x, 5.7, savings + ' faster', fontsize=11, fontweight='bold',
                color=COLORS['success'], ha='center', va='center')
    
    # === RESEARCH BACKING ===
    research_bg = FancyBboxPatch(
        (0.5, 3.8), 11, 1.4,
        boxstyle="round,pad=0.05,rounding_size=0.15",
        facecolor=COLORS['light'],
        edgecolor='none'
    )
    ax.add_patch(research_bg)
    
    ax.text(6, 4.9, 'Backed by Independent Research', 
            fontsize=14, fontweight='bold', color=COLORS['dark'],
            ha='center', va='center')
    
    research = [
        ('Stanford HAI', '60-70%'),
        ('Forrester TEI', '88%'),
        ('MIT Sloan', '80%'),
        ('McKinsey', '85-95%'),
    ]
    
    x_positions = [1.8, 4.4, 7, 9.6]
    for i, (source, finding) in enumerate(research):
        x = x_positions[i]
        ax.text(x, 4.4, finding, fontsize=14, fontweight='bold',
                color=COLORS['primary'], ha='center', va='center')
        ax.text(x, 4.1, source, fontsize=8, color=COLORS['dark'],
                ha='center', va='center')
    
    # === BOTTOM CTA ===
    cta_bg = FancyBboxPatch(
        (0, 0), 12, 3.5,
        boxstyle="square,pad=0",
        facecolor=COLORS['primary'],
        edgecolor='none'
    )
    ax.add_patch(cta_bg)
    
    ax.text(6, 2.8, 'Start Your Pilot Today', 
            fontsize=20, fontweight='bold', color=COLORS['white'],
            ha='center', va='center')
    
    ax.text(6, 2.2, '$19/user/month  •  Break-even in Week 1  •  No process changes', 
            fontsize=12, color=COLORS['secondary'],
            ha='center', va='center')
    
    ax.text(6, 1.4, 'github.com/jonathan-vella/github-copilot-itpro', 
            fontsize=11, color=COLORS['white'],
            ha='center', va='center', style='italic')
    
    ax.text(6, 0.6, 'The Efficiency Multiplier for IT Professionals', 
            fontsize=10, color=COLORS['secondary'],
            ha='center', va='center')
    
    return fig


def save_infographic(fig, output_dir: Path):
    """Save the infographic in multiple formats."""
    
    output_dir.mkdir(parents=True, exist_ok=True)
    
    # High-res for print (300 DPI)
    print_path = output_dir / 'time-savings-infographic.png'
    fig.savefig(print_path, dpi=300, bbox_inches='tight', 
                facecolor=COLORS['white'], edgecolor='none')
    print(f"✅ Saved print version: {print_path}")
    
    # Web-optimized (150 DPI)
    web_path = output_dir / 'time-savings-infographic-web.png'
    fig.savefig(web_path, dpi=150, bbox_inches='tight',
                facecolor=COLORS['white'], edgecolor='none')
    print(f"✅ Saved web version: {web_path}")
    
    # PDF for presentations
    pdf_path = output_dir / 'time-savings-infographic.pdf'
    fig.savefig(pdf_path, format='pdf', bbox_inches='tight',
                facecolor=COLORS['white'], edgecolor='none')
    print(f"✅ Saved PDF version: {pdf_path}")


def main():
    """Main entry point."""
    print("🎨 Generating GitHub Copilot Time Savings Infographic...")
    print("-" * 50)
    
    # Determine output directory
    script_dir = Path(__file__).parent
    output_dir = script_dir / 'generated'
    
    # Create infographic
    fig = create_infographic()
    
    # Save in multiple formats
    save_infographic(fig, output_dir)
    
    print("-" * 50)
    print("✨ Infographic generation complete!")
    print(f"📁 Output directory: {output_dir}")
    
    # Close figure to free memory
    plt.close(fig)


if __name__ == '__main__':
    main()
