<#
.SYNOPSIS
    Updates version numbers across all README files in the repository.

.DESCRIPTION
    This script updates version strings in all documentation files to ensure
    consistency across the repository. It handles multiple version formats:
    - "Version X.Y.Z"
    - "vX.Y.Z"
    - "Agentic InfraOps vX.Y.Z"

.PARAMETER NewVersion
    The new version number (e.g., "3.7.0")

.PARAMETER DryRun
    Preview changes without modifying files

.EXAMPLE
    ./update-version.ps1 -NewVersion "3.7.0"
    Updates all files to version 3.7.0

.EXAMPLE
    ./update-version.ps1 -NewVersion "3.7.0" -DryRun
    Shows what would be changed without making modifications

.NOTES
    Author: Agentic InfraOps Team
    Version: 1.0.0
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory = $true)]
    [ValidatePattern('^\d+\.\d+\.\d+$')]
    [string]$NewVersion,

    [Parameter()]
    [switch]$DryRun
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Files to update with their version patterns
$VersionFiles = @(
    @{
        Path    = 'README.md'
        Pattern = '> \*\*Version \d+\.\d+\.\d+\*\*'
        Replace = "> **Version $NewVersion**"
    },
    @{
        Path    = 'docs/README.md'
        Pattern = '> \*\*Agentic InfraOps v\d+\.\d+\.\d+\*\*'
        Replace = "> **Agentic InfraOps v$NewVersion**"
    },
    @{
        Path    = 'docs/README.md'
        Pattern = '\*\*Version\*\*: \d+\.\d+\.\d+.*\[Back to Main README\]'
        Replace = "**Version**: $NewVersion | [Back to Main README]"
    },
    @{
        Path    = 'docs/getting-started/learning-paths.md'
        Pattern = '> \*\*Version \d+\.\d+\.\d+\*\*'
        Replace = "> **Version $NewVersion**"
    },
    @{
        Path    = 'docs/getting-started/quickstart.md'
        Pattern = '> \*\*Version \d+\.\d+\.\d+\*\*'
        Replace = "> **Version $NewVersion**"
    },
    @{
        Path    = 'docs/getting-started/first-scenario.md'
        Pattern = '> \*\*Version \d+\.\d+\.\d+\*\*'
        Replace = "> **Version $NewVersion**"
    },
    @{
        Path    = 'docs/reference/workflow.md'
        Pattern = '> \*\*Version \d+\.\d+\.\d+\*\*'
        Replace = "> **Version $NewVersion**"
    },
    @{
        Path    = 'docs/reference/defaults.md'
        Pattern = '> \*\*Version \d+\.\d+\.\d+\*\*'
        Replace = "> **Version $NewVersion**"
    },
    @{
        Path    = 'docs/reference/agents-overview.md'
        Pattern = '> \*\*Version \d+\.\d+\.\d+\*\*'
        Replace = "> **Version $NewVersion**"
    },
    @{
        Path    = 'docs/reference/bicep-patterns.md'
        Pattern = '> \*\*Version \d+\.\d+\.\d+\*\*'
        Replace = "> **Version $NewVersion**"
    },
    @{
        Path    = 'docs/presenter/README.md'
        Pattern = '> \*\*Version \d+\.\d+\.\d+\*\*'
        Replace = "> **Version $NewVersion**"
    },
    @{
        Path    = 'scenarios/README.md'
        Pattern = '> \*\*Version \d+\.\d+\.\d+\*\*'
        Replace = "> **Version $NewVersion**"
    },
    @{
        Path    = '.devcontainer/README.md'
        Pattern = '> \*\*Version \d+\.\d+\.\d+\*\*'
        Replace = "> **Version $NewVersion**"
    }
)

# Banner
Write-Host @"

╔═══════════════════════════════════════════════════════════════════════╗
║   Agentic InfraOps - Version Update Script                            ║
╚═══════════════════════════════════════════════════════════════════════╝

"@ -ForegroundColor Cyan

Write-Host "  Target Version: " -NoNewline -ForegroundColor Gray
Write-Host "$NewVersion" -ForegroundColor Green

if ($DryRun) {
    Write-Host "  Mode: " -NoNewline -ForegroundColor Gray
    Write-Host "DRY RUN (no files will be modified)" -ForegroundColor Yellow
}

Write-Host ""

# Get repository root
$RepoRoot = git rev-parse --show-toplevel 2>$null
if (-not $RepoRoot) {
    Write-Error "Not in a git repository. Run this script from within the azure-agentic-infraops repository."
    exit 1
}

Push-Location $RepoRoot

try {
    $UpdatedCount = 0
    $SkippedCount = 0
    $ErrorCount = 0

    Write-Host "  ┌────────────────────────────────────────────────────────────────────┐"
    Write-Host "  │  PROCESSING FILES                                                  │"
    Write-Host "  └────────────────────────────────────────────────────────────────────┘"
    Write-Host ""

    foreach ($file in $VersionFiles) {
        $filePath = Join-Path $RepoRoot $file.Path
        
        if (-not (Test-Path $filePath)) {
            Write-Host "  ⚠ " -ForegroundColor Yellow -NoNewline
            Write-Host "Skipped: $($file.Path) (file not found)" -ForegroundColor Gray
            $SkippedCount++
            continue
        }

        $content = Get-Content $filePath -Raw -Encoding UTF8
        
        if ($content -match $file.Pattern) {
            $currentVersion = [regex]::Match($content, '\d+\.\d+\.\d+').Value
            
            if ($currentVersion -eq $NewVersion) {
                Write-Host "  ○ " -ForegroundColor DarkGray -NoNewline
                Write-Host "$($file.Path) " -ForegroundColor Gray -NoNewline
                Write-Host "(already at $NewVersion)" -ForegroundColor DarkGray
                $SkippedCount++
                continue
            }

            if ($DryRun) {
                Write-Host "  → " -ForegroundColor Blue -NoNewline
                Write-Host "$($file.Path): " -ForegroundColor White -NoNewline
                Write-Host "$currentVersion → $NewVersion" -ForegroundColor Cyan
            }
            else {
                if ($PSCmdlet.ShouldProcess($file.Path, "Update version from $currentVersion to $NewVersion")) {
                    $newContent = $content -replace $file.Pattern, $file.Replace
                    Set-Content -Path $filePath -Value $newContent -NoNewline -Encoding UTF8
                    
                    Write-Host "  ✓ " -ForegroundColor Green -NoNewline
                    Write-Host "$($file.Path): " -ForegroundColor White -NoNewline
                    Write-Host "$currentVersion → $NewVersion" -ForegroundColor Green
                }
            }
            $UpdatedCount++
        }
        else {
            Write-Host "  ✗ " -ForegroundColor Red -NoNewline
            Write-Host "$($file.Path) (pattern not found)" -ForegroundColor Gray
            $ErrorCount++
        }
    }

    # Also update VERSION.md if it exists
    $versionMdPath = Join-Path $RepoRoot 'VERSION.md'
    if (Test-Path $versionMdPath) {
        Write-Host ""
        Write-Host "  ┌────────────────────────────────────────────────────────────────────┐"
        Write-Host "  │  VERSION.MD                                                        │"
        Write-Host "  └────────────────────────────────────────────────────────────────────┘"
        Write-Host ""
        
        $versionContent = Get-Content $versionMdPath -Raw -Encoding UTF8
        
        # Check if current version entry exists at top
        if ($versionContent -match "^## \[$NewVersion\]") {
            Write-Host "  ○ " -ForegroundColor DarkGray -NoNewline
            Write-Host "VERSION.md already has entry for $NewVersion" -ForegroundColor Gray
        }
        else {
            Write-Host "  💡 " -ForegroundColor Yellow -NoNewline
            Write-Host "Remember to add changelog entry for $NewVersion in VERSION.md" -ForegroundColor Yellow
        }
    }

    # Summary
    Write-Host ""
    Write-Host "  ┌────────────────────────────────────────────────────────────────────┐"
    Write-Host "  │  SUMMARY                                                           │"
    Write-Host "  └────────────────────────────────────────────────────────────────────┘"
    Write-Host ""
    
    if ($DryRun) {
        Write-Host "  Would update: " -NoNewline -ForegroundColor Gray
        Write-Host "$UpdatedCount files" -ForegroundColor Cyan
    }
    else {
        Write-Host "  Updated: " -NoNewline -ForegroundColor Gray
        Write-Host "$UpdatedCount files" -ForegroundColor Green
    }
    
    Write-Host "  Skipped: " -NoNewline -ForegroundColor Gray
    Write-Host "$SkippedCount files" -ForegroundColor Gray
    
    if ($ErrorCount -gt 0) {
        Write-Host "  Errors: " -NoNewline -ForegroundColor Gray
        Write-Host "$ErrorCount files" -ForegroundColor Red
    }

    if (-not $DryRun -and $UpdatedCount -gt 0) {
        Write-Host ""
        Write-Host "  Next steps:" -ForegroundColor Gray
        Write-Host "    1. Review changes: " -ForegroundColor Gray -NoNewline
        Write-Host "git diff" -ForegroundColor White
        Write-Host "    2. Commit: " -ForegroundColor Gray -NoNewline
        Write-Host "git commit -am 'chore: bump version to $NewVersion'" -ForegroundColor White
        Write-Host "    3. Tag: " -ForegroundColor Gray -NoNewline
        Write-Host "git tag v$NewVersion" -ForegroundColor White
    }

    Write-Host ""
}
finally {
    Pop-Location
}
