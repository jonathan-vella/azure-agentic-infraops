#!/bin/bash
set -e

echo "🚀 Running post-create setup for Agentic InfraOps..."

# Log output to file for debugging
exec 1> >(tee -a ~/.devcontainer-install.log)
exec 2>&1

# Create directories
echo "📂 Creating cache directories..."
mkdir -p "${HOME}/.terraform-cache"
chmod 755 "${HOME}/.terraform-cache"

# Configure Git safe directory (for mounted volumes)
echo "🔐 Configuring Git..."
git config --global --add safe.directory "${PWD}"
git config --global core.autocrlf input

# Verify Python packages (installed via pip or should be)
echo "🐍 Verifying Python packages..."
python3 -c "import checkov; import diagrams" 2>/dev/null && echo "  ✅ checkov and diagrams available" || {
    echo "  Installing checkov and diagrams..."
    pip3 install --quiet --user checkov diagrams 2>&1 | tail -1 || echo "  ⚠️  Installation had issues, continuing..."
}

# Install markdownlint-cli2 (installed via postCreateCommand, verify here)
echo "📝 Verifying markdownlint-cli2..."
if command -v markdownlint-cli2 &> /dev/null; then
    echo "  ✅ markdownlint-cli2 already installed"
elif command -v markdownlint &> /dev/null; then
    echo "  ✅ markdownlint already installed"
else
    echo "  ⚠️  markdownlint not found (should have been installed via postCreateCommand)"
fi

# Install Azure PowerShell modules (parallel install)
echo "🔧 Installing Azure PowerShell modules..."
pwsh -NoProfile -Command "
    \$ErrorActionPreference = 'SilentlyContinue'
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
    
    # Install modules in parallel using jobs
    \$modules = @('Az.Accounts', 'Az.Resources', 'Az.Storage', 'Az.Network', 'Az.KeyVault', 'Az.Websites')
    \$jobs = @()
    
    foreach (\$module in \$modules) {
        if (-not (Get-Module -ListAvailable -Name \$module)) {
            Write-Host \"  Installing \$module...\"
            Install-Module -Name \$module -Scope CurrentUser -Force -AllowClobber -SkipPublisherCheck
        } else {
            Write-Host \"  \$module already installed\"
        }
    }
    
    Write-Host '✅ PowerShell modules installed'
" || echo "⚠️  Warning: PowerShell module installation incomplete"

# Install GitHub CLI (not in universal:2 image)
echo "📦 Installing GitHub CLI..."
if ! command -v gh &> /dev/null; then
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt-get update && sudo apt-get install -y gh 2>&1 | tail -3
else
    echo "  ✅ GitHub CLI already installed"
fi

# Install Terratest dependencies (Go pre-installed in universal image)
echo "🧪 Installing Terratest..."
if command -v go &> /dev/null; then
    export GOPATH="$HOME/go"
    export PATH="$PATH:$GOPATH/bin"
    if go install github.com/gruntwork-io/terratest/modules/terraform@latest 2>/dev/null; then
        echo "  ✅ Terratest installed to $GOPATH/bin"
    else
        echo "  ⚠️  Terratest installation had issues, but may still be available"
    fi
else
    echo "  ⚠️  Go not found, skipping Terratest"
fi

# Verify utilities (installed via devcontainer postCreateCommand)
echo "🛠️  Verifying utilities..."
command -v dot &> /dev/null && echo "  ✅ graphviz available" || echo "  ⚠️  graphviz not found (required for S08)"
command -v dos2unix &> /dev/null && echo "  ✅ dos2unix available" || echo "  ⚠️  dos2unix not found"

# Setup Azure Pricing MCP Server
echo "💰 Setting up Azure Pricing MCP Server..."
MCP_DIR="${PWD}/mcp/azure-pricing-mcp"
if [ -d "$MCP_DIR" ]; then
    if [ ! -d "$MCP_DIR/.venv" ]; then
        echo "  Creating virtual environment..."
        python3 -m venv "$MCP_DIR/.venv"
    fi
    
    # Always install/upgrade package in editable mode for proper entry points
    echo "  Installing MCP server package..."
    cd "$MCP_DIR"
    "$MCP_DIR/.venv/bin/pip" install --quiet --upgrade pip 2>&1 | tail -1 || true
    "$MCP_DIR/.venv/bin/pip" install --quiet -e . 2>&1 | tail -1 || true
    cd - > /dev/null
    echo "  ✅ Azure Pricing MCP installed"
    
    # Health check - verify server starts
    echo "  Running health check..."
    if echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"healthcheck","version":"1.0"}}}' | \
       timeout 5 "$MCP_DIR/.venv/bin/python" -m azure_pricing_mcp 2>/dev/null | grep -q '"serverInfo"'; then
        echo "  ✅ MCP server health check passed"
    else
        echo "  ⚠️  MCP server health check failed (may need manual setup)"
    fi
else
    echo "  ⚠️  MCP directory not found at $MCP_DIR"
fi

# Configure Azure CLI defaults (Azure CLI installed via devcontainer feature)
echo "☁️  Configuring Azure CLI defaults..."
if az config set defaults.location=swedencentral --only-show-errors 2>/dev/null; then
    echo "  ✅ Default location set to swedencentral"
fi
az config set auto-upgrade.enable=no --only-show-errors 2>/dev/null || true

# Verify installations
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Verifying tool installations..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
printf "  %-15s %s\n" "Terraform:" "$(terraform version 2>/dev/null | head -n1 || echo '❌ not installed')"
printf "  %-15s %s\n" "Azure CLI:" "$(az version --query '\"azure-cli\"' -o tsv 2>/dev/null || az --version 2>/dev/null | head -n1 || echo '❌ not installed')"
printf "  %-15s %s\n" "Bicep:" "$(az bicep version 2>/dev/null | head -n1 || echo '❌ not installed')"
printf "  %-15s %s\n" "PowerShell:" "$(pwsh --version 2>/dev/null || echo '❌ not installed')"
printf "  %-15s %s\n" "Python:" "$(python3 --version 2>/dev/null || echo '❌ not installed')"
printf "  %-15s %s\n" "Go:" "$(go version 2>/dev/null | awk '{print $3}' || echo '❌ not installed')"
printf "  %-15s %s\n" "Node.js:" "$(node --version 2>/dev/null || echo '❌ not installed')"
printf "  %-15s %s\n" "GitHub CLI:" "$(gh --version 2>/dev/null | head -n1 || echo '❌ not installed')"
printf "  %-15s %s\n" "tfsec:" "$(tfsec --version 2>/dev/null || echo '❌ not installed')"
printf "  %-15s %s\n" "Checkov:" "$(checkov --version 2>/dev/null || echo '❌ not installed')"
printf "  %-15s %s\n" "markdownlint:" "$(markdownlint-cli2 --version 2>/dev/null || markdownlint --version 2>/dev/null || echo '❌ not installed')"

echo ""
echo "🎉 Post-create setup completed!"
echo ""
echo "📝 Next steps:"
echo "   1. Authenticate: az login"
echo "   2. Set subscription: az account set --subscription <id>"
echo "   3. Explore: cd scenarios/ && tree -L 2"
echo ""
