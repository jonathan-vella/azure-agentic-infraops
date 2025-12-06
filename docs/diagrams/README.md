# Architecture Diagrams

This folder contains generated architecture diagrams for various scenarios.

## Available Diagrams

| Folder | Description |
| ------ | ----------- |
| [ecommerce/](ecommerce/) | E-commerce platform architecture diagram |
| [mcp/](mcp/) | Azure Pricing MCP server architecture |
| [workflow/](workflow/) | Agent workflow visualizations |

## About Diagrams

Architecture diagrams are generated using the `diagram-generator` custom agent, which uses the Python [diagrams](https://diagrams.mingrammer.com/) library by mingrammer.

### File Types

- `.py` - Python source code for generating diagrams
- `.png` - Generated PNG images
- `.svg` - Scalable vector graphics (when available)
- `.dot` - Graphviz DOT format

## Generating New Diagrams

1. Press `Ctrl+Shift+A` in VS Code
2. Select `diagram-generator`
3. Describe the architecture you want to visualize

The agent will create a Python script and generate the corresponding image.

## Related Documentation

- [S08 Diagrams as Code](../../scenarios/S08-diagrams-as-code/) - Hands-on scenario for diagram generation
- [Visual Elements Guide](../presenter-toolkit/visual-elements-guide.md) - Using diagrams in presentations
