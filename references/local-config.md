# MCP and Runtime Setup

Use for RStudio/ClaudeR MCP setup, Stata MCP setup (`setup-stata-mcp`), status, start, stop, `uvx`, Pandoc, project-local Codex MCP config, and fallback to `Rscript`. Instruction-only: do not install packages or modify MCP config unless the user asks.

## Rules

- Prefer the RStudio MCP `list_sessions` tool first. In Codex this may appear as `mcp__r_studio__list_sessions`.
- Do not assume a fixed port. Discover sessions from `list_sessions` or ClaudeR discovery files.
- If MCP is unavailable, continue reproducible work with direct `Rscript` and the same stage files.
- Ask the target agent before installing/configuring: `codex`, `claude`, `gemini`, `qwen`, `desktop`, or `cursor`.
- For Codex, default to project-local `.codex/config.toml`; do not use global `codex mcp add` unless the user asks.
- After a major/minor R update or a changed R library path, run the skill self-test and verify ClaudeR from the active R installation. Re-run client configuration only after user approval.

## Local RStudio MCP Configuration

The server definition is:

```toml
[mcp_servers.r-studio]
command = "uvx"
args = ["clauder-mcp"]
```

For new workspaces, place this in the target project's `.codex/config.toml` by default. Do not add it to the global `~/.codex/config.toml` or global MCP list unless the user explicitly requests global setup.

Expected runtime behavior; verify entrypoints against the installed ClaudeR version:

- First reachability probe: `mcp__r_studio__list_sessions`.
- Missing session message: `No active R sessions found. Start the ClaudeR addin in RStudio first.`
- The RStudio MCP port may vary. Use the port reported by `list_sessions`; do not hardcode `8787`.
- Start the RStudio-side addin from the R console with `ClaudeR:::claudeAddin()`. This function has no formal arguments; choose the port in the addin UI before clicking Start Server.
- ClaudeR writes discovery files to `~/.claude_r_sessions/*.json`; each file includes `session_name`, `port`, `pid`, and `started_at`.
- The addin/session lifecycle is the common failure point; retry after starting the ClaudeR addin before deeper debugging.

Discover installed ClaudeR and active session ports with Rscript:

```bash
Rscript -e 'cat("ClaudeR installed:", requireNamespace("ClaudeR", quietly=TRUE), "\n"); if (requireNamespace("ClaudeR", quietly=TRUE)) { cat("ClaudeR version:", as.character(utils::packageVersion("ClaudeR")), "\n"); cat("ClaudeR path:", find.package("ClaudeR"), "\n") }'
Rscript -e 'd <- path.expand("~/.claude_r_sessions"); if (dir.exists(d)) cat(paste(readLines(list.files(d, pattern="[.]json$", full.names=TRUE)), collapse="\n"), "\n") else cat("No ClaudeR session directory\n")'
```

In ClaudeR versions exposing this entrypoint, `ClaudeR:::claudeAddin()` opens the addin UI with a Port field. Prefer the documented addin entrypoint for the installed version; do not rely on older internal functions or a fixed port.

If the port is unavailable because RStudio or ClaudeR is not set up, ask before installing or configuring anything. Use the current instructions at <https://github.com/IMNMV/ClaudeR>; commands such as the following are examples and must be checked against the installed release:

```r
if (!require("devtools")) install.packages("devtools")
devtools::install_github("IMNMV/ClaudeR")

library(ClaudeR)
install_cli(tools = "codex")
claudeAddin()
```

For this skill's Codex default, do not use the printed `codex mcp add` command unless the user wants global setup. Instead, write the project-local `.codex/config.toml` block shown above.

ClaudeR-supported client names and installation commands can change. Check the current ClaudeR README and the installed `install_cli()` arguments before configuring Claude Code, Codex, Qwen, Gemini, Antigravity, Desktop, or Cursor. Report unsupported tool names rather than guessing a replacement command.

The `clauder-mcp` Python bridge is separate from the ClaudeR R package. ClaudeR runs the RStudio-side HTTP server; `uvx clauder-mcp` is the MCP bridge that AI clients connect to.

R upgrades can change `R.home()`, the `Rscript` executable, and `.libPaths()`. Run `Rscript scripts/selftest.R --check-updates` after an upgrade. If ClaudeR or required rendering packages are absent from the new library, discuss and reinstall only the needed packages, then rerun the approved client configuration. Do not reuse an absolute path from an older R library without verification.

`uvx` must be available on `PATH`. Check with `command -v uvx` and `uvx --version` on macOS/Linux, or `where uvx` and `uvx --version` on Windows. If missing, install `uv` with `brew install uv`, `curl -LsSf https://astral.sh/uv/install.sh | sh`, PowerShell `irm https://astral.sh/uv/install.ps1 | iex`, or `winget install --id=astral-sh.uv -e`, then restart the terminal/RStudio session.

## Stata MCP Setup (`setup-stata-mcp`)

Run this action when the researcher asks to set up Stata MCP, or when the native Stata route is requested and no `stata_run_file` / `stata_run_selection` tools are available. Ask before installing anything or editing MCP config. Without the MCP, run do-files in batch with the installed Stata executable (`stata-se -b do file.do` or the edition's equivalent) and read the raw log.

The Stata MCP is the **Stata MCP** IDE extension from <https://github.com/hanlulong/stata-mcp> (marketplace id `DeepEcon.stata-mcp`, also on Open VSX). The extension starts the MCP server; there is no separate server package. Requires Stata 17 or later and `uv` (the extension installs it if missing).

1. **Find the installed edition.** The extension defaults to `mp`; a wrong edition fails to start Stata.
   - macOS: `ls -d /Applications/Stata*/Stata*.app` → `StataMP.app`, `StataSE.app` or `StataBE.app`; install path is the folder (for example `/Applications/Stata`).
   - Windows: `StataMP-64.exe`, `StataSE-64.exe` or `StataBE-64.exe` in `C:\Program Files\Stata18` (or similar).
   - Linux: `stata-mp`, `stata-se` or `stata` in `/usr/local/stata18` (or similar).
   - Inside Stata, `display c(edition_real)` returns the licensed edition (`MP`, `SE`, `BE`); use it to confirm.
2. **Install the extension** in the researcher's IDE: `code --install-extension DeepEcon.stata-mcp` (or `cursor` / `antigravity --install-extension DeepEcon.stata-mcp`). Check with `code --list-extensions --show-versions | grep -i stata`.
3. **Set the extension settings** in the IDE user `settings.json` (macOS VS Code: `~/Library/Application Support/Code/User/settings.json`; Windows: `%APPDATA%\Code\User\settings.json`; Linux: `~/.config/Code/User/settings.json`):

   ```json
   "stata-vscode.stataPath": "/Applications/Stata",
   "stata-vscode.stataEdition": "se"
   ```

   Use the path and lower-case edition found in step 1. Leave the port at `4000` unless it is in use.
4. **Start the server**: open the IDE; the status bar shows "Stata" when the server is running (`autoStartServer` is on by default). Check with `curl -s -o /dev/null -w "%{http_code}\n" http://localhost:4000/mcp-streamable` (any HTTP response means it is listening).
5. **Register the client** (Streamable HTTP endpoint `http://localhost:4000/mcp-streamable`; replace any older `mcp-proxy`/SSE entry rather than adding a second):
   - Claude Code: `claude mcp add --transport http stata-mcp http://localhost:4000/mcp-streamable --scope user`
   - Codex (0.46+): project-local `.codex/config.toml` by default:

     ```toml
     [mcp_servers.stata-mcp]
     url = "http://localhost:4000/mcp-streamable"
     ```

   - VS Code Copilot / Cursor: `.vscode/mcp.json` with `{"servers": {"stata-mcp": {"type": "http", "url": "http://localhost:4000/mcp-streamable"}}}`.
   - Claude Desktop: Settings → Connectors → Add custom connector with the same URL.
   Restart the client afterwards.
6. **Verify**: run a one-line selection through `stata_run_selection`, for example `display c(stata_version) " " c(edition_real)`, and confirm the version and edition match step 1.

The IDE must stay open while the MCP is used. If the edition, Stata path or port changes after a Stata upgrade, repeat steps 1, 3 and 6. Check the extension README for current setting names and client commands before configuring; report mismatches rather than guessing.

Related: `component-project-layout.md`.
