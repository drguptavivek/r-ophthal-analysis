# Component: MCP and Runtime Setup

Use this component for RStudio/ClaudeR MCP setup, status, start, stop, `uvx`, Pandoc, project-local Codex MCP config, and fallback to `Rscript`.

## Rules

- Prefer the RStudio MCP `list_sessions` tool first. In Codex this may appear as `mcp__r_studio__list_sessions`.
- Do not assume a fixed port. Discover sessions from `list_sessions` or ClaudeR discovery files.
- If MCP is unavailable, continue reproducible work with direct `Rscript` and the same central `.Rmd`.
- Ask the target agent before installing/configuring: `codex`, `claude`, `gemini`, `qwen`, `desktop`, or `cursor`.
- For Codex, default to project-local `.codex/config.toml`; do not use global `codex mcp add` unless the user asks.

## Setup Notes

This component is instruction-only. Do not install packages or modify MCP config automatically unless the user asks.

Read `local-config.md` for detailed install/start/stop notes, including `uvx`, Pandoc, ClaudeR install commands, and the project-local Codex MCP block.
