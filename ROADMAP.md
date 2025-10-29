# AgentMasta Development Roadmap

This document outlines the development phases and current status of the AgentMasta CLI tool.

---

## Phase 1: Core Functionality ✅ COMPLETE

**Status:** Released v1.0.1 (January 28, 2025)

### Core Features

- ✅ Bash CLI tool for workspace creation
- ✅ Automatic directory creation
- ✅ AGENTS.md symlinking to workspace root
- ✅ copilot-instructions.md symlinking to .github/ directory
- ✅ Automatic .github/ directory creation
- ✅ VS Code integration (automatic workspace opening)
- ✅ Configuration management system (show, edit commands)
- ✅ Help and version commands
- ✅ Color-coded terminal output
- ✅ Installation script with PATH detection
- ✅ **Fixed:** Repository path resolution for installed version

---

## Phase 2: Cross-Platform Support ✅ COMPLETE

**Status:** Released v1.0.1 (January 28, 2025)

### Platform Features

- ✅ PowerShell implementation for native Windows support
- ✅ Windows installer script (install.ps1)
- ✅ Batch wrapper for Windows command access (agmst.bat)
- ✅ Symbolic link fallback to file copying on Windows
- ✅ Cross-platform documentation in README
- ✅ Platform-specific troubleshooting guides

---

## Phase 3: Configuration System Refactor ✅ COMPLETE

**Status:** Released v1.0.1 (January 28, 2025)

### Configuration Features

- ✅ Embedded configuration directly in scripts (no external config file)
- ✅ Workspace directory stored in script itself
- ✅ Self-modifying scripts update embedded WORKSPACE_DIR value
- ✅ `agmst wsdir` command to view workspace directory
- ✅ `agmst wsdir <path>` command to set workspace directory
- ✅ Zero external dependencies
- ✅ Configuration persists automatically across sessions

---

## Phase 4: Instructions Profiles System ✅ COMPLETE

**Status:** Released v1.0.1 (January 28, 2025)

### Profile Features

- ✅ Instructions profile support for different AI agents
- ✅ Profile directories always stored as !-name format
- ✅ Profile type prefixes for targeted file creation:
  - !A- (AGENTS.md only)
  - !c- (copilot-instructions.md only)
  - !Ac- or !cA- (both files)
  - !- (user prompt for file type)
- ✅ Auto-creation of profiles on first use
- ✅ User prompt for !- prefix profiles (choose which file(s) to create)
- ✅ Profile copying with = syntax (!A-new=!-existing)
- ✅ Smart content copying: cross-type when single source, match-type when both exist
- ✅ Multiple instructions files per profile (AGENTS.md and/or copilot-instructions.md)
- ✅ Profile validation and error handling
- ✅ Create workspace with profile: `agmst /my-project !-profile`
- ✅ Replace instructions in current workspace: `agmst !-profile`
- ✅ Default instructions from [AgentMasta] root when no profile specified
- ✅ Symlinks both AGENTS.md and copilot-instructions.md when both exist

---

## Phase 5: Workspace Name Syntax Enhancement ✅ COMPLETE

**Status:** Released v1.0.1 (January 28, 2025)

### Syntax Features

- ✅ Required `/` prefix for workspace names (`agmst /my-project`)
- ✅ Allows workspace names starting with any character, including `!`
- ✅ Clear distinction between workspace creation and profile commands
- ✅ Helpful error messages for old syntax
- ✅ Updated documentation with new syntax examples
- ✅ Cross-platform implementation (bash and PowerShell)

---

## Phase 6: Self-Installation & Uninstallation ✅ COMPLETE

**Status:** Released v1.0.1 (January 28, 2025)

### Installation Features

- ✅ Self-installation command (`agmst install`)
- ✅ Self-uninstallation command (`agmst uninstall`)
- ✅ Automatic repository path embedding during installation
- ✅ Correct profile and instructions file lookup in installed version
- ✅ Installation to `/usr/local/bin` (bash) or `%USERPROFILE%\.local\bin` (PowerShell)
- ✅ Automatic PATH configuration on Windows
- ✅ User confirmation for uninstallation
- ✅ Cross-platform implementation (bash and PowerShell)

---

## Phase 7: Documentation & Polish ✅ COMPLETE

**Status:** Released v1.0.1 (January 28, 2025)

### Documentation Features

- ✅ Comprehensive unified README.md
- ✅ CHANGELOG.md with version history
- ✅ REFERENCES.md with cited sources
- ✅ Consistent branding (AgentMasta with capital WS)
- ✅ Distinctive directory naming ([AgentMasta] with brackets)
- ✅ GitHub repository preparation
- ✅ .gitignore configuration
- ✅ VS Code workspace settings

---

## Phase 7: GitHub Publication 🔄 IN PROGRESS

**Status:** Pending user action

### Publication Tasks

- ⏳ Create GitHub repository (github.com/xCORViSx/AgentMasta)
- ⏳ Initialize git in [AgentMasta] directory
- ⏳ Push code to GitHub
- ⏳ Create v1.0.0 release with binaries
- ⏳ Test installation from GitHub on fresh systems

---

## Phase 8: Deletion & Enhanced UX ✅ COMPLETE

**Status:** Released v1.1.0 (October 28, 2025)

### Deletion Features

- ✅ Workspace deletion command (`agmst del /workspace-name`)
- ✅ Profile deletion command (`agmst del !-profilename`)
- ✅ Confirmation prompts with path and contents display
- ✅ File listing for profiles showing AGENTS.md and copilot-instructions.md
- ✅ Command aliases support (`del`, `delete`, `rm`)
- ✅ Cancel option for all confirmations
- ✅ Cross-platform implementation (bash and PowerShell)

### Enhanced UX Features

- ✅ Warning message for `!-` prefix when profile doesn't exist
- ✅ "Don't create" option in profile creation prompts
- ✅ Fixed symlink source detection (profile vs root identification)
- ✅ Corrected profile creation semantics (identifiers only for creation)
- ✅ Cleaned up redundant terminal messages
- ✅ Improved error messages and tip formatting

---

## Phase 9: Workspace Type Identifiers ✅ COMPLETE

**Status:** Released v1.2.0 (October 28, 2025)

### Type Identifier Features

- ✅ `A/` workspace prefix to create workspace with AGENTS.md only (from root)
- ✅ `c/` workspace prefix to create workspace with copilot-instructions.md only (from root)
- ✅ Type filtering in `create_instruction_symlinks` function
- ✅ Smart file validation based on requested type
- ✅ Cross-platform implementation (bash and PowerShell)
- ✅ Help documentation updated with type identifier examples
- ✅ README examples showing type identifier usage

---

## Phase 10: Profile Management Enhancements ✅ COMPLETE

**Status:** Released (post-v1.2.0)

### Enhanced Profile Management

- ✅ Profile types display command (`agmst proftypes`)
- ✅ ls-like display showing all profiles with type indicators
- ✅ Clean aligned output with 16-character spacing
- ✅ Legend showing A (AGENTS.md), c (copilot), Ac (both)
- ✅ Profile creation UX improved with yes/no confirmation
- ✅ Cross-platform implementation (bash and PowerShell)

---

## Phase 11: Future Enhancements 📋 PLANNED

**Status:** Not started

### Proposed Features

- 📋 Template support for different project types (Rust, Python, Node.js, etc.)
- 📋 Git initialization option (--git flag)
- 📋 Package manager setup (npm init, cargo init, poetry init, etc.)
- 📋 Custom post-creation hooks
- 📋 Workspace archiving/management features
- 📋 Workspace listing command (agmst list)
- 📋 Configuration validation command
- 📋 Shell completion scripts (bash, zsh, PowerShell)

---

## Current Status Summary

**Project Status:** ✅ Ready for Release

The AgentMasta CLI tool is feature-complete with comprehensive workspace and profile management. All core functionality has been implemented and tested:

- ✅ Cross-platform support (macOS, Linux, Windows)
- ✅ Embedded configuration system (zero external files)
- ✅ Instructions profiles for different AI agents
- ✅ / prefix syntax for workspace names
- ✅ Type identifiers (A/ and c/) for selective root instructions
- ✅ Profile types display command (proftypes)
- ✅ wsdir command for workspace directory management
- ✅ Deletion commands for workspaces and profiles
- ✅ Enhanced UX with warnings and confirmation prompts
- ✅ Complete documentation
- ✅ Installation scripts for all platforms
- ✅ VS Code integration

**Next Action:** Consider tagging a new release version with the proftypes feature.

---

## Version History

- **v1.3.0** (October 29, 2025) - Added proftypes command and improved profile creation UX
- **v1.2.0** (October 28, 2025) - Added workspace type identifiers (A/ and c/)
- **v1.1.0** (October 28, 2025) - Added deletion commands and enhanced UX
- **v1.0.1** (October 28, 2025) - Fixed repository path resolution
- **v1.0.0** (October 28, 2025) - Initial release with full cross-platform support
