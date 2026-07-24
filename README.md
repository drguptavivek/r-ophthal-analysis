# R Ophthal Analysis

[![skills.sh](https://skills.sh/b/drguptavivek/r-ophthal-analysis)](https://skills.sh/drguptavivek/r-ophthal-analysis)

An Agent Skill for stepwise ophthalmology clinical research analysis in R and R Markdown. It keeps the researcher in charge of outcome definitions, denominators, recoding, and modelling decisions while helping an AI agent produce auditable analysis, tables, figures, and labelled exports.

## What it does

- Sets up a portable R/R Markdown analysis project with a central `analysis.Rmd`.
- Audits records, variable types, duplicates, and missingness before recoding.
- Separates raw, derived, frozen, and exported datasets while excluding the complete `data/` directory from Git.
- Handles eye-wise and person-wise ophthalmology definitions explicitly.
- Routes work to design-specific guidance for surveys, diagnostic accuracy, prediction, longitudinal data, survival analysis, trials, and meta-analysis.
- Includes guarded WHO ECIM eCSC/eREC and companion-indicator guidance.
- Produces publication-oriented tables, figures, and labelled Stata/SPSS exports.
- Works through an RStudio/ClaudeR MCP connection when available, with direct `Rscript` as the reproducible fallback.

The skill is deliberately phase-gated: it does not define endpoints or proceed to complex models without researcher approval.

## Install

### Recommended: npx

Install from Vivek Gupta's curated agent-skills catalog:

```bash
npx skills add drguptavivek/agent-skills --skill r-ophthal-analysis
```

Install globally for Codex:

```bash
npx skills add drguptavivek/agent-skills --skill r-ophthal-analysis --global --agent codex --yes
```

Install directly from this canonical repository:

```bash
npx skills add drguptavivek/r-ophthal-analysis
```

List the skill without installing it:

```bash
npx skills add drguptavivek/r-ophthal-analysis --list
```

These commands run the [`vercel-labs/skills`](https://github.com/vercel-labs/skills) installer through `npx`. This skill is hosted on GitHub; it is not a separate npm library and does not require an npm package publication.

### If you do not use npx: ask your AI agent

Copy and send this prompt to Codex, Claude Code, Cursor, or another agent that supports skills:

```text
Install the r-ophthal-analysis skill for me from
https://github.com/drguptavivek/r-ophthal-analysis
as a global user skill. Keep the whole skill folder together and confirm that
SKILL.md and its references are discoverable. Do not change the skill files.
```

The agent can choose the correct installation method and skills folder for its own environment. Restart the agent if it does not detect the newly installed skill immediately.

### Manual download without npx or Git

1. Download the repository as a ZIP from [GitHub](https://github.com/drguptavivek/r-ophthal-analysis/archive/refs/heads/main.zip).
2. Unzip it and rename the extracted folder to `r-ophthal-analysis`.
3. Move the entire folder—not only `SKILL.md`—into your agent's global skills directory.
4. Restart the agent and ask it to confirm that `$r-ophthal-analysis` is available.

Common global locations are:

| Agent | Destination folder |
| --- | --- |
| Codex | `~/.codex/skills/r-ophthal-analysis` |
| Claude Code | `~/.claude/skills/r-ophthal-analysis` |
| Cursor | `~/.cursor/skills/r-ophthal-analysis` |
| Gemini CLI | `~/.gemini/skills/r-ophthal-analysis` |

On macOS, choose **Finder → Go → Go to Folder…** and enter the path up to `/skills/`. The `~` symbol means your home folder. If your agent uses a different location, ask it: “Where is your global user skills folder?”

## Prerequisites

- An AI agent that supports the Agent Skills format.
- R and `Rscript` for analysis execution.
- `rmarkdown`, `knitr`, and Pandoc when rendering `.Rmd` reports. Pandoc may come from the system or an RStudio installation.
- Optional: RStudio, ClaudeR, `uvx`, and `clauder-mcp` for live RStudio MCP sessions.

The skill must ask before installing R packages or changing MCP configuration. If the optional MCP path is unavailable, it should continue with `Rscript` and the same central `.Rmd` workflow.

Check readiness without installing anything:

```bash
Rscript scripts/selftest.R
```

The self-test uses base R. It verifies the active R version, executable and library paths, package build locations, the core skill and scaffold, Pandoc, and optional RStudio MCP dependencies.

Compare the installed R and CRAN packages with current CRAN versions without changing anything:

```bash
Rscript scripts/selftest.R --check-updates
```

If R has moved or its major/minor version has changed, review missing or outdated packages and rerun ClaudeR client configuration only after approval. The skill never updates R or packages automatically.

### Pandoc and an agent's Python environment

Pandoc is an external executable, not a Python package dependency. The self-test finds Pandoc on `PATH` or through RStudio/`rmarkdown` discovery and verifies that it runs.

To prove that the agent's exact Python sandbox can invoke the discovered executable:

```bash
Rscript scripts/selftest.R --python /absolute/path/to/the/agent/python
```

The bundled `scripts/check_pandoc.py` uses only Python's standard library and is run in isolated mode. If the Python sandbox does not inherit the shell `PATH`, use the absolute Pandoc path reported by the self-test.

## Use

Invoke the installed skill explicitly when desired:

```text
Use $r-ophthal-analysis to audit this ophthalmology dataset and build the analysis step by step in R Markdown.
```

The coordinating workflow is in [`SKILL.md`](SKILL.md). Detailed guidance is loaded progressively from [`references/`](references/), and the optional base-R scaffold is in [`scripts/scaffold_analysis_guidelines.R`](scripts/scaffold_analysis_guidelines.R).

Run the scaffold from the target analysis project, not from the skill repository:

```bash
Rscript /path/to/r-ophthal-analysis/scripts/scaffold_analysis_guidelines.R /path/to/analysis-project
```

It creates:

- `analysis.Rmd`, containing the analysis charter, approval gates, data audit, missing-data plan, freeze record, results sections, and `sessionInfo()`.
- `data/raw/`, `data/derived/`, `data/frozen/`, and `data/exports/`.
- `R/analysis_guidelines.R`, `figs/`, `results/`, and `lit-review/`.
- A project `.gitignore` entry for `/data/`, so every patient-level data folder remains outside Git.

Re-running the scaffold preserves existing project files and only adds a missing `/data/` ignore rule.

## Validate

From the repository root:

```bash
Rscript tests/run_tests.R
Rscript scripts/selftest.R
npx skills add . --list
```

The scaffold, tests, and self-test use base R only. Continuous integration runs these checks plus skill discovery. Maintainers should also validate `SKILL.md` with their agent platform's skill-authoring validator before release.

Update an installed copy through the skills CLI:

```bash
npx skills update r-ophthal-analysis
```

## Source and marketplace

This repository is the canonical source. The copy at [`drguptavivek/agent-skills`](https://github.com/drguptavivek/agent-skills/tree/main/skills/r-ophthal-analysis) is a distribution mirror and should not be edited directly.

## License and attribution

Original skill instructions and code are released under the [MIT License](LICENSE). Named standards, software, methods, and third-party source material remain the property of their respective owners. References to WHO, RAAB, R, RStudio, ClaudeR, Stata, SPSS, or other projects do not imply affiliation or endorsement.

Clinical and public-health definitions must always be checked against the current study protocol and authoritative source before analysis.
