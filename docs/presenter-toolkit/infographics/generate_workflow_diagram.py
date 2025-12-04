#!/usr/bin/env python3
"""
Agentic InfraOps - 4-Step Agent Workflow Diagram Generator

Creates a professional diagram showing the core agent workflow:
@plan → azure-principal-architect → bicep-plan → bicep-implement

Requirements:
    pip install matplotlib numpy

Usage:
    python generate_workflow_diagram.py

Output:
    - workflow-diagram.png (high-res for presentations)
    - workflow-diagram-web.png (optimized for web)
"""

import matplotlib.pyplot as plt
import matplotlib.patches as patches
from matplotlib.patches import FancyBboxPatch, Circle
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
    # Step-specific colors
    'step1': '#E1F5FE',        # Light blue (requirements)
    'step2': '#FFF3E0',        # Light orange (architecture)
    'step3': '#E8F5E9',        # Light green (planning)
    'step4': '#FCE4EC',        # Light pink (implementation)
    'step1_border': '#0078D4',
    'step2_border': '#D83B01',
    'step3_border': '#107C10',
    'step4_border': '#5C2D91',
}


def create_workflow_diagram():
    """Generate the 4-step workflow diagram."""
    
    # Create figure (landscape, presentation-friendly)
    fig = plt.figure(figsize=(16, 9), facecolor=COLORS['white'])
    ax = fig.add_axes([0, 0, 1, 1])
    ax.set_xlim(0, 16)
    ax.set_ylim(0, 9)
    ax.axis('off')
    
    # === HEADER ===
    ax.text(8, 8.3, 'Agentic InfraOps', fontsize=28, fontweight='bold',
            color=COLORS['primary'], ha='center', va='center')
    ax.text(8, 7.7, 'Azure infrastructure engineered by agents', fontsize=14,
            color=COLORS['dark'], ha='center', va='center', style='italic')
    
    # === MAIN WORKFLOW STEPS ===
    step_width = 3.0
    step_height = 2.8
    step_y = 4.2
    gap = 0.5
    start_x = 0.8
    
    steps = [
        {
            'num': '1',
            'title': '@plan',
            'subtitle': 'Requirements',
            'agent': 'Built-in Plan Agent',
            'desc': ['Gather requirements', 'Create implementation plan', 'Cost estimation'],
            'color': COLORS['step1'],
            'border': COLORS['step1_border'],
            'icon': '📋'
        },
        {
            'num': '2',
            'title': 'azure-principal-\narchitect',
            'subtitle': 'Architecture',
            'agent': 'Custom Agent',
            'desc': ['WAF assessment', 'Security review', 'NO CODE output'],
            'color': COLORS['step2'],
            'border': COLORS['step2_border'],
            'icon': '🏗️'
        },
        {
            'num': '3',
            'title': 'bicep-plan',
            'subtitle': 'Planning',
            'agent': 'Custom Agent',
            'desc': ['AVM module selection', 'Resource dependencies', 'Implementation plan'],
            'color': COLORS['step3'],
            'border': COLORS['step3_border'],
            'icon': '📝'
        },
        {
            'num': '4',
            'title': 'bicep-implement',
            'subtitle': 'Implementation',
            'agent': 'Custom Agent',
            'desc': ['Generate Bicep code', 'Validate with lint', 'Deploy-ready templates'],
            'color': COLORS['step4'],
            'border': COLORS['step4_border'],
            'icon': '⚙️'
        }
    ]
    
    for i, step in enumerate(steps):
        x = start_x + i * (step_width + gap)
        
        # Step box
        box = FancyBboxPatch((x, step_y - step_height/2), step_width, step_height,
                             boxstyle="round,pad=0.05,rounding_size=0.2",
                             facecolor=step['color'], edgecolor=step['border'],
                             linewidth=3, transform=ax.transData)
        ax.add_patch(box)
        
        # Step number badge
        circle = Circle((x + 0.35, step_y + step_height/2 - 0.35), 0.25,
                        facecolor=step['border'], edgecolor='white', linewidth=2)
        ax.add_patch(circle)
        ax.text(x + 0.35, step_y + step_height/2 - 0.35, step['num'],
                fontsize=14, fontweight='bold', color='white',
                ha='center', va='center')
        
        # Icon
        ax.text(x + step_width/2, step_y + 0.9, step['icon'],
                fontsize=24, ha='center', va='center')
        
        # Title
        ax.text(x + step_width/2, step_y + 0.35, step['title'],
                fontsize=11, fontweight='bold', color=step['border'],
                ha='center', va='center', family='monospace')
        
        # Subtitle
        ax.text(x + step_width/2, step_y - 0.15, step['subtitle'],
                fontsize=12, fontweight='bold', color=COLORS['dark'],
                ha='center', va='center')
        
        # Agent type badge
        badge_color = COLORS['primary'] if 'Built-in' in step['agent'] else COLORS['purple']
        ax.text(x + step_width/2, step_y - 0.5, step['agent'],
                fontsize=8, color=badge_color, ha='center', va='center',
                bbox=dict(boxstyle='round,pad=0.2', facecolor='white', 
                         edgecolor=badge_color, linewidth=1))
        
        # Description bullets
        for j, desc in enumerate(step['desc']):
            ax.text(x + 0.25, step_y - 0.85 - j*0.3, f"• {desc}",
                    fontsize=9, color=COLORS['dark'], ha='left', va='center')
        
        # Arrow to next step
        if i < len(steps) - 1:
            arrow_x = x + step_width + 0.08
            ax.annotate('', xy=(arrow_x + gap - 0.16, step_y),
                       xytext=(arrow_x, step_y),
                       arrowprops=dict(arrowstyle='->', color=COLORS['primary'],
                                      lw=3, mutation_scale=20))
            # "Approve" label above arrow
            ax.text(arrow_x + gap/2 - 0.04, step_y + 0.35, '✓ Approve',
                    fontsize=8, color=COLORS['success'], ha='center', va='center',
                    fontweight='bold')
    
    # === OPTIONAL INTEGRATIONS (below main flow) ===
    ax.text(8, 1.9, 'Optional Integrations (During Architecture Phase)', fontsize=12,
            fontweight='bold', color=COLORS['dark'], ha='center', va='center')
    
    integrations = [
        {'name': '💰 Azure Pricing MCP', 'desc': 'Real-time cost estimates', 'x': 3.5},
        {'name': '📊 diagram-generator', 'desc': 'Architecture visualization', 'x': 8},
        {'name': '📝 adr-generator', 'desc': 'Decision documentation', 'x': 12.5},
    ]
    
    for integ in integrations:
        box = FancyBboxPatch((integ['x'] - 1.5, 0.6), 3.0, 1.0,
                             boxstyle="round,pad=0.05,rounding_size=0.15",
                             facecolor=COLORS['light'], edgecolor=COLORS['secondary'],
                             linewidth=2, linestyle='--', transform=ax.transData)
        ax.add_patch(box)
        ax.text(integ['x'], 1.25, integ['name'], fontsize=10, fontweight='bold',
                color=COLORS['primary'], ha='center', va='center')
        ax.text(integ['x'], 0.9, integ['desc'], fontsize=9,
                color=COLORS['dark'], ha='center', va='center')
    
    # Dashed lines connecting to Step 2
    step2_x = start_x + 1 * (step_width + gap) + step_width/2
    step2_bottom = step_y - step_height/2
    
    for integ in integrations:
        ax.plot([integ['x'], integ['x']], [1.6, 2.3], 
                color=COLORS['secondary'], linewidth=1.5, linestyle='--', alpha=0.7)
    ax.plot([3.5, 12.5], [2.3, 2.3],
            color=COLORS['secondary'], linewidth=1.5, linestyle='--', alpha=0.7)
    ax.plot([step2_x, step2_x], [2.3, step2_bottom],
            color=COLORS['secondary'], linewidth=1.5, linestyle='--', alpha=0.7)
    
    # === FOOTER ===
    ax.text(8, 0.2, 'aka.ms/agenticinfraops', fontsize=10, 
            color=COLORS['dark'], ha='center', va='center', style='italic')
    
    return fig


def main():
    """Generate and save the workflow diagram."""
    output_dir = Path(__file__).parent / 'generated'
    output_dir.mkdir(exist_ok=True)
    
    print("🎨 Generating 4-Step Workflow Diagram...")
    
    fig = create_workflow_diagram()
    
    # Save high-res PNG (for presentations)
    fig.savefig(output_dir / 'workflow-diagram.png', dpi=300, 
                bbox_inches='tight', facecolor='white', edgecolor='none')
    print(f"  ✅ Saved: {output_dir / 'workflow-diagram.png'}")
    
    # Save web-optimized version
    fig.savefig(output_dir / 'workflow-diagram-web.png', dpi=150,
                bbox_inches='tight', facecolor='white', edgecolor='none')
    print(f"  ✅ Saved: {output_dir / 'workflow-diagram-web.png'}")
    
    # Save PDF for vector quality
    fig.savefig(output_dir / 'workflow-diagram.pdf',
                bbox_inches='tight', facecolor='white', edgecolor='none')
    print(f"  ✅ Saved: {output_dir / 'workflow-diagram.pdf'}")
    
    plt.close(fig)
    print("✅ Workflow diagram generation complete!")


if __name__ == '__main__':
    main()
