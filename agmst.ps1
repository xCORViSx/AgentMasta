# AgentMasta - Workspace Management Tool for Vibecoders (PowerShell Version)
# This script creates new workspaces with automatic AGENTS.md or copilot-instructions.md setup
# and provides workspace management features for AI-assisted development

# We define the version number for this CLI tool
$VERSION = "1.2.0"

# We determine where this script is installed
$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path

# We determine where the AgentMasta repository is located
# This line will be automatically updated during installation to point to the repo
$AGENTMASTA_ROOT = "__AGENTMASTA_ROOT_PLACEHOLDER__"

# If we're running from the repository (not installed), use SCRIPT_DIR as the root
if ($AGENTMASTA_ROOT -eq "__AGENTMASTA_ROOT_PLACEHOLDER__") {
    $AGENTMASTA_ROOT = $SCRIPT_DIR
}

# We embed the workspace directory directly in this script
# Users can change this with: agmst wsdir <path>
$WORKSPACE_DIR = Join-Path $env:USERPROFILE "Documents\DEVshi"

# This function shows the current workspace directory
function Show-WorkspaceDir {
    Write-Host "📁 Current workspace directory: $WORKSPACE_DIR"
}

# This function updates the workspace directory in this script
# We modify the script file itself to save the new path
function Set-WorkspaceDir {
    param([string]$NewDir)
    
    # We validate the new directory path
    if (-not (Test-Path $NewDir)) {
        Write-Host "❌ Error: Directory does not exist: $NewDir" -ForegroundColor Red
        exit 1
    }
    
    # We read the current script content
    $scriptPath = $MyInvocation.PSCommandPath
    $content = Get-Content $scriptPath -Raw
    
    # We update the WORKSPACE_DIR line using regex
    $newContent = $content -replace '(\$WORKSPACE_DIR = ).*', "`$1`"$NewDir`""
    
    # We write the updated content back to the script
    Set-Content $scriptPath $newContent -NoNewline
    
    Write-Host "✅ Workspace directory updated to: $NewDir" -ForegroundColor Green
    Write-Host "💡 Changes saved to script - will persist across sessions"
}

# This function displays usage information to help users understand the commands
function Show-Help {
    Write-Host @"
AgentMasta - Workspace Management Tool for Vibecoders [v$VERSION]

USAGE:
    agmst /workspace-name                   Create a new workspace with root instructions
    agmst A/workspace-name                  Create workspace with AGENTS.md only (from root)
    agmst c/workspace-name                  Create workspace with copilot-instructions.md only (from root)
    agmst /workspace-name !-profilename     Create a new workspace with instructions profile
    agmst !-profilename                     Replace instructions in current workspace with profile
    agmst del /workspace-name               Delete a workspace
    agmst del !-profilename                 Delete an instructions profile
    agmst wsdir                             Show current workspace directory
    agmst wsdir <path>                      Set workspace directory
    agmst install                           Install AgentMasta
    agmst uninstall                         Uninstall AgentMasta
    agmst help                              Show this help message
    agmst version                           Show version information

DESCRIPTION:
    Creates a new workspace folder with symlinks to your instructions files,
    and opens it in VS Code. Use / prefix for workspace names to distinguish
    them from profile commands.
    
    Type identifiers (A/ or c/) let you choose which root instructions file
    to use when creating workspaces. This is useful when you have both AGENTS.md
    and copilot-instructions.md in your [AgentMasta] root.
    
    Supports instructions profiles for different AI agents. Profiles are directories
    in [AgentMasta] that start with !- prefix (e.g., !-snt4.5, !-gpt5, !-hku4.5).
    
    For copilot-instructions.md, automatically creates .github/ directory.

INSTRUCTIONS PROFILES:
    Profiles let you maintain different instructions sets for different AI agents.
    All profile directories are stored as !-name format.
    
    Profile prefixes (for commands):
        !A-name                Create instructions profile with AGENTS.md only
        !c-name                Create instructions profile with copilot-instructions.md only
        !Ac-name OR !cA-name   Create instructions profile with both files
        !-name                 Use instructions profile. If non-existent, create it and prompt user for instructions type(s)
    
    Creating profiles:
        - Profiles auto-create if they don't exist
        - Profile directories always named !-name
        - Copy from root default instructions if available
        - Copy from another profile: !A-new=!-existing
        - Empty file created if no source available
    
    Examples:
        !A-snt4.5                          Create/use AGENTS.md profile
        !c-gpt5                            Create/use copilot profile
        !Ac-full                           Create/use both files profile
        !-custom                           Prompt for file type
        !A-new=!-existing                  Copy from existing profile

CONFIGURATION:
    Workspace directory is stored in the agmst.ps1 script itself.
    Default workspace directory: ~/Documents/DEVshi
    Use 'agmst wsdir <path>' to change where workspaces are created.
    
    Default instructions are read from [AgentMasta] root directory.

EXAMPLES:
    agmst /my-project                  # Creates workspace with root instructions (both files if both exist)
    agmst A/my-project                 # Creates workspace with AGENTS.md only (from root)
    agmst c/my-project                 # Creates workspace with copilot-instructions.md only (from root)
    agmst /my-project !A-snt4.5        # Creates workspace with AGENTS.md profile
    agmst /my-project !c-gpt5          # Creates workspace with copilot profile
    agmst !A-new=!-existing            # Replace instructions, copying from another profile
    agmst /!important-ws               # Creates workspace named "!important-ws" (! allowed with / prefix)
    agmst !A-gpt5                      # Replace instructions in current workspace
    agmst del /my-project              # Delete a workspace
    agmst del !-snt4.5                 # Delete an instructions profile
    agmst wsdir                        # Show workspace directory
    agmst wsdir C:\Projects            # Set workspace directory

GITHUB:
    https://github.com/xCORViSx/AgentMasta

"@
}

# This function displays the current version of the tool
function Show-Version {
    Write-Host "AgentMasta [v$VERSION]"
    Write-Host "Workspace Management Tool for Vibecoders"
}

# This function handles self-installation of the script
function Install-Self {
    Write-Host "📦 Installing AgentMasta CLI tool..." -ForegroundColor Cyan
    
    # We determine the installation directory
    $installDir = Join-Path $env:USERPROFILE ".local\bin"
    
    # We create the installation directory if it doesn't exist
    if (-not (Test-Path $installDir)) {
        Write-Host "📁 Creating installation directory: $installDir" -ForegroundColor Cyan
        New-Item -ItemType Directory -Path $installDir -Force | Out-Null
    }
    
    # We store the current repository location before installation
    $repoDir = $AGENTMASTA_ROOT
    
    # We get the current script path
    $scriptPath = $MyInvocation.PSCommandPath
    
    # We read the script content and replace the placeholder
    $scriptContent = Get-Content $scriptPath -Raw
    $scriptContent = $scriptContent -replace '__AGENTMASTA_ROOT_PLACEHOLDER__', $repoDir
    
    # We write the modified script to the installation directory
    $installedScript = Join-Path $installDir "agmst.ps1"
    Set-Content -Path $installedScript -Value $scriptContent
    
    # We create a batch file wrapper so users can type 'agmst' without .ps1
    $batchWrapper = Join-Path $installDir "agmst.bat"
    $batchContent = @"
@echo off
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$installDir\agmst.ps1" %*
"@
    Set-Content -Path $batchWrapper -Value $batchContent
    
    Write-Host "✅ agmst installed to $installDir" -ForegroundColor Green
    Write-Host "📁 Repository linked to: $repoDir" -ForegroundColor Cyan
    
    # We check if the installation directory is in PATH
    $currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if ($currentPath -notlike "*$installDir*") {
        Write-Host "⚠️  Installation directory is not in your PATH" -ForegroundColor Yellow
        Write-Host "📝 Adding $installDir to your PATH..." -ForegroundColor Cyan
        
        # We add the directory to the user's PATH
        $newPath = $currentPath + ";" + $installDir
        [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
        
        Write-Host "✅ PATH updated! Restart your terminal." -ForegroundColor Green
    } else {
        Write-Host "✅ Installation directory is already in your PATH" -ForegroundColor Green
    }
    
    Write-Host ""
    Write-Host "🎉 Installation complete!" -ForegroundColor Green
    Write-Host ""
    Write-Host "📖 Quick Start:" -ForegroundColor Cyan
    Write-Host "   1. Set workspace directory: agmst wsdir C:\Projects" -ForegroundColor White
    Write-Host "   2. Create a workspace: agmst /my-project" -ForegroundColor White
    Write-Host "   3. View help: agmst help" -ForegroundColor White
    
    exit 0
}

# This function handles uninstallation of the script
function Uninstall-Self {
    Write-Host "🗑️  Uninstalling AgentMasta CLI tool..." -ForegroundColor Cyan
    
    $installDir = Join-Path $env:USERPROFILE ".local\bin"
    $installPath = Join-Path $installDir "agmst.ps1"
    $batchWrapper = Join-Path $installDir "agmst.bat"
    
    # We check if agmst is installed
    if (-not (Test-Path $installPath)) {
        Write-Host "❌ agmst is not installed at $installPath" -ForegroundColor Red
        exit 1
    }
    
    # We ask for confirmation
    $response = Read-Host "Remove $installPath and $batchWrapper? (y/N)"
    if ($response -ne 'y' -and $response -ne 'Y') {
        Write-Host "❌ Cancelled" -ForegroundColor Red
        exit 1
    }
    
    # We remove the installed files
    Remove-Item $installPath -ErrorAction SilentlyContinue -Force
    Remove-Item $batchWrapper -ErrorAction SilentlyContinue -Force
    
    Write-Host "✅ AgentMasta uninstalled successfully" -ForegroundColor Green
    Write-Host "💡 Workspace directories and profiles remain unchanged" -ForegroundColor Cyan
    
    exit 0
}

# This function validates and creates profile directories if needed
# Profiles can start with !@- (AGENTS.md), !C- (copilot-instructions.md), !@C-/!C@- (both), or !- (prompt)
# All profile directories are stored as !-name regardless of command prefix
# Supports copying from another profile with = syntax: !@-new=!-existing
function Validate-Profile {
    param([string]$Profile)
    
    $profileName = ""
    $profileType = ""
    $sourceProfile = ""
    $wasCreated = $false
    $isCreationCommand = $false
    
    # We check if the profile uses = syntax to copy from another profile
    if ($Profile -match '^(![@C]+-[^=]+)=(!-[^=]+)$') {
        $Profile = $matches[1]
        $sourceProfile = $matches[2]
    }
    
    # We determine the profile type from the prefix and whether it's a creation command
    if ($Profile -match '^!@C-' -or $Profile -match '^!C@-') {
        $profileType = "both"
        $isCreationCommand = $true
        $profileName = $Profile -replace '^!@C-', '' -replace '^!C@-', ''
    }
    elseif ($Profile -match '^!@-') {
        $profileType = "agents"
        $isCreationCommand = $true
        $profileName = $Profile -replace '^!@-', ''
    }
    elseif ($Profile -match '^!C-') {
        $profileType = "copilot"
        $isCreationCommand = $true
        $profileName = $Profile -replace '^!C-', ''
    }
    elseif ($Profile -match '^!-') {
        $profileType = "prompt"
        $isCreationCommand = $false
        $profileName = $Profile -replace '^!-', ''
    }
    else {
        Write-Host "❌ Error: Profile must start with !@- (AGENTS.md), !C- (copilot), !@C-/!C@- (both), or !- (prompt)" -ForegroundColor Red
        Write-Host "💡 Examples: !@-snt4.5, !C-gpt5, !@C-full, !-custom" -ForegroundColor Cyan
        return $null
    }
    
    # We construct the full path to the profile directory
    $profilePath = Join-Path $AGENTMASTA_ROOT "!-$profileName"
    
    # We check if this is a creation command but profile already exists
    if ($isCreationCommand -and (Test-Path $profilePath -PathType Container)) {
        Write-Host "⚠️  Profile !-$profileName already exists" -ForegroundColor Yellow
        Write-Host "" -ForegroundColor White
        Write-Host "Choose an option:" -ForegroundColor Cyan
        Write-Host "  1) Use existing profile" -ForegroundColor White
        Write-Host "  2) Replace with new profile" -ForegroundColor White
        Write-Host "  C) Cancel" -ForegroundColor White
        $choice = Read-Host "Choose (1/2/C)"
        
        switch ($choice) {
            "1" {
                Write-Host "✅ Using existing profile !-$profileName" -ForegroundColor Green
                # Continue with existing profile - skip creation
            }
            "2" {
                Write-Host "🗑️  Replacing profile !-$profileName..." -ForegroundColor Yellow
                Remove-Item $profilePath -Recurse -Force
                $wasCreated = $true
                # Will create new profile below
            }
            { $_ -match "^[Cc]$" } {
                Write-Host "❌ Cancelled" -ForegroundColor Red
                return $null
            }
            default {
                Write-Host "❌ Invalid choice. Cancelled" -ForegroundColor Red
                return $null
            }
        }
    }
    
    # We check if the profile directory exists or needs to be created
    if (-not (Test-Path $profilePath -PathType Container) -or $wasCreated) {
        # For prompt-type (!-), inform user that profile doesn't exist first
        if ($profileType -eq "prompt" -and -not $wasCreated) {
            Write-Host "⚠️  Profile !-$profileName doesn't exist" -ForegroundColor Yellow
            Write-Host "📋 Create new instructions profile?" -ForegroundColor Cyan
            Write-Host "" -ForegroundColor White
        }
        
        # Mark as created if it wasn't already
        if (-not $wasCreated) {
            $wasCreated = $true
        }
        
        # Create directory if it doesn't exist
        New-Item -ItemType Directory -Path $profilePath -Force | Out-Null
        
        # We determine what to copy based on source
        if ($sourceProfile) {
            # Copy from another profile
            $sourcePath = Join-Path $AGENTMASTA_ROOT $sourceProfile
            if (-not (Test-Path $sourcePath -PathType Container)) {
                Write-Host "❌ Error: Source profile $sourceProfile not found" -ForegroundColor Red
                Remove-Item $profilePath -Force
                return $null
            }
            
            # We copy all instructions files from source profile
            $copied = $false
            $sourceAgents = Join-Path $sourcePath "AGENTS.md"
            $sourceCopilot = Join-Path $sourcePath "copilot-instructions.md"
            
            if (Test-Path $sourceAgents) {
                Copy-Item $sourceAgents -Destination (Join-Path $profilePath "AGENTS.md")
                Write-Host "✅ Copied AGENTS.md from $sourceProfile" -ForegroundColor Green
                $copied = $true
            }
            if (Test-Path $sourceCopilot) {
                Copy-Item $sourceCopilot -Destination (Join-Path $profilePath "copilot-instructions.md")
                Write-Host "✅ Copied copilot-instructions.md from $sourceProfile" -ForegroundColor Green
                $copied = $true
            }
            
            if (-not $copied) {
                Write-Host "❌ Error: Source profile $sourceProfile has no instructions files" -ForegroundColor Red
                Remove-Item $profilePath -Force
                return $null
            }
        }
        else {
            # Create new profile - determine file type to create
            $fileType = $profileType
            if ($profileType -eq "prompt") {
                # Ask user which type they want
                Write-Host "Which instructions file type?" -ForegroundColor Cyan
                Write-Host "  1) AGENTS.md" -ForegroundColor White
                Write-Host "  2) copilot-instructions.md" -ForegroundColor White
                Write-Host "  3) Both" -ForegroundColor White
                Write-Host "  D) Don't create" -ForegroundColor White
                $choice = Read-Host "Choose (1/2/3/D)"
                switch ($choice) {
                    "1" { $fileType = "agents" }
                    "2" { $fileType = "copilot" }
                    "3" { $fileType = "both" }
                    {$_ -in "D","d"} { 
                        Write-Host "❌ Cancelled" -ForegroundColor Red
                        Remove-Item $profilePath -Force
                        return $null
                    }
                    default { $fileType = "agents" }
                }
            }
            
            # We determine what content to copy from root
            $rootAgents = Join-Path $AGENTMASTA_ROOT "AGENTS.md"
            $rootCopilot = Join-Path $AGENTMASTA_ROOT "copilot-instructions.md"
            $hasAgentsRoot = Test-Path $rootAgents
            $hasCopilotRoot = Test-Path $rootCopilot
            
            # We create the appropriate instructions file(s) and copy content
            if ($fileType -eq "agents" -or $fileType -eq "both") {
                # We determine what content to copy for AGENTS.md
                if ($hasAgentsRoot -and $hasCopilotRoot) {
                    # Both exist in root - copy from matching type (AGENTS.md)
                    Copy-Item $rootAgents -Destination (Join-Path $profilePath "AGENTS.md")
                    Write-Host "✅ Created AGENTS.md (copied from root AGENTS.md)" -ForegroundColor Green
                }
                elseif ($hasAgentsRoot) {
                    # Only AGENTS.md in root - copy it
                    Copy-Item $rootAgents -Destination (Join-Path $profilePath "AGENTS.md")
                    Write-Host "✅ Created AGENTS.md (copied from root AGENTS.md)" -ForegroundColor Green
                }
                elseif ($hasCopilotRoot) {
                    # Only copilot in root - copy its content to AGENTS.md
                    Copy-Item $rootCopilot -Destination (Join-Path $profilePath "AGENTS.md")
                    Write-Host "✅ Created AGENTS.md (copied content from root copilot-instructions.md)" -ForegroundColor Green
                }
                else {
                    # No root files - create empty
                    New-Item -ItemType File -Path (Join-Path $profilePath "AGENTS.md") -Force | Out-Null
                    Write-Host "✅ Created empty AGENTS.md" -ForegroundColor Green
                }
            }
            
            if ($fileType -eq "copilot" -or $fileType -eq "both") {
                # We determine what content to copy for copilot-instructions.md
                if ($hasAgentsRoot -and $hasCopilotRoot) {
                    # Both exist in root - copy from matching type (copilot-instructions.md)
                    Copy-Item $rootCopilot -Destination (Join-Path $profilePath "copilot-instructions.md")
                    Write-Host "✅ Created copilot-instructions.md (copied from root copilot-instructions.md)" -ForegroundColor Green
                }
                elseif ($hasCopilotRoot) {
                    # Only copilot in root - copy it
                    Copy-Item $rootCopilot -Destination (Join-Path $profilePath "copilot-instructions.md")
                    Write-Host "✅ Created copilot-instructions.md (copied from root copilot-instructions.md)" -ForegroundColor Green
                }
                elseif ($hasAgentsRoot) {
                    # Only AGENTS.md in root - copy its content to copilot-instructions.md
                    Copy-Item $rootAgents -Destination (Join-Path $profilePath "copilot-instructions.md")
                    Write-Host "✅ Created copilot-instructions.md (copied content from root AGENTS.md)" -ForegroundColor Green
                }
                else {
                    # No root files - create empty
                    New-Item -ItemType File -Path (Join-Path $profilePath "copilot-instructions.md") -Force | Out-Null
                    Write-Host "✅ Created empty copilot-instructions.md" -ForegroundColor Green
                }
            }
            
            Write-Host "" -ForegroundColor White
            Write-Host "💡 Tip: Explicitly define instructions file(s) desired in new instructions profile:" -ForegroundColor Cyan
            Write-Host "   !@-profilename for AGENTS.md only" -ForegroundColor White
            Write-Host "   !C-profilename for copilot-instructions.md only" -ForegroundColor White
            Write-Host "   !@C-profilename or !C@-profilename for both files" -ForegroundColor White
            Write-Host "   !-profilename for user prompt (if profile non-existent)" -ForegroundColor White
            Write-Host "💡 Append '=' to copy an existing profile: !@-new=!-existing" -ForegroundColor Cyan
            Write-Host "" -ForegroundColor White
        }
    }
    
    # We verify the profile now has at least one instructions file
    $hasAgents = Test-Path (Join-Path $profilePath "AGENTS.md")
    $hasCopilot = Test-Path (Join-Path $profilePath "copilot-instructions.md")
    
    if (-not ($hasAgents -or $hasCopilot)) {
        Write-Host "❌ Error: Profile !-$profileName has no instructions files" -ForegroundColor Red
        return $null
    }
    
    # We return the valid profile path and whether it was created
    return @{
        Path = $profilePath
        WasCreated = $wasCreated
    }
}

# This function creates symlinks for instruction files from a profile or default location
# Supports filtering by type: "agents" (AGENTS.md only), "copilot" (copilot-instructions.md only), or "both" (default)
function Create-InstructionSymlinks {
    param(
        [string]$WorkspacePath,
        [string]$InstructionsSourceDir,
        [string]$FileType = "both"  # Default to both if not specified
    )
    
    # We determine the source description for display
    $sourceDescription = ""
    $dirBasename = Split-Path -Leaf $InstructionsSourceDir
    if ($dirBasename -match "^!-") {
        # It's a profile directory (basename starts with !-)
        $sourceDescription = "from instructions profile: '$dirBasename'"
    } else {
        # It's the root directory
        $sourceDescription = "from [AgentMasta] root"
    }
    
    # We check for AGENTS.md and symlink it to workspace root (if type allows)
    $agentsPath = Join-Path $InstructionsSourceDir "AGENTS.md"
    if ((Test-Path $agentsPath) -and ($FileType -eq "agents" -or $FileType -eq "both")) {
        $symlinkPath = Join-Path $WorkspacePath "AGENTS.md"
        Write-Host "🔗 Creating symlink to AGENTS.md ($sourceDescription)..." -ForegroundColor Cyan
        
        try {
            New-Item -ItemType SymbolicLink -Path $symlinkPath -Target $agentsPath -Force | Out-Null
        } catch {
            Write-Host "⚠️  Could not create symlink (may need admin privileges). Copying file instead..." -ForegroundColor Yellow
            Copy-Item $agentsPath -Destination $symlinkPath -Force
        }
    }
    
    # We check for copilot-instructions.md and symlink it to .github/ directory (if type allows)
    $copilotPath = Join-Path $InstructionsSourceDir "copilot-instructions.md"
    if ((Test-Path $copilotPath) -and ($FileType -eq "copilot" -or $FileType -eq "both")) {
        $githubDir = Join-Path $WorkspacePath ".github"
        Write-Host "📁 Creating .github directory for copilot-instructions.md..." -ForegroundColor Cyan
        New-Item -ItemType Directory -Path $githubDir -Force | Out-Null
        
        $symlinkPath = Join-Path $githubDir "copilot-instructions.md"
        Write-Host "🔗 Creating symlink to copilot-instructions.md ($sourceDescription)..." -ForegroundColor Cyan
        
        try {
            New-Item -ItemType SymbolicLink -Path $symlinkPath -Target $copilotPath -Force | Out-Null
        } catch {
            Write-Host "⚠️  Could not create symlink (may need admin privileges). Copying file instead..." -ForegroundColor Yellow
            Copy-Item $copilotPath -Destination $symlinkPath -Force
        }
    }
}

# This function replaces instruction symlinks in the current workspace
function Replace-InstructionsInCurrent {
    param([string]$Profile)
    
    # We validate the profile
    $profileResult = Validate-Profile -Profile $Profile
    if (-not $profileResult) {
        exit 1
    }
    
    $profilePath = $profileResult.Path
    
    # We extract just the profile directory name for display
    $profileDisplay = Split-Path -Leaf $profilePath
    
    # We show appropriate message based on whether profile was created
    if ($profileResult.WasCreated) {
        Write-Host "📋 Created new profile: $profileDisplay" -ForegroundColor Cyan
    }
    
    # We check if we're in a directory (current workspace)
    $currentDir = Get-Location
    
    # We ask for confirmation before replacing
    Write-Host "📋 Current directory: $currentDir" -ForegroundColor Cyan
    Write-Host "🔄 This will replace instruction symlinks with profile: $profileDisplay" -ForegroundColor Yellow
    $response = Read-Host "Continue? (y/N)"
    if ($response -ne 'y' -and $response -ne 'Y') {
        Write-Host "❌ Cancelled" -ForegroundColor Red
        exit 1
    }
    
    # We remove existing instruction symlinks/files
    Write-Host "🗑️  Removing existing instruction files..." -ForegroundColor Cyan
    Remove-Item (Join-Path $currentDir "AGENTS.md") -ErrorAction SilentlyContinue -Force
    Remove-Item (Join-Path $currentDir ".github\copilot-instructions.md") -ErrorAction SilentlyContinue -Force
    
    # We create new symlinks from the profile
    Create-InstructionSymlinks -WorkspacePath $currentDir -InstructionsSourceDir $profilePath
    
    Write-Host "✅ Instructions replaced with profile: $profileDisplay" -ForegroundColor Green
}

# This function creates a new workspace with optional profile and optional type filter
# Type prefix A/ creates AGENTS.md only, c/ creates copilot-instructions.md only
function Create-Workspace {
    param(
        [string]$WorkspaceName,
        [string]$Profile = ""
    )
    
    # We validate that a workspace name was provided
    if (-not $WorkspaceName) {
        Write-Host "❌ Error: No workspace name provided" -ForegroundColor Red
        Write-Host "Usage: agmst <workspace-name>"
        exit 1
    }
    
    # We set the default file type
    $fileType = "both"
    
    # We check if workspace_name has a type prefix (A/ or c/)
    if ($WorkspaceName -match "^A/(.+)$") {
        $fileType = "agents"
        $WorkspaceName = $matches[1]  # Remove A/ prefix
    } elseif ($WorkspaceName -match "^c/(.+)$") {
        $fileType = "copilot"
        $WorkspaceName = $matches[1]  # Remove c/ prefix
    }
    
    # We construct the full path to the new workspace
    $workspacePath = Join-Path $WORKSPACE_DIR $WorkspaceName
    
    # We check if the workspace directory already exists
    if (Test-Path $workspacePath) {
        Write-Host "❌ Error: Workspace '$WorkspaceName' already exists at: $workspacePath" -ForegroundColor Red
        exit 1
    }
    
    # We determine the instructions source directory
    if ($Profile) {
        # We validate and use the profile
        $profileResult = Validate-Profile -Profile $Profile
        if (-not $profileResult) {
            exit 1
        }
        
        $instructionsSourceDir = $profileResult.Path
        
        # Note: We don't show "Creating/Using profile" here as the symlink message already indicates the source
    } else {
        # We use the default instructions directory (repo root)
        $instructionsSourceDir = $AGENTMASTA_ROOT
        
        # We check if the requested file type exists in repo root
        $hasAgents = Test-Path (Join-Path $AGENTMASTA_ROOT "AGENTS.md")
        $hasCopilot = Test-Path (Join-Path $AGENTMASTA_ROOT "copilot-instructions.md")
        
        $hasRequestedFile = $false
        if ($fileType -eq "agents" -and $hasAgents) {
            $hasRequestedFile = $true
        } elseif ($fileType -eq "copilot" -and $hasCopilot) {
            $hasRequestedFile = $true
        } elseif ($fileType -eq "both" -and ($hasAgents -or $hasCopilot)) {
            $hasRequestedFile = $true
        }
        
        if (-not $hasRequestedFile) {
            if ($fileType -eq "agents") {
                # Check if copilot-instructions.md exists for option 2
                $hasCopilotAlternative = Test-Path "$AGENTMASTA_ROOT\copilot-instructions.md"
                
                if ($hasCopilotAlternative) {
                    Write-Host "⚠️  Warning: No AGENTS.md found in [AgentMasta] root (but copilot-instructions.md exists)" -ForegroundColor Yellow
                } else {
                    Write-Host "⚠️  Warning: No AGENTS.md found in [AgentMasta] root (or alternative copilot-instructions.md)" -ForegroundColor Yellow
                }
                Write-Host ""
                
                Write-Host "Choose an option:"
                Write-Host "  1) Create empty AGENTS.md in [AgentMasta] root"
                if ($hasCopilotAlternative) {
                    Write-Host "  2) Copy contents from copilot-instructions.md to new AGENTS.md"
                    Write-Host "  3) Continue without instructions file"
                    Write-Host "  C) Cancel"
                    $choice = Read-Host "Choose (1/2/3/C)"
                } else {
                    Write-Host "  2) Continue without instructions file"
                    Write-Host "  C) Cancel"
                    $choice = Read-Host "Choose (1/2/C)"
                }
                
                switch ($choice) {
                    "1" {
                        New-Item -Path "$AGENTMASTA_ROOT\AGENTS.md" -ItemType File -Force | Out-Null
                        Write-Host "✅ Created empty AGENTS.md in [AgentMasta] root" -ForegroundColor Green
                    }
                    "2" {
                        if ($hasCopilotAlternative) {
                            Copy-Item -Path "$AGENTMASTA_ROOT\copilot-instructions.md" -Destination "$AGENTMASTA_ROOT\AGENTS.md"
                            Write-Host "✅ Created AGENTS.md with contents from copilot-instructions.md" -ForegroundColor Green
                        } else {
                            Write-Host "⚠️  Continuing without instructions file..." -ForegroundColor Yellow
                        }
                    }
                    "3" {
                        if ($hasCopilotAlternative) {
                            Write-Host "⚠️  Continuing without instructions file..." -ForegroundColor Yellow
                        } else {
                            Write-Host "❌ Invalid choice. Cancelled" -ForegroundColor Red
                            exit 1
                        }
                    }
                    { $_ -eq "C" -or $_ -eq "c" } {
                        Write-Host "❌ Cancelled" -ForegroundColor Red
                        exit 1
                    }
                    default {
                        Write-Host "❌ Invalid choice. Cancelled" -ForegroundColor Red
                        exit 1
                    }
                }
            } elseif ($fileType -eq "copilot") {
                # Check if AGENTS.md exists for option 2
                $hasAgentsAlternative = Test-Path "$AGENTMASTA_ROOT\AGENTS.md"
                
                if ($hasAgentsAlternative) {
                    Write-Host "⚠️  Warning: No copilot-instructions.md found in [AgentMasta] root (but AGENTS.md exists)" -ForegroundColor Yellow
                } else {
                    Write-Host "⚠️  Warning: No copilot-instructions.md found in [AgentMasta] root (or alternative AGENTS.md)" -ForegroundColor Yellow
                }
                Write-Host ""
                
                Write-Host "Choose an option:"
                Write-Host "  1) Create empty copilot-instructions.md in [AgentMasta] root"
                if ($hasAgentsAlternative) {
                    Write-Host "  2) Copy contents from AGENTS.md to new copilot-instructions.md"
                    Write-Host "  3) Continue without instructions file"
                    Write-Host "  C) Cancel"
                    $choice = Read-Host "Choose (1/2/3/C)"
                } else {
                    Write-Host "  2) Continue without instructions file"
                    Write-Host "  C) Cancel"
                    $choice = Read-Host "Choose (1/2/C)"
                }
                
                switch ($choice) {
                    "1" {
                        New-Item -Path "$AGENTMASTA_ROOT\copilot-instructions.md" -ItemType File -Force | Out-Null
                        Write-Host "✅ Created empty copilot-instructions.md in [AgentMasta] root" -ForegroundColor Green
                    }
                    "2" {
                        if ($hasAgentsAlternative) {
                            Copy-Item -Path "$AGENTMASTA_ROOT\AGENTS.md" -Destination "$AGENTMASTA_ROOT\copilot-instructions.md"
                            Write-Host "✅ Created copilot-instructions.md with contents from AGENTS.md" -ForegroundColor Green
                        } else {
                            Write-Host "⚠️  Continuing without instructions file..." -ForegroundColor Yellow
                        }
                    }
                    "3" {
                        if ($hasAgentsAlternative) {
                            Write-Host "⚠️  Continuing without instructions file..." -ForegroundColor Yellow
                        } else {
                            Write-Host "❌ Invalid choice. Cancelled" -ForegroundColor Red
                            exit 1
                        }
                    }
                    { $_ -eq "C" -or $_ -eq "c" } {
                        Write-Host "❌ Cancelled" -ForegroundColor Red
                        exit 1
                    }
                    default {
                        Write-Host "❌ Invalid choice. Cancelled" -ForegroundColor Red
                        exit 1
                    }
                }
            } else {
                Write-Host "⚠️  Warning: No instructions files found in [AgentMasta] root" -ForegroundColor Yellow
                Write-Host ""
                Write-Host "Choose an option:"
                Write-Host "  1) Create empty AGENTS.md"
                Write-Host "  2) Create empty copilot-instructions.md"
                Write-Host "  3) Create both files"
                Write-Host "  4) Continue without instructions files"
                Write-Host "  C) Cancel"
                $choice = Read-Host "Choose (1/2/3/4/C)"
                switch ($choice) {
                    "1" {
                        New-Item -Path "$AGENTMASTA_ROOT\AGENTS.md" -ItemType File -Force | Out-Null
                        Write-Host "✅ Created empty AGENTS.md in [AgentMasta] root" -ForegroundColor Green
                    }
                    "2" {
                        New-Item -Path "$AGENTMASTA_ROOT\copilot-instructions.md" -ItemType File -Force | Out-Null
                        Write-Host "✅ Created empty copilot-instructions.md in [AgentMasta] root" -ForegroundColor Green
                    }
                    "3" {
                        New-Item -Path "$AGENTMASTA_ROOT\AGENTS.md" -ItemType File -Force | Out-Null
                        New-Item -Path "$AGENTMASTA_ROOT\copilot-instructions.md" -ItemType File -Force | Out-Null
                        Write-Host "✅ Created empty AGENTS.md and copilot-instructions.md in [AgentMasta] root" -ForegroundColor Green
                    }
                    "4" {
                        Write-Host "⚠️  Continuing without instructions files..." -ForegroundColor Yellow
                    }
                    { $_ -eq "C" -or $_ -eq "c" } {
                        Write-Host "❌ Cancelled" -ForegroundColor Red
                        exit 1
                    }
                    default {
                        Write-Host "❌ Invalid choice. Cancelled" -ForegroundColor Red
                        exit 1
                    }
                }
            }
        }
    }
    
    # We create the workspace directory
    Write-Host "📁 Creating workspace directory: $workspacePath" -ForegroundColor Cyan
    New-Item -ItemType Directory -Path $workspacePath -Force | Out-Null
    
    # We create symlinks from the determined source directory with file type filter
    Create-InstructionSymlinks -WorkspacePath $workspacePath -InstructionsSourceDir $instructionsSourceDir -FileType $fileType
    
    # We check if VS Code is available
    if (Get-Command code -ErrorAction SilentlyContinue) {
        # We open the workspace in VS Code
        Write-Host "🚀 Opening workspace in VS Code..." -ForegroundColor Cyan
        & code $workspacePath
        Write-Host "✅ Workspace '$WorkspaceName' created and opened successfully!" -ForegroundColor Green
    } else {
        # We inform the user that VS Code wasn't found
        Write-Host "⚠️  VS Code command 'code' not found in PATH" -ForegroundColor Yellow
        Write-Host "✅ Workspace '$WorkspaceName' created at: $workspacePath" -ForegroundColor Green
        Write-Host "💡 Tip: Install VS Code and add it to PATH" -ForegroundColor Cyan
    }
}

# This function deletes a workspace directory
function Delete-Workspace {
    param(
        [string]$WorkspaceName
    )
    
    # We construct the full path to the workspace
    $workspacePath = Join-Path $WORKSPACE_DIR $WorkspaceName
    
    # We check if the workspace directory exists
    if (-not (Test-Path $workspacePath)) {
        Write-Host "❌ Error: Workspace '$WorkspaceName' doesn't exist at: $workspacePath" -ForegroundColor Red
        exit 1
    }
    
    # We show what will be deleted and ask for confirmation
    Write-Host "⚠️  About to delete workspace: $WorkspaceName" -ForegroundColor Yellow
    Write-Host "📁 Path: $workspacePath" -ForegroundColor Cyan
    $confirmation = Read-Host "Are you sure? (y/N)"
    
    if ($confirmation -ne 'y' -and $confirmation -ne 'Y') {
        Write-Host "❌ Cancelled" -ForegroundColor Red
        exit 1
    }
    
    # We delete the workspace directory
    Remove-Item -Path $workspacePath -Recurse -Force
    Write-Host "✅ Workspace '$WorkspaceName' deleted successfully" -ForegroundColor Green
}

# This function deletes an instructions profile
function Delete-Profile {
    param(
        [string]$ProfileName
    )
    
    # We normalize the profile name to !-name format
    if ($ProfileName -match '^![Ac]*-(.+)$') {
        # Extract the name part after the prefix
        $ProfileName = $matches[1]
    } elseif ($ProfileName -match '^!-(.+)$') {
        # Already in !-name format, extract just the name
        $ProfileName = $matches[1]
    }
    
    # We construct the profile directory path (always !-name format)
    $profilePath = Join-Path $AGENTMASTA_ROOT "!-$ProfileName"
    
    # We check if the profile exists
    if (-not (Test-Path $profilePath)) {
        Write-Host "❌ Error: Profile '!-$ProfileName' doesn't exist" -ForegroundColor Red
        exit 1
    }
    
    # We show what will be deleted and ask for confirmation
    Write-Host "⚠️  About to delete profile: !-$ProfileName" -ForegroundColor Yellow
    Write-Host "📁 Path: $profilePath" -ForegroundColor Cyan
    
    # We list the files that will be deleted
    $hasAgents = Test-Path (Join-Path $profilePath "AGENTS.md")
    $hasCopilot = Test-Path (Join-Path $profilePath ".github\copilot-instructions.md")
    
    if ($hasAgents -or $hasCopilot) {
        Write-Host "📄 Contains:" -ForegroundColor Cyan
        if ($hasAgents) { Write-Host "   - AGENTS.md" }
        if ($hasCopilot) { Write-Host "   - copilot-instructions.md" }
    }
    
    $confirmation = Read-Host "Are you sure? (y/N)"
    
    if ($confirmation -ne 'y' -and $confirmation -ne 'Y') {
        Write-Host "❌ Cancelled" -ForegroundColor Red
        exit 1
    }
    
    # We delete the profile directory
    Remove-Item -Path $profilePath -Recurse -Force
    Write-Host "✅ Profile '!-$ProfileName' deleted successfully" -ForegroundColor Green
}

# This is the main entry point of the script
# We parse the command-line arguments and route to the appropriate function
function Main {
    param(
        [string]$Command,
        [string]$SubCommand
    )
    
    # We handle different commands
    switch ($Command) {
        "" {
            Show-Help
        }
        "help" {
            Show-Help
        }
        "--help" {
            Show-Help
        }
        "-h" {
            Show-Help
        }
        "version" {
            Show-Version
        }
        "--version" {
            Show-Version
        }
        "-v" {
            Show-Version
        }
        "install" {
            Install-Self
        }
        "uninstall" {
            Uninstall-Self
        }
        "del" {
            if (-not $SubCommand) {
                Write-Host "❌ Error: Missing argument for del command" -ForegroundColor Red
                Write-Host "💡 Usage: agmst del /workspace-name  OR  agmst del !-profilename" -ForegroundColor Cyan
                exit 1
            }
            
            if ($SubCommand -match '^/') {
                # Delete workspace (remove leading /)
                Delete-Workspace -WorkspaceName $SubCommand.Substring(1)
            } elseif ($SubCommand -match '^![Ac]*-') {
                # Delete profile
                Delete-Profile -ProfileName $SubCommand
            } else {
                Write-Host "❌ Error: Invalid argument for del command: $SubCommand" -ForegroundColor Red
                Write-Host "💡 Workspace names must start with / (e.g., agmst del /my-project)" -ForegroundColor Cyan
                Write-Host "💡 Profile names must start with !A-, !c-, or !- (e.g., agmst del !-snt4.5)" -ForegroundColor Cyan
                exit 1
            }
        }
        "delete" {
            if (-not $SubCommand) {
                Write-Host "❌ Error: Missing argument for del command" -ForegroundColor Red
                Write-Host "💡 Usage: agmst del /workspace-name  OR  agmst del !-profilename" -ForegroundColor Cyan
                exit 1
            }
            
            if ($SubCommand -match '^/') {
                # Delete workspace (remove leading /)
                Delete-Workspace -WorkspaceName $SubCommand.Substring(1)
            } elseif ($SubCommand -match '^![Ac]*-') {
                # Delete profile
                Delete-Profile -ProfileName $SubCommand
            } else {
                Write-Host "❌ Error: Invalid argument for del command: $SubCommand" -ForegroundColor Red
                Write-Host "💡 Workspace names must start with / (e.g., agmst del /my-project)" -ForegroundColor Cyan
                Write-Host "💡 Profile names must start with !A-, !c-, or !- (e.g., agmst del !-snt4.5)" -ForegroundColor Cyan
                exit 1
            }
        }
        "rm" {
            if (-not $SubCommand) {
                Write-Host "❌ Error: Missing argument for del command" -ForegroundColor Red
                Write-Host "💡 Usage: agmst del /workspace-name  OR  agmst del !-profilename" -ForegroundColor Cyan
                exit 1
            }
            
            if ($SubCommand -match '^/') {
                # Delete workspace (remove leading /)
                Delete-Workspace -WorkspaceName $SubCommand.Substring(1)
            } elseif ($SubCommand -match '^![Ac]*-') {
                # Delete profile
                Delete-Profile -ProfileName $SubCommand
            } else {
                Write-Host "❌ Error: Invalid argument for del command: $SubCommand" -ForegroundColor Red
                Write-Host "💡 Workspace names must start with / (e.g., agmst del /my-project)" -ForegroundColor Cyan
                Write-Host "💡 Profile names must start with !A-, !c-, or !- (e.g., agmst del !-snt4.5)" -ForegroundColor Cyan
                exit 1
            }
        }
        "wsdir" {
            if ($SubCommand) {
                Set-WorkspaceDir -NewDir $SubCommand
            } else {
                Show-WorkspaceDir
            }
        }
        default {
            # We check if the command starts with profile prefixes (profile for current workspace)
            if ($Command -match '^!Ac-' -or $Command -match '^!cA-' -or $Command -match '^![Ac]-') {
                Replace-InstructionsInCurrent -Profile $Command
            }
            # We check if command starts with A/ or c/ (typed workspace name)
            elseif ($Command -match '^A/' -or $Command -match '^c/') {
                if ($SubCommand -match '^![Ac]*-') {
                    # Create workspace with profile (type prefix ignored when profile specified)
                    $workspaceName = $Command.Substring(2)  # Remove type prefix
                    Create-Workspace -WorkspaceName $workspaceName -Profile $SubCommand
                }
                else {
                    # Create workspace with type filter from root
                    Create-Workspace -WorkspaceName $Command
                }
            }
            # We check if command starts with / (workspace name)
            elseif ($Command -match '^/') {
                # Remove leading / from workspace name
                $workspaceName = $Command.Substring(1)
                
                if ($SubCommand -match '^![Ac]*-') {
                    # Create workspace with profile
                    Create-Workspace -WorkspaceName $workspaceName -Profile $SubCommand
                }
                else {
                    # Create workspace with default instructions
                    Create-Workspace -WorkspaceName $workspaceName
                }
            }
            else {
                # Unrecognized command
                Write-Host "❌ Error: Unrecognized command: $Command" -ForegroundColor Red
                Write-Host "💡 Workspace names must start with / (e.g., agmst /my-project)" -ForegroundColor Cyan
                Write-Host "💡 Run 'agmst help' for usage information" -ForegroundColor Cyan
                exit 1
            }
        }
    }
}

# We call the main function with script arguments
Main -Command $args[0] -SubCommand $args[1]
