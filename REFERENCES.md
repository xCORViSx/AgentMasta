# REFERENCES

## Bash Scripting Best Practices [https://google.github.io/styleguide/shellguide.html]

- Fetched on [10/28/25] for: Understanding bash scripting conventions, argument parsing, configuration file handling, and user-friendly CLI design patterns. This informed the implementation of the AgentMasta command-line tool with proper error handling, colored output, and configuration management.

## Command Line Interface Guidelines [https://clig.dev]

- Fetched on [10/28/25] for: Learning modern CLI design principles including configuration management, help text formatting, and user experience best practices. Applied these principles to create an intuitive AgentMasta tool with clear commands, helpful feedback, and easy configuration.

## Symbolic Links in Bash [https://www.gnu.org/software/coreutils/manual/html_node/ln-invocation.html]

- Fetched on [10/28/25] for: Understanding how to properly create symbolic links in bash scripts using the `ln -s` command. This was essential for implementing the automatic symlinking of AGENTS.md and copilot-instructions.md files into newly created workspaces, ensuring that updates to the source file are reflected in all workspaces.

## PowerShell Scripting Guide [https://learn.microsoft.com/en-us/powershell/scripting/overview]

- Fetched on [10/28/25] for: Learning PowerShell scripting fundamentals to create a Windows-native version of AgentMasta. This included understanding PowerShell cmdlets, parameter handling, path operations, and creating cross-platform compatible CLI tools that work seamlessly on Windows without requiring WSL or bash.

## PowerShell New-Item SymbolicLink [https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/new-item]

- Fetched on [10/28/25] for: Understanding how to create symbolic links in PowerShell using `New-Item -ItemType SymbolicLink`. This was critical for implementing the workspace symlinking feature on Windows, including handling the requirement for administrator privileges and implementing fallback to file copying when symlinks fail.
