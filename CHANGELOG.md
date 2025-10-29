# Changelog

All notable changes to the AgentMasta project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.2.0] - 2025-10-28

### Added

- **Workspace Type Identifiers**: Added `A/` and `c/` prefixes for selective root instructions
  - `agmst A/workspace-name` creates workspace with AGENTS.md only (from root)
  - `agmst c/workspace-name` creates workspace with copilot-instructions.md only (from root)
  - Useful when you have both instructions files in [AgentMasta] root
  - Type filtering in `create_instruction_symlinks` function with `$fileType` parameter
  - Smart file validation that checks for requested type before proceeding
- Help documentation updated with type identifier usage examples
- README examples showing type identifier functionality

### Changed

- `create_instruction_symlinks` function now accepts optional `$fileType` parameter ("agents", "copilot", or "both")
- `create_workspace` function extracts type prefix from workspace name and filters symlinks accordingly
- Main routing updated to handle `A/*` and `c/*` patterns
- File validation now checks for specifically requested instruction type rather than any file

## [1.1.0] - 2025-10-28

### Added

- **Deletion Commands**: Added `agmst del` command to delete workspaces and profiles
  - `agmst del /workspace-name` deletes a workspace directory
  - `agmst del !-profilename` deletes an instructions profile
  - Confirmation prompt before deletion showing path and contents
  - Lists files that will be deleted for profiles (AGENTS.md, copilot-instructions.md)
  - Supports aliases: `del`, `delete`, `rm`
  - Cancel option to abort deletion
- Warning message for `!-` prefix when profile doesn't exist
- "Don't create" option in profile creation prompt
- Help documentation updated with deletion examples

### Fixed

- **Critical**: Fixed symlink source detection to correctly identify profile vs root
  - Now uses basename check instead of path glob matching
  - Symlink messages correctly show "from instructions profile: '!-name'" or "from [AgentMasta] root"
- **Critical**: Corrected profile creation semantics
  - Identifier prefixes (`!@-`, `!C-`, `!@C-`, `!C@-`) now ONLY for creating profiles
  - Error when trying to create profile that already exists with identifier prefix
  - `!-` prefix for using existing or prompting to create
- Removed redundant "Using profile" and "Creating profile" messages
- Updated tip message wording for clarity
- Added blank line after tips for better readability

### Changed

- Profile validation now distinguishes between creation commands and usage
- Interactive prompt enhanced with warning message before creation
- Error messages improved with proper quote style

## [1.0.1] - 2025-01-28

### Fixed

- **Critical**: Fixed repository path resolution for installed version
- Installation now embeds `[AgentMasta]` repository path in installed script
- Installed version can now correctly find profiles and instructions files
- Added `AGENTMASTA_ROOT` variable to track repository location separately from script location

## [1.0.0] - 2025-01-28

### Added

#### Core Features

- Initial release of AgentMasta CLI tool
- Core workspace creation functionality with automatic directory creation
- Embedded configuration system with WORKSPACE_DIR stored directly in scripts
- Self-modifying scripts that update their own configuration
- `agmst wsdir` command to view current workspace directory
- `agmst wsdir <path>` command to set workspace directory
- Automatic AGENTS.md symlinking to workspace root
- Automatic copilot-instructions.md symlinking to `.github/` directory
- Simultaneous symlinking of both AGENTS.md and copilot-instructions.md when both exist
- Automatic .github/ directory creation when using copilot-instructions.md
- VS Code integration for automatic workspace opening
- Comprehensive help and version commands
- Color-coded terminal output for better UX
- Zero external dependencies (no config files needed)

#### Instructions Profiles

- Instructions profiles system for different AI agents
- All profile directories stored as !-name format regardless of command prefix
- Profile type prefixes for targeted file creation:
  - `!@-name` creates AGENTS.md only (for agentic tools like MCP servers)
  - `!C-name` creates copilot-instructions.md only (for copilot-specific workflows)
  - `!@C-name` or `!C@-name` creates both files (for complete setups)
  - `!-name` prompts user to choose which file(s) to create
- Auto-creation of profiles on first use with intelligent defaults
- User prompt for `!-` prefix profiles to choose which file(s) to create
- Profile copying with `=` syntax: `!@-new=!-existing` copies all files from existing profile
- Smart content copying for new profiles:
  - If both root files exist: copies content from matching type
  - If one root file exists: copies its content regardless of target type
  - If no root files exist: creates empty file(s)
- Profile validation and error handling
- Create workspace with profile: `agmst /workspace-name !-profilename`
- Replace instructions in current workspace: `agmst !-profilename`
- Default instructions from [AgentMasta] root when no profile specified
- Support for multiple instructions files per profile

#### Workspace Name Syntax

- Required `/` prefix for workspace names to distinguish from profile commands
- Support for workspace names starting with any character, including `!`
- Example: `agmst /!important-project` creates workspace named "!important-project"
- Helpful error messages guiding users to use `/` prefix
- Clear separation between workspace creation and profile commands

#### Cross-Platform Support

- Bash implementation (`agmst`) for macOS, Linux, and WSL
- PowerShell implementation (`agmst.ps1`) for native Windows support
- Self-installation via `agmst install` and `agmst.ps1 install` commands
- Symbolic link creation with Windows fallback to file copying
- Cross-platform PATH management

#### Documentation

- Comprehensive unified README.md with installation and usage guides
- Instructions profiles setup and usage documentation
- CHANGELOG.md following Keep a Changelog format
- ROADMAP.md outlining project phases and status
- REFERENCES.md with cited sources
- Inline code comments following ELI5 approach
- Platform-specific troubleshooting sections
- Examples for all major use cases including profiles and / prefix syntax

#### Developer Experience

- VS Code workspace settings for syntax highlighting
- Distinctive directory naming with brackets `[AgentMasta]`
- Consistent branding (AgentMasta with capital WS)
- .gitignore configuration
- GitHub-ready repository structure

[1.2.0]: https://github.com/xCORViSx/AgentMasta/releases/tag/v1.2.0
[1.1.0]: https://github.com/xCORViSx/AgentMasta/releases/tag/v1.1.0
[1.0.1]: https://github.com/xCORViSx/AgentMasta/releases/tag/v1.0.1
[1.0.0]: https://github.com/xCORViSx/AgentMasta/releases/tag/v1.0.0
