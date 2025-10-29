# AgentMasta - Workspace Management Tool for Vibecoders

A command-line tool for quickly creating new workspace directories with automatic instructions files setup and VS Code integration.

## Features

- 🚀 Create new workspaces instantly: `agmst /my-project`
- 🔗 Auto-symlinks AGENTS.md and/or copilot-instructions.md
- � Instructions profiles support for different AI agents (!-profilename)
- �📁 Creates .github/ directory for copilot-instructions.md automatically
- 📝 Opens new workspace in VS Code automatically
- ⚙️ Embedded configuration (no external config file needed)
- 🌍 Cross-platform (macOS, Linux, Windows)
- 📦 Simple installation process

---

## Installation

### macOS / Linux / WSL

```bash
git clone https://github.com/xCORViSx/AgentMasta.git
cd [AgentMasta]
chmod +x agmst
./agmst install
```

The installer will:

1. Copy `agmst` to `/usr/local/bin`
2. Make it executable
3. Verify your PATH setup

### Windows (PowerShell)

```powershell
git clone https://github.com/xCORViSx/AgentMasta.git
cd [AgentMasta]
.\agmst.ps1 install
```

The installer will:

1. Copy `agmst.ps1` to `%USERPROFILE%\.local\bin`
2. Create a `agmst.bat` wrapper for easy command access
3. Add the directory to your PATH

**Note:** If you get an execution policy error, run PowerShell as Administrator and execute:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Manual Installation (Advanced)

**macOS / Linux / WSL:**

```bash
# Make script executable
chmod +x agmst

# Run self-installer
./agmst install
```

**Windows:**

```powershell
# Run self-installer
.\agmst.ps1 install
```

---

## Configuration

The workspace directory is **embedded directly in the agmst script** (no external config file needed). This means your configuration persists automatically and the tool has zero dependencies.

### View Current Workspace Directory

```bash
agmst wsdir
```

Output:

```text
📁 Current workspace directory: /Users/you/Documents/DEVshi
```

### Change Workspace Directory

```bash
agmst wsdir /path/to/new/workspace/dir
```

The script will update itself to use the new directory for all future workspace creations.

### Instructions Profiles

AgentMasta supports **instructions profiles** for different AI agents. Profiles are directories in `[AgentMasta]` that start with `!-` prefix.

**Setting up profiles:**

1. Create a directory in `[AgentMasta]` starting with `!-`:

   ```bash
   mkdir [AgentMasta]/!-snt4.5
   mkdir [AgentMasta]/!-gpt5
   mkdir [AgentMasta]/!-hku4.5
   ```

2. Place your instructions files in each profile directory:

   ```text
   [AgentMasta]/
   ├── !-snt4.5/
   │   └── AGENTS.md              # Sonnet 4.5 instructions
   ├── !-gpt5/
   │   └── copilot-instructions.md   # GPT-5 instructions
   └── !-hku4.5/
       └── AGENTS.md              # Haiku 4.5 instructions
   ```

3. Use profiles when creating workspaces or updating current workspace:

   ```bash
   agmst /my-project !-snt4.5     # Create with Sonnet profile
   agmst !-gpt5                   # Replace instructions in current workspace
   ```

**Default instructions:**

If no profile is specified, AgentMasta uses instructions files from the `[AgentMasta]` root directory.

---

## Usage

### Create a New Workspace

```bash
agmst /my-project
```

**Note:** Workspace names must start with `/` to distinguish them from profile commands.

This will:

1. Create a new directory at `${WORKSPACE_DIR}/my-project`
2. Create symlinks to your instructions files
   - For AGENTS.md: symlink in workspace root
   - For copilot-instructions.md: creates `.github/` and symlinks inside it
3. Open the workspace in VS Code

**Type Identifiers:** Use `A/` or `c/` prefixes to choose which root instructions file to use:

```bash
agmst A/my-project    # Creates workspace with AGENTS.md only (from root)
agmst c/my-project    # Creates workspace with copilot-instructions.md only (from root)
```

This is useful when you have both AGENTS.md and copilot-instructions.md in your [AgentMasta] root directory.

### Create Workspace with Instructions Profile

```bash
agmst /my-project !-snt4.5
```

Creates workspace using instructions from the `!-snt4.5` profile directory.

**Profile Types:**

- `!A-name` - AGENTS.md only (for agentic tools like MCP servers)
- `!c-name` - copilot-instructions.md only (for copilot-specific workflows)
- `!Ac-name` or `!cA-name` - Both files (for complete setups)
- `!-name` - User prompt to choose file type(s)

**Profile Storage:** All profile directories are stored as `!-name` format regardless of the command prefix used.

**Auto-Creation:** If a profile doesn't exist, it will be created automatically:

- `!A-` and `!c-` profiles: Creates the specified file type
- `!Ac-` and `!cA-` profiles: Creates both files
- `!-` profiles: Prompts you to choose which file(s) to create

**Content Copying:** New profiles intelligently copy content from root:

- If both root files exist: Copies content from the matching type
- If only one root file exists: Copies its content regardless of type
- If no root files exist: Creates empty file(s)

**Profile Copying:** Create new profiles from existing ones using the `=` syntax:

```bash
# Copy entire profile (all instruction files)
agmst /my-project !A-new=!-existing

# Copy and modify for different workspace
agmst !c-frontend=!-base-template
```

**How it works:**
- Creates new profile directory `!-new`
- Copies all instruction files from `!-existing`
- Preserves AGENTS.md and/or copilot-instructions.md from source
- Useful for creating variations of existing setups
- Can specify target file type (!A-, !c-, !Ac-) while copying from any source

**Example workflow:**
```bash
# 1. Create base profile with both files
agmst !Ac-base

# 2. Copy to create AGENTS.md-only variation
agmst !A-mcp-server=!-base

# 3. Copy to create copilot-only variation  
agmst !c-frontend=!-base

# 4. Use different profiles for different workspaces
agmst /server-project !-mcp-server
agmst /ui-project !-frontend
```

### Replace Instructions in Current Workspace

#### Using Instructions Profiles

```bash
agmst !-gpt5
```

Replaces instructions files in your current workspace with those from the `!-gpt5` profile.

#### Using Root Instructions Files

```bash
# Replace with all available root instructions files
agmst !

# Replace with AGENTS.md only from root
agmst !A

# Replace with copilot-instructions.md only from root
agmst !c
```

Replaces instructions files in your current workspace with those from the `[AgentMasta]` root directory (not a profile). This is useful for quickly reverting to your default instructions setup.

### Delete Workspaces and Profiles

```bash
# Delete a workspace
agmst del /my-project

# Delete an instructions profile
agmst del !-old-profile
```

The delete command:

- Shows what will be deleted (path and contents)
- Asks for confirmation before proceeding
- Lists files in profiles that will be deleted
- Supports aliases: `del`, `delete`, `rm`

### Manage Workspace Directory

```bash
# Show current workspace directory
agmst wsdir

# Change workspace directory
agmst wsdir /new/path
```

### View Profile Types

```bash
# Show all profiles with their instruction types
agmst proftypes
```

This displays an ls-like output showing which instruction file types each profile contains:

```text
📋 Instructions Profiles:

!-test                A
!-test2              Ac
!-gpt5                c

Legend: A = AGENTS.md only, c = copilot-instructions.md only, Ac = both files
```

### View Help

```bash
agmst help
# or
agmst --help
# or
agmst -h
```

### Check Version

```bash
agmst version
# or
agmst --version
# or
agmst -v
```

### Examples

```bash
# Create a Python project workspace with default instructions
agmst /python-api

# Create with type identifier (AGENTS.md only from root)
agmst A/python-api

# Create with type identifier (copilot-instructions.md only from root)
agmst c/react-frontend

# Create a React project workspace with Sonnet 4.5 profile
agmst /react-dashboard !-snt4.5

# Create AGENTS.md-only profile for an MCP server
agmst /mcp-filesystem !A-mcp-server

# Create copilot-only profile for frontend work
agmst /ui-components !c-react-patterns

# Create profile with both files
agmst /full-stack-app !Ac-complete

# Copy existing profile to create new variation
agmst !A-new-agent=!-base-template

# Use copied profile in workspace creation
agmst /agent-workspace !-new-agent

# Replace instructions in current workspace with GPT-5 profile
agmst !-gpt5

# Replace instructions with root files (both if available)
agmst !

# Replace instructions with AGENTS.md only from root
agmst !A

# Replace instructions with copilot-instructions.md only from root
agmst !c

# Delete a workspace
agmst del /old-project

# Delete an instructions profile
agmst del !-unused-profile

# View current workspace directory
agmst wsdir

# Change workspace directory
agmst wsdir ~/Projects
```

---

## How It Works

1. **Embedded Configuration**: The script stores the workspace directory directly in itself (no external config file)
2. **Directory Creation**: Creates the workspace directory at `${WORKSPACE_DIR}/${workspace_name}`
3. **Symlink Creation**: Creates symbolic links to your instructions files
   - AGENTS.md goes in workspace root
   - copilot-instructions.md goes in `.github/` directory
   - Both files can be symlinked simultaneously if both exist
4. **VS Code Integration**: Opens the new workspace in VS Code
5. **Profile System**: Optional instructions profiles for different AI agents

**Why Symlinks?**

- Your instructions files stay in one location
- Changes automatically appear in all workspaces
- No duplicate files or manual copying needed

**Note for Windows:** If symlink creation fails (requires admin privileges), files will be copied instead.

---

## Requirements

- **macOS/Linux/WSL:** Bash shell
- **Windows:** PowerShell 5.1 or later
- **VS Code** (optional): The tool opens workspaces in VS Code if available
  - If VS Code is not found, it will just create the workspace
  - Install VS Code CLI: [VS Code Documentation](https://code.visualstudio.com/docs/editor/command-line)

---

## Troubleshooting

### "command not found: agmst"

The installation directory is not in your PATH. Add it to your shell configuration:

```bash
# For bash (~/.bashrc or ~/.bash_profile)
export PATH="/usr/local/bin:$PATH"

# For zsh (~/.zshrc)
export PATH="/usr/local/bin:$PATH"
```

Then reload your shell:

```bash
source ~/.zshrc  # or ~/.bashrc
```

### "Instructions file not found"

Make sure you have AGENTS.md or copilot-instructions.md in the `[AgentMasta]` root directory, or use an instructions profile:

```bash
# Check if default instructions exist
ls [AgentMasta]/AGENTS.md
ls [AgentMasta]/copilot-instructions.md

# Or use a profile
agmst /my-project !-snt4.5
```

### "VS Code command 'code' not found"

Install the VS Code command-line tools:

1. Open VS Code
2. Press `Cmd+Shift+P` (macOS) or `Ctrl+Shift+P` (Linux/Windows)
3. Type "Shell Command: Install 'code' command in PATH"
4. Select it and restart your terminal

### Permission Denied

If you get permission errors during installation:

```bash
# Use sudo
sudo ./install.sh

# Or install to your local bin directory
mkdir -p ~/.local/bin
cp agmst ~/.local/bin/
chmod +x ~/.local/bin/agmst
export PATH="$HOME/.local/bin:$PATH"  # Add to shell config
```

---

## Uninstallation

**macOS / Linux / WSL:**

```bash
# Remove the script
sudo rm /usr/local/bin/agmst
```

**Windows:**

```powershell
# Remove the script
Remove-Item "$env:USERPROFILE\.local\bin\agmst.ps1"
Remove-Item "$env:USERPROFILE\.local\bin\agmst.bat"
```

---

## Repository Structure

```text
[AgentMasta]/
├── agmst                    # Bash CLI tool script (macOS/Linux/WSL)
├── agmst.ps1                # PowerShell CLI tool script (Windows)
├── AGENTS.md                # Example default instructions file
├── !-test/                  # Example instructions profile
│   └── AGENTS.md
├── REFERENCES.md            # Documentation citations
├── CHANGELOG.md             # Version history
├── ROADMAP.md               # Development roadmap
└── README.md                # This file
```

---

## Contributing

Contributions are welcome! To contribute:

1. Fork the repository
2. Create a feature branch
3. Make your changes with clear comments
4. Submit a pull request

---

## License

MIT License - free to use and modify.

## Support

- � **Issues:** Open an issue on GitHub
- 💡 **Feature Requests:** Open an issue with the "enhancement" label
- 📧 **Contact:** [Your contact information]

---

## Acknowledgments

Built with references from:

- Bash scripting best practices
- CLI design guidelines
- VS Code workspace management

See `REFERENCES.md` for complete citations.

---

### Made with ❤️ for developers

***Created by:*** Tradell

***Developed by:*** Claude Sonnet 4.5
