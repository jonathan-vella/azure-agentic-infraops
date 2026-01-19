#!/usr/bin/env python3
"""
Agentic InfraOps - 7-Step Agent Workflow Diagram Generator

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
    """Generate the 7-step workflow diagram."""

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
    step_width = 2.2
    step_height = 2.6
    step_y = 4.2
    gap = 0.35
    start_x = 0.6

    steps = [
        {
            'num': '1',
            'title': 'project-\nplanner',
            'subtitle': 'Requirements',
            'agent': 'Custom Agent',
            'desc': ['Gather requirements', 'NFR capture'],
            'color': COLORS['step1'],
            'border': COLORS['step1_border'],
            'icon': '📋'
        },
        {
            'num': '2',
            'title': 'azure-principal-\narchitect',
            'subtitle': 'Architecture',
            'agent': 'Custom Agent',
            'desc': ['WAF assessment', 'NO CODE output'],
            'color': COLORS['step2'],
            'border': COLORS['step2_border'],
            'icon': '🏗️'
        },
        {
            'num': '3',
            'title': 'Design\nArtifacts',
            'subtitle': '-des suffix',
            'agent': 'Optional',
            'desc': ['Design diagrams', 'Decision ADRs'],
            'color': '#F3E5F5',  # Light purple
            'border': '#7B1FA2',
            'icon': '📊'
        },
        {
            'num': '4',
            'title': 'bicep-plan',
            'subtitle': 'Planning',
            'agent': 'Custom Agent',
            'desc': ['Governance discovery', 'AVM modules'],
            'color': COLORS['step3'],
            'border': COLORS['step3_border'],
            'icon': '📝'
        },
        {
            'num': '5',
            'title': 'bicep-\nimplement',
            'subtitle': 'Implementation',
            'agent': 'Custom Agent',
            'desc': ['Generate Bicep', 'Validate & deploy'],
            'color': COLORS['step4'],
            'border': COLORS['step4_border'],
            'icon': '⚙️'
        },
        {
            'num': '6',
            'title': 'deploy',
            'subtitle': 'To Azure',
            'agent': 'Custom Agent',
            'desc': ['What-if analysis', 'Deploy resources'],
            'color': '#FFF3E0',  # Light orange
            'border': '#F57C00',
            'icon': '🚀'
        },
        {
            'num': '7',
            'title': 'workload-docs\n+ diagrams',
            'subtitle': 'As-Built',
            'agent': 'Custom Agents',
            'desc': ['Runbooks, inventory', 'As-built diagrams'],
            'color': '#E3F2FD',  # Light blue
            'border': '#1976D2',
            'icon': '📚'
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
    ax.text(8, 1.9, 'Automatic Integrations', fontsize=12,
            fontweight='bold', color=COLORS['dark'], ha='center', va='center')

    integrations = [
        {'name': '💰 Azure Pricing MCP',
            'desc': 'Real-time costs (Steps 2, 4)', 'x': 4},
        {'name': '🔒 Azure Policy',
            'desc': 'Governance discovery (Step 4)', 'x': 8},
        {'name': '✅ Bicep Validation',
            'desc': 'Build & lint (Step 5)', 'x': 12},
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

    # Dashed lines connecting integrations to workflow
    step2_x = start_x + 1 * (step_width + gap) + step_width/2
    step4_x = start_x + 3 * (step_width + gap) + step_width/2
    step5_x = start_x + 4 * (step_width + gap) + step_width/2
    step_bottom = step_y - step_height/2

    for integ in integrations:
        ax.plot([integ['x'], integ['x']], [1.6, 2.3],
                color=COLORS['secondary'], linewidth=1.5, linestyle='--', alpha=0.7)
    ax.plot([4, 12], [2.3, 2.3],
            color=COLORS['secondary'], linewidth=1.5, linestyle='--', alpha=0.7)
    # Connect to steps 2, 4, and 5
    ax.plot([step2_x, step2_x], [2.3, step_bottom],
            color=COLORS['secondary'], linewidth=1.5, linestyle='--', alpha=0.7)
    ax.plot([step4_x, step4_x], [2.3, step_bottom],
            color=COLORS['secondary'], linewidth=1.5, linestyle='--', alpha=0.7)
    ax.plot([step5_x, step5_x], [2.3, step_bottom],
            color=COLORS['secondary'], linewidth=1.5, linestyle='--', alpha=0.7)

    # === FOOTER ===
    ax.text(8, 0.2, 'aka.ms/agenticinfraops', fontsize=10,
            color=COLORS['dark'], ha='center', va='center', style='italic')

    return fig


# Dark theme colors matching the presentation style
DARK_COLORS = {
    'background': '#1E1E2E',   # Dark navy
    'text': '#FFFFFF',         # White text
    'text_secondary': '#B4B4B4',  # Gray text
    'cyan': '#22D3EE',         # Cyan/Teal for Step 1
    'orange': '#F97316',       # Orange for Step 2
    'purple_light': '#A78BFA',  # Light purple for design artifacts
    'green': '#22C55E',        # Green for Step 4
    'pink': '#EC4899',         # Pink for Step 5
    'teal': '#14B8A6',         # Teal for integrations
    'purple': '#8B5CF6',       # Purple for as-built
    'orange_light': '#FB923C',  # Light orange for post-build
}


def create_workflow_diagram_dark():
    """Generate the 7-step workflow diagram with dark theme."""

    # Create figure (landscape, presentation-friendly)
    fig = plt.figure(figsize=(16, 9), facecolor=DARK_COLORS['background'])
    ax = fig.add_axes([0, 0, 1, 1])
    ax.set_xlim(0, 16)
    ax.set_ylim(0, 9)
    ax.axis('off')
    ax.set_facecolor(DARK_COLORS['background'])

    # === HEADER ===
    ax.text(8, 8.3, 'Agentic InfraOps', fontsize=28, fontweight='bold',
            color=DARK_COLORS['text'], ha='center', va='center')
    ax.text(8, 7.7, '7-Step Agent Workflow', fontsize=14,
            color=DARK_COLORS['text_secondary'], ha='center', va='center', style='italic')

    # === MAIN WORKFLOW STEPS (simplified linear flow) ===
    step_width = 2.0
    step_height = 0.9
    main_y = 4.5
    gap = 0.4
    start_x = 1.0

    main_steps = [
        {'num': '1', 'title': 'Plan', 'agent': 'project-planner',
            'color': DARK_COLORS['cyan']},
        {'num': '2', 'title': 'Architect',
            'agent': 'azure-principal-architect', 'color': DARK_COLORS['orange']},
        {'num': '4', 'title': 'Plan Infrastructure',
            'agent': 'bicep-plan', 'color': DARK_COLORS['green']},
        {'num': '5', 'title': 'Generate Code',
            'agent': 'bicep-implement', 'color': DARK_COLORS['pink']},
    ]

    step_positions = {}

    for i, step in enumerate(main_steps):
        x = start_x + i * (step_width + gap + 0.8)
        step_positions[step['num']] = (x + step_width/2, main_y)

        # Step box
        box = FancyBboxPatch((x, main_y - step_height/2), step_width, step_height,
                             boxstyle="round,pad=0.02,rounding_size=0.15",
                             facecolor=step['color'], edgecolor=step['color'],
                             linewidth=2, transform=ax.transData)
        ax.add_patch(box)

        # Step number + title
        ax.text(x + step_width/2, main_y + 0.15, f"① {step['title']}" if step['num'] == '1' else
                f"② {step['title']}" if step['num'] == '2' else
                f"④ {step['title']}" if step['num'] == '4' else
                f"⑤ {step['title']}",
                fontsize=11, fontweight='bold', color=DARK_COLORS['text'],
                ha='center', va='center')

        # Agent name
        ax.text(x + step_width/2, main_y - 0.2, step['agent'],
                fontsize=8, color=DARK_COLORS['text'],
                ha='center', va='center', family='monospace')

        # Arrow to next step
        if i < len(main_steps) - 1:
            arrow_x = x + step_width + 0.1
            ax.annotate('', xy=(arrow_x + gap + 0.6, main_y),
                        xytext=(arrow_x, main_y),
                        arrowprops=dict(arrowstyle='->', color=step['color'],
                                        lw=2.5, mutation_scale=15))

    # === OPTIONAL PRE-BUILD ARTIFACTS (Step 3) ===
    prebuild_x = 7.0
    prebuild_y = 6.2

    # Pre-Build Artifacts box (optional)
    box = FancyBboxPatch((prebuild_x - 1.2, prebuild_y - 0.4), 2.4, 0.8,
                         boxstyle="round,pad=0.02,rounding_size=0.1",
                         facecolor=DARK_COLORS['purple_light'], edgecolor=DARK_COLORS['purple_light'],
                         linewidth=2, transform=ax.transData)
    ax.add_patch(box)
    ax.text(prebuild_x, prebuild_y, '③ Pre-Build Artifacts\n(optional)',
            fontsize=9, fontweight='bold', color=DARK_COLORS['text'],
            ha='center', va='center')

    # Design diagram box
    design_diag_x = 4.5
    design_diag_y = 7.0
    box = FancyBboxPatch((design_diag_x - 1.1, design_diag_y - 0.35), 2.2, 0.7,
                         boxstyle="round,pad=0.02,rounding_size=0.1",
                         facecolor=DARK_COLORS['teal'], edgecolor=DARK_COLORS['teal'],
                         linewidth=2, transform=ax.transData)
    ax.add_patch(box)
    ax.text(design_diag_x, design_diag_y, '-design diagram\ndiagram-generator',
            fontsize=8, color=DARK_COLORS['text'], ha='center', va='center')

    # Design ADR box
    design_adr_x = 4.5
    design_adr_y = 5.8
    box = FancyBboxPatch((design_adr_x - 1.1, design_adr_y - 0.35), 2.2, 0.7,
                         boxstyle="round,pad=0.02,rounding_size=0.1",
                         facecolor=DARK_COLORS['teal'], edgecolor=DARK_COLORS['teal'],
                         linewidth=2, transform=ax.transData)
    ax.add_patch(box)
    ax.text(design_adr_x, design_adr_y, '-design ADR\nadr-generator',
            fontsize=8, color=DARK_COLORS['text'], ha='center', va='center')

    # Dashed lines from Step 2 to design artifacts
    step2_pos = step_positions['2']
    ax.plot([step2_pos[0], design_diag_x], [step2_pos[1] + 0.5, design_diag_y - 0.4],
            color=DARK_COLORS['orange'], linewidth=1.5, linestyle='--', alpha=0.7)
    ax.plot([step2_pos[0], design_adr_x], [step2_pos[1] + 0.5, design_adr_y - 0.4],
            color=DARK_COLORS['orange'], linewidth=1.5, linestyle='--', alpha=0.7)

    # Dashed lines from design artifacts to Pre-Build
    ax.plot([design_diag_x + 1.1, prebuild_x - 1.2], [design_diag_y, prebuild_y + 0.2],
            color=DARK_COLORS['teal'], linewidth=1.5, linestyle='--', alpha=0.7)
    ax.plot([design_adr_x + 1.1, prebuild_x - 1.2], [design_adr_y, prebuild_y - 0.2],
            color=DARK_COLORS['teal'], linewidth=1.5, linestyle='--', alpha=0.7)

    # Dashed line from Pre-Build to Step 4
    step4_pos = step_positions['4']
    ax.plot([prebuild_x + 1.2, step4_pos[0]], [prebuild_y - 0.4, step4_pos[1] + 0.5],
            color=DARK_COLORS['purple_light'], linewidth=1.5, linestyle='--', alpha=0.7)

    # === GOVERNANCE DISCOVERY (below Step 4) ===
    gov_x = step4_pos[0]
    gov_y = 3.0
    box = FancyBboxPatch((gov_x - 1.2, gov_y - 0.35), 2.4, 0.7,
                         boxstyle="round,pad=0.02,rounding_size=0.1",
                         facecolor=DARK_COLORS['teal'], edgecolor=DARK_COLORS['teal'],
                         linewidth=2, transform=ax.transData)
    ax.add_patch(box)
    ax.text(gov_x, gov_y, 'Governance Discovery\nAzure Policy',
            fontsize=8, color=DARK_COLORS['text'], ha='center', va='center')

    # Dashed line from Governance to Step 4
    ax.plot([gov_x, gov_x], [gov_y + 0.35, step4_pos[1] - 0.5],
            color=DARK_COLORS['teal'], linewidth=1.5, linestyle='--', alpha=0.7)

    # === POST-BUILD ARTIFACTS (Step 6-7) ===
    step5_pos = step_positions['5']

    # Post-Build Artifacts box
    postbuild_x = 14.5
    postbuild_y = 4.5
    box = FancyBboxPatch((postbuild_x - 1.2, postbuild_y - 0.4), 2.4, 0.8,
                         boxstyle="round,pad=0.02,rounding_size=0.1",
                         facecolor=DARK_COLORS['orange_light'], edgecolor=DARK_COLORS['orange_light'],
                         linewidth=2, transform=ax.transData)
    ax.add_patch(box)
    ax.text(postbuild_x, postbuild_y, '⑥ Post-Build Artifacts\n(optional)',
            fontsize=9, fontweight='bold', color=DARK_COLORS['text'],
            ha='center', va='center')

    # Arrow from Step 5 to Post-Build
    ax.annotate('', xy=(postbuild_x - 1.3, postbuild_y),
                xytext=(step5_pos[0] + 1.0, step5_pos[1]),
                arrowprops=dict(arrowstyle='->', color=DARK_COLORS['pink'],
                                lw=2.5, mutation_scale=15))

    # As-built diagram box
    asbuilt_diag_x = 12.5
    asbuilt_diag_y = 3.2
    box = FancyBboxPatch((asbuilt_diag_x - 1.1, asbuilt_diag_y - 0.35), 2.2, 0.7,
                         boxstyle="round,pad=0.02,rounding_size=0.1",
                         facecolor=DARK_COLORS['purple'], edgecolor=DARK_COLORS['purple'],
                         linewidth=2, transform=ax.transData)
    ax.add_patch(box)
    ax.text(asbuilt_diag_x, asbuilt_diag_y, '-asbuilt diagram\ndiagram-generator',
            fontsize=8, color=DARK_COLORS['text'], ha='center', va='center')

    # As-built ADR box
    asbuilt_adr_x = 12.5
    asbuilt_adr_y = 2.0
    box = FancyBboxPatch((asbuilt_adr_x - 1.1, asbuilt_adr_y - 0.35), 2.2, 0.7,
                         boxstyle="round,pad=0.02,rounding_size=0.1",
                         facecolor=DARK_COLORS['teal'], edgecolor=DARK_COLORS['teal'],
                         linewidth=2, transform=ax.transData)
    ax.add_patch(box)
    ax.text(asbuilt_adr_x, asbuilt_adr_y, '-asbuilt ADR\nadr-generator',
            fontsize=8, color=DARK_COLORS['text'], ha='center', va='center')

    # Dashed lines from Post-Build to as-built artifacts
    ax.plot([postbuild_x - 0.5, asbuilt_diag_x + 1.1], [postbuild_y - 0.5, asbuilt_diag_y + 0.35],
            color=DARK_COLORS['orange_light'], linewidth=1.5, linestyle='--', alpha=0.7)
    ax.plot([asbuilt_diag_x, asbuilt_adr_x], [asbuilt_diag_y - 0.35, asbuilt_adr_y + 0.35],
            color=DARK_COLORS['purple'], linewidth=1.5, linestyle='--', alpha=0.7)

    # === FOOTER ===
    ax.text(8, 0.4, 'aka.ms/agenticinfraops', fontsize=10,
            color=DARK_COLORS['text_secondary'], ha='center', va='center', style='italic')

    return fig


def main():
    """Generate and save the workflow diagram."""
    output_dir = Path(__file__).parent / 'generated'
    output_dir.mkdir(exist_ok=True)

    print("🎨 Generating 7-Step Workflow Diagram...")

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

    # Generate dark theme version
    print("🎨 Generating Dark Theme Workflow Diagram...")

    fig_dark = create_workflow_diagram_dark()

    # Save dark theme high-res PNG
    fig_dark.savefig(output_dir / 'workflow-diagram-dark.png', dpi=300,
                     bbox_inches='tight', facecolor=DARK_COLORS['background'], edgecolor='none')
    print(f"  ✅ Saved: {output_dir / 'workflow-diagram-dark.png'}")

    # Save dark theme web version
    fig_dark.savefig(output_dir / 'workflow-diagram-dark-web.png', dpi=150,
                     bbox_inches='tight', facecolor=DARK_COLORS['background'], edgecolor='none')
    print(f"  ✅ Saved: {output_dir / 'workflow-diagram-dark-web.png'}")

    plt.close(fig_dark)

    print("✅ Workflow diagram generation complete!")


if __name__ == '__main__':
    main()
