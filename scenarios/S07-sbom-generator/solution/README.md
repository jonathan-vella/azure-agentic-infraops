# Solution Folder: Legacy Automation Scripts

This folder contains **PowerShell automation scripts** for SBOM generation.
These represent the **original (legacy) approach** to this demo,
which focused on building automation tools with GitHub Copilot.

---

## ⚠️ Important: Approach Change

**This demo has been refactored** to use a **conversation-based learning approach** where GitHub Copilot acts as
your SBOM expert partner, teaching you concepts while creating production deliverables.

### New Recommended Approach (Conversation-Based)

✅ **Start here**: See `examples/copilot-sbom-conversation.md` for the recommended workflow  
✅ **Demo script**: `DEMO-SCRIPT.md` for presenter guide  
✅ **Prompts**: `prompts/effective-prompts.md` for conversation starters

**Why this approach?**
- Lower barrier to entry (no PowerShell expertise needed)
- Knowledge transfer (understand SBOMs, not just generate them)
- Reusable skills (next SBOM takes 30 minutes, not 6 hours)
- Stakeholder communication (can explain methodology to auditors)

---

## When to Use These Scripts

These automation scripts are appropriate **after** you understand SBOMs:

1. ✅ **After learning**: Use conversation approach to create 2-3 SBOMs manually
2. ✅ **Scaling need**: Team needs to generate SBOMs for 100+ applications
3. ✅ **CI/CD integration**: Want to automate SBOM generation in pipelines
4. ✅ **Advanced users**: Already understand CycloneDX, PURL, license compliance

**Migration Path**: Learn (conversation) → Manual (with understanding) → Automate (these scripts) → Scale (CI/CD)

---

## Scripts in This Folder

### 1. New-ApplicationSBOM.ps1

**Purpose**: Scans npm/NuGet/pip dependencies and generates CycloneDX SBOM

**Prerequisites**:
- PowerShell 7+
- Node.js (for npm scanning)
- .NET SDK (for NuGet scanning)
- Python (for pip scanning)

**Usage**:
```powershell
./New-ApplicationSBOM.ps1 `
    -PackageJsonPath "../sample-app/src/api/package.json" `
    -OutputPath "../examples/application-sbom.json"
```

**What it does**:
- Parses package.json (or packages.config, requirements.txt)
- Extracts dependencies and versions
- Generates PURL format for each package
- Creates CycloneDX 1.5 JSON output

### 2. New-ContainerSBOM.ps1

**Purpose**: Analyzes Docker images and generates SBOM for container components

**Prerequisites**:
- PowerShell 7+
- Docker Desktop (or Docker CLI)
- Syft CLI (optional, recommended)

**Usage**:
```powershell
./New-ContainerSBOM.ps1 `
    -ImageName "todo-app:latest" `
    -OutputPath "../examples/container-sbom.json"
```

**What it does**:
- Analyzes Docker image layers
- Extracts base image packages (Alpine, Debian, Ubuntu)
- Identifies system libraries (OpenSSL, musl)
- Integrates with Syft for comprehensive scanning
- Creates CycloneDX 1.5 JSON output

### 3. New-InfrastructureSBOM.ps1

**Purpose**: Queries Azure resources and generates infrastructure SBOM

**Prerequisites**:
- PowerShell 7+
- Azure CLI (authenticated)
- Contributor/Reader access to Azure subscription

**Usage**:
```powershell
./New-InfrastructureSBOM.ps1 `
    -ResourceGroupName "rg-todo-app-prod" `
    -OutputPath "../examples/infrastructure-sbom.json"
```

**What it does**:
- Queries Azure Resource Graph
- Extracts deployed resources (App Service, Cosmos DB, Key Vault, etc.)
- Formats as CycloneDX components with Azure PURL
- Creates CycloneDX 1.5 JSON output

### 4. Merge-SBOMDocuments.ps1

**Purpose**: Combines multiple SBOMs into unified document

**Prerequisites**:
- PowerShell 7+

**Usage**:
```powershell
./Merge-SBOMDocuments.ps1 `
    -InputPath "../examples" `
    -OutputFile "../examples/merged-sbom.json"
```

**What it does**:
- Reads multiple SBOM JSON files
- Merges component arrays
- Deduplicates components
- Generates unified CycloneDX 1.5 JSON

### 5. Export-SBOMReport.ps1

**Purpose**: Generates human-readable reports from SBOM JSON

**Prerequisites**:
- PowerShell 7+

**Usage**:
```powershell
./Export-SBOMReport.ps1 `
    -SBOMPath "../examples/merged-sbom.json" `
    -OutputFormat "HTML" `
    -OutputPath "../examples/sbom-report.html"
```

**What it does**:
- Parses CycloneDX JSON
- Generates HTML/CSV/Markdown reports
- Creates component summary tables
- Highlights license compliance

---

## Limitations of Automation-First Approach

These scripts are powerful but come with trade-offs:

### ❌ Challenges

1. **No learning**: User gets automation but doesn't understand SBOMs
2. **Troubleshooting difficulty**: When scripts fail, user can't debug
3. **Customization overhead**: Requires PowerShell expertise to modify
4. **Tool dependencies**: Requires installation of multiple tools (npm, Docker, Azure CLI, Syft)
5. **Stakeholder communication**: Can't explain methodology to auditors

### ✅ Benefits

1. **Speed at scale**: Once setup, generates SBOMs in seconds
2. **Consistency**: Same process every time
3. **CI/CD integration**: Can automate in pipelines
4. **Enterprise deployment**: Can process 100+ applications

---

## Recommended Workflow

### Phase 1: Learning (1-2 weeks)

**Use**: Conversation approach (`examples/copilot-sbom-conversation.md`)

- Create 2-3 SBOMs manually with Copilot guidance
- Understand PURL, CycloneDX, licenses, validation
- Build confidence in SBOM creation

**Time**: 1.25 hours for first SBOM, 30 minutes for subsequent

### Phase 2: Manual Mastery (2-4 weeks)

**Use**: Conversation approach for production SBOMs

- Create SBOMs for 5-10 applications
- Recognize patterns and repetition
- Identify automation opportunities

**Time**: 30 minutes per SBOM

### Phase 3: Automation (Week 5+)

**Use**: These scripts for scaling

- Ask Copilot to generate automation scripts (or use these)
- Integrate into CI/CD pipelines
- Process 100+ applications automatically

**Time**: 5 minutes per SBOM (once automated)

---

## Generating Your Own Automation Scripts

If you want to generate custom automation scripts (tailored to your environment):

### Step 1: Understand SBOMs First

Complete the conversation-based learning approach first. Create 2-3 SBOMs manually.

### Step 2: Ask Copilot for Automation

**Example Prompt**:
```
I've created several SBOMs manually and understand the structure (CycloneDX 1.5, 
PURL format, component fields). Now I want to automate this for my team. 

Can you generate a PowerShell script that:
1. Reads package.json and extracts npm dependencies
2. Formats each dependency as a CycloneDX component with PURL
3. Includes license information from package.json
4. Generates valid CycloneDX 1.5 JSON output
5. Has error handling and parameter validation

Include comments explaining each step.
```

### Step 3: Test and Refine

- Run the generated script on your applications
- Validate output with CycloneDX validator
- Ask Copilot to fix issues or add features

### Step 4: Integrate into CI/CD

- Add script to Azure DevOps / GitHub Actions pipeline
- Generate SBOM on every release
- Upload as build artifact

---

## Comparison: Conversation vs Automation

| Aspect | Conversation (NEW) | Automation (LEGACY) |
|--------|-------------------|---------------------|
| **Learning Outcome** | ✅ Complete understanding | ❌ Minimal (black box) |
| **Time (1st SBOM)** | 1.25 hours | 1 hour (building script) |
| **Time (2nd SBOM)** | 30 min | 5 min (running script) |
| **Prerequisites** | VS Code + Copilot | PowerShell 7, Azure CLI, Docker, Syft |
| **Troubleshooting** | ✅ Can debug (understands) | ❌ Difficult (script-dependent) |
| **Customization** | ✅ Easy (knows concepts) | ❌ Requires PowerShell expertise |
| **Stakeholder Comm** | ✅ Can explain methodology | ❌ Just shows output |
| **Scaling** | Medium (manual but fast) | ✅ High (CI/CD automation) |
| **Best For** | First-time SBOM creators | Experienced teams, large scale |

---

## Getting Help with Scripts

If you encounter issues with these automation scripts:

### Common Issues

**"Script not found"**
```powershell
# Make sure you're in the solution/ directory
cd scenarios/S07-sbom-generator/solution
```

**"Execution policy error"**
```powershell
# Set execution policy (one-time)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**"Syft not found"**
```powershell
# Install Syft (optional but recommended)
# Windows: choco install syft
# macOS: brew install syft
# Linux: curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh
```

**"Azure CLI not authenticated"**
```powershell
# Login to Azure
az login
az account set --subscription "your-subscription-id"
```

### Resources

- **Conversation Example**: `../examples/copilot-sbom-conversation.md` (learn first)
- **Prompts Guide**: `../prompts/effective-prompts.md` (conversation starters)
- **Demo Script**: `../DEMO-SCRIPT.md` (presenter guide)

---

## Philosophy

**"Learn first, automate later."**

Understanding SBOMs makes you **effective**. Automation makes you **efficient**.
Both matter, but knowledge is the foundation.

Start with conversation-based learning, then progress to these automation scripts when you're ready to scale.

---

**Status**: Legacy / Optional  
**Recommended Path**: Start with `examples/copilot-sbom-conversation.md`  
**Next Step**: Create your first SBOM through conversation with Copilot
