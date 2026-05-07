# Local RStudio MCP Configuration

The server definition is:

```toml
[mcp_servers.r-studio]
command = "uvx"
args = ["clauder-mcp"]
```

For new workspaces, place this in the target project's `.codex/config.toml` by default. Do not add it to the global `~/.codex/config.toml` or global MCP list unless the user explicitly requests global setup.

Known local behavior:

- First reachability probe: `mcp__r_studio__list_sessions`.
- Missing session message: `No active R sessions found. Start the ClaudeR addin in RStudio first.`
- The RStudio MCP port may vary. Use the port reported by `list_sessions`; do not hardcode `8787`.
- Start the RStudio-side addin from the R console with `ClaudeR:::claudeAddin()`. This function has no formal arguments; choose the port in the addin UI before clicking Start Server.
- ClaudeR writes discovery files to `~/.claude_r_sessions/*.json`; each file includes `session_name`, `port`, `pid`, and `started_at`.
- The addin/session lifecycle is the common failure point; retry after starting the ClaudeR addin before deeper debugging.

For install/start/stop/status procedures, use `component-mcp.md` and the operational commands in the main `SKILL.md`.

Discover installed ClaudeR and active session ports with Rscript:

```bash
Rscript -e 'cat("ClaudeR installed:", requireNamespace("ClaudeR", quietly=TRUE), "\n"); if (requireNamespace("ClaudeR", quietly=TRUE)) { cat("ClaudeR version:", as.character(utils::packageVersion("ClaudeR")), "\n"); cat("ClaudeR path:", find.package("ClaudeR"), "\n") }'
Rscript -e 'd <- path.expand("~/.claude_r_sessions"); if (dir.exists(d)) cat(paste(readLines(list.files(d, pattern="[.]json$", full.names=TRUE)), collapse="\n"), "\n") else cat("No ClaudeR session directory\n")'
```

For this installed package, `ClaudeR:::claudeAddin()` opens the current addin UI with a Port field. The older/internal `ClaudeR:::claude_rstudio_addin(port = 8787)` accepts a `port` argument, but prefer `ClaudeR:::claudeAddin()` unless deliberately using internal package functions.

If the port is unavailable because RStudio or ClaudeR is not set up, tell the user to start RStudio and install/configure ClaudeR from <https://github.com/IMNMV/ClaudeR>:

```r
if (!require("devtools")) install.packages("devtools")
devtools::install_github("IMNMV/ClaudeR")

library(ClaudeR)
install_cli(tools = "codex")
claudeAddin()
```

For this skill's Codex default, do not use the printed `codex mcp add` command unless the user wants global setup. Instead, write the project-local `.codex/config.toml` block described in `component-mcp.md`.

Use `install_cli(tools = "claude")` for Claude Code CLI and `install_cli(tools = "gemini")` for Gemini. Use `install_clauder()` for Claude Desktop and `install_clauder(for_cursor = TRUE)` for Cursor. Qwen Code support depends on the installed ClaudeR version; if `install_cli(tools = "qwen")` fails, report the exact error and suggest updating ClaudeR.

The `clauder-mcp` Python bridge is separate from the ClaudeR R package. ClaudeR runs the RStudio-side HTTP server; `uvx clauder-mcp` is the MCP bridge that AI clients connect to.

`uvx` must be available on `PATH`. Check with `command -v uvx` and `uvx --version` on macOS/Linux, or `where uvx` and `uvx --version` on Windows. If missing, install `uv` with `brew install uv`, `curl -LsSf https://astral.sh/uv/install.sh | sh`, PowerShell `irm https://astral.sh/uv/install.ps1 | iex`, or `winget install --id=astral-sh.uv -e`, then restart the terminal/RStudio session.
