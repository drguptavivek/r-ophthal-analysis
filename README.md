# Ophthal Analysis

An Agent Skill for stepwise ophthalmology clinical research analysis in R/R Markdown and explicitly requested native Stata. It keeps the researcher in charge of outcome definitions, denominators, recoding, and modelling decisions while helping an AI agent produce auditable analysis, tables, figures, and labelled exports.

## What it does

- Sets up a portable R/R Markdown analysis project with a central `analysis.Rmd`.
- Audits records, variable types, duplicates, and missingness before recoding.
- Separates raw, derived, frozen, and exported datasets while excluding the complete `data/` directory from Git.
- Handles eye-wise and person-wise ophthalmology definitions explicitly.
- Routes work to design-specific guidance for surveys, diagnostic accuracy, prediction, longitudinal data, survival analysis, trials, and meta-analysis.
- Includes guarded WHO ECIM eCSC/eREC and companion-indicator guidance.
- Produces publication-oriented tables, figures, and labelled Stata/SPSS exports.
- Supports native Stata `dtable`/`collect`/`putdocx` reporting when explicitly requested, with complete do-files and preserved raw logs.
- Works through an RStudio/ClaudeR MCP connection when available, with direct `Rscript` as the reproducible fallback.

The skill is deliberately phase-gated: it does not define endpoints or proceed to complex models without researcher approval.

## Install

Install from this repository's default branch (`main`). The repository keeps its existing `r-ophthal-analysis` URL; the skill name is `ophthal-analysis`.

For **Antigravity CLI (`agy`)**, run this in your analysis project. The project installation works with its current skill discovery:

```bash
npx skills add drguptavivek/r-ophthal-analysis --skill ophthal-analysis --agent antigravity-cli --yes
```

Launch `agy` in that project and ask it to use the `ophthal-analysis` skill. Restart an existing CLI session after installation so it discovers the skill. The installer target is `antigravity-cli`, not the separate Antigravity IDE target `antigravity`.

For a **global agy installation**, current `agy` discovers `~/.gemini/config/skills/`. The `skills` installer version 1.7.2 instead targets `~/.gemini/antigravity-cli/skills/`. Until those paths agree, install with npx and link this one skill into agy's discovery directory:

```bash
npx skills add drguptavivek/r-ophthal-analysis --skill ophthal-analysis --global --agent antigravity-cli --yes
mkdir -p ~/.gemini/config/skills
ln -s ~/.gemini/antigravity-cli/skills/ophthal-analysis ~/.gemini/config/skills/ophthal-analysis
```

The link keeps subsequent npx updates visible to agy. `ln -s` refuses to overwrite an existing destination; inspect an existing copy or link before changing it.

For Codex:

```bash
npx skills add drguptavivek/r-ophthal-analysis --skill ophthal-analysis --global --agent codex --yes
```

To install a local checkout instead, replace `drguptavivek/r-ophthal-analysis` with `.` and run from the repository root. Alternatively, copy the complete folder into the agent's skills directory, preserving its examples, references and scripts.

| Agent | Global destination |
| --- | --- |
| Codex | `~/.codex/skills/ophthal-analysis` |
| Claude Code | `~/.claude/skills/ophthal-analysis` |
| Cursor | `~/.cursor/skills/ophthal-analysis` |
| Antigravity CLI (`agy`) | `~/.gemini/config/skills/ophthal-analysis` (link to npx installation above) |

The project command installs under `.agents/skills/ophthal-analysis/`. See the [skills installer agent list](https://github.com/vercel-labs/skills#supported-agents) and [Google's skill documentation](https://antigravity.google/docs/skills?app=cli).

## Prerequisites

- An AI agent that supports the Agent Skills format.
- R and `Rscript` for analysis execution.
- `rmarkdown`, `knitr`, and Pandoc when rendering `.Rmd` reports. Pandoc may come from the system or an RStudio installation.
- On Windows only, Rtools when a package containing C, C++, or Fortran code must be installed from source. Normal CRAN binary-package installation does not require it.
- Optional: RStudio, ClaudeR, `uvx`, and `clauder-mcp` for live RStudio MCP sessions.

The skill must ask before installing R packages or changing MCP configuration. If the optional MCP path is unavailable, it should continue with `Rscript` and the same central `.Rmd` workflow.

Check readiness without installing anything:

```bash
Rscript scripts/selftest.R
```

The self-test uses base R. It verifies the active R version, executable and library paths, package build locations, the core skill and scaffold, Pandoc, and optional RStudio MCP dependencies.

On Windows, it also asks the active R installation to compile a disposable C source with `R CMD SHLIB`. This tests the real Rtools compiler and path configuration without installing a package. A missing toolchain is normally a warning because CRAN binaries still work. Require it only when source compilation is necessary:

```bash
Rscript scripts/selftest.R --require-build-tools
```

If that check fails, use the [official CRAN Rtools page](https://cran.r-project.org/bin/windows/Rtools/) to select the toolchain currently matched to the installed R version. Do not rely on a version number or installation path copied from older instructions.

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
Use $ophthal-analysis to audit this ophthalmology dataset and build the analysis step by step in R Markdown.
```

The coordinating workflow is in [`SKILL.md`](SKILL.md). Detailed guidance is loaded progressively from [`references/`](references/), and the optional base-R scaffold is in [`scripts/scaffold_analysis_guidelines.R`](scripts/scaffold_analysis_guidelines.R).

Run the scaffold from the target analysis project, not from the skill repository:

```bash
Rscript /path/to/ophthal-analysis/scripts/scaffold_analysis_guidelines.R /path/to/analysis-project
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

Update a published installation through the skills CLI using its installed name. Preserve any local edits before an update.

## Source and marketplace

This repository is the canonical source. The copy at [`drguptavivek/agent-skills`](https://github.com/drguptavivek/agent-skills/tree/main/skills/r-ophthal-analysis) is a distribution mirror and should not be edited directly.

## License and attribution

Original skill instructions and code are released under the [MIT License](LICENSE). Named standards, software, methods, and third-party source material remain the property of their respective owners. References to WHO, RAAB, R, RStudio, ClaudeR, Stata, SPSS, or other projects do not imply affiliation or endorsement.

Clinical and public-health definitions must always be checked against the current study protocol and authoritative source before analysis.

## Publication Table Examples

Hierarchical tables with indented category/summary rows are the default in R and Stata. The shared layout uses outcome-specific N, observed group n, indented summary/category rows, and unadjusted p only. Reports contain no automatic interpretation and only essential footnotes. R/R Markdown remains the default; researcher approval gates still apply.

- [R example index](examples/r/README.md): `examples/r/publication_tables.Rmd`, parameter `ngroups` (2 or 3). See `references/component-rmd-reporting.md`.
- [Stata example index](examples/stata/README.md): `examples/stata/example_stata_table1.do` and `examples/stata/example_stata_logistic.do`. See `references/component-stata-reporting.md`.

```stata
do examples/stata/example_stata_table1.do 2 "/absolute/scratch/table1_two"
do examples/stata/example_stata_table1.do 3 "/absolute/scratch/table1_three"
do examples/stata/example_stata_logistic.do 2 "/absolute/scratch/logistic_two"
do examples/stata/example_stata_logistic.do 3 "/absolute/scratch/logistic_three"
```

The R example includes Table 1 and logistic regression; the two Stata files provide these separately. Logistic tables have variable/category rows, N, outcome %, univariable OR [95% CI] and multivariable OR [95% CI]. They generate clearly marked synthetic results. They do not read patient data. Use a scratch directory and review rendered outputs before adapting the pattern to an approved frozen study dataset.
