# Contributing to Agentic InfraOps

Thank you for your interest in contributing! Agentic InfraOps revolutionizes how IT Pros build Azure environments through coordinated AI agents.

## 🎯 What We're Looking For

### High-Priority Contributions

1. **Agent Improvements**

   - Enhancements to existing agents (`.github/agents/*.agent.md`)
   - Better prompts and handoff patterns
   - Additional validation checks

2. **Documentation**

   - Workflow improvements (`docs/WORKFLOW.md`)
   - Better examples and use cases
   - Troubleshooting guides

3. **Best Practices**
   - Bicep patterns and templates
   - Azure Verified Module usage examples
   - Security and compliance guidance

## 📋 Contribution Guidelines

### Before You Start

1. **Check existing issues** - Someone might already be working on it
2. **Open an issue** - Discuss your idea before investing time

### Code Standards

**Bicep:**

```bicep
// Use consistent naming conventions
// Include parameter descriptions
// Add output values
// Follow Azure naming best practices
```

### Documentation Standards

- Use clear, concise language
- Include code examples
- Document prerequisites
- Use Mermaid for diagrams

### Markdown Linting

This repository uses [markdownlint](https://github.com/DavidAnson/markdownlint) for consistent formatting.

**Running the linter:**

```bash
# Check for issues
npm run lint:md

# Auto-fix issues
npm run lint:md:fix
```

## 🚀 Contribution Process

### 1. Fork & Clone

```bash
git clone https://github.com/YOUR-USERNAME/azure-agentic-infraops.git
cd azure-agentic-infraops
git remote add upstream https://github.com/jonathan-vella/azure-agentic-infraops.git
```

### 2. Create a Branch

```bash
git checkout -b feature/your-feature-name
# or
git checkout -b fix/issue-description
```

### 3. Make Your Changes

- Follow the guidelines above
- Test any Bicep changes with `bicep build` and `bicep lint`
- Validate markdown with `npm run lint:md`

### 4. Commit & Push

```bash
git add .
git commit -m "feat: Add [feature description]"
git push origin feature/your-feature-name
```

**Commit Message Format:**

- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation changes
- `refactor:` Code refactoring

### 5. Create Pull Request

1. Go to your fork on GitHub
2. Click "New Pull Request"
3. Fill out the PR template
4. Link related issues

## 📝 Pull Request Checklist

Before submitting:

- [ ] Code follows repository standards
- [ ] Documentation updated if needed
- [ ] Markdown files pass linting (`npm run lint:md`)
- [ ] No hardcoded secrets or subscription IDs
- [ ] Links work correctly

## 🤝 Community Standards

### Code of Conduct

- Be respectful and inclusive
- Welcome newcomers
- Focus on constructive feedback
- No harassment or discrimination

### Getting Help

- **Questions**: GitHub Discussions
- **Issues**: GitHub Issues

## 📄 License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

**Thank you for helping improve the Azure infrastructure workflow!** 🚀
