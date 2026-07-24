# Changelog

All notable changes to this skill are documented here.

## [Unreleased]

### Added

- Windows Rtools readiness probe that compiles a disposable C source, plus a strict source-build mode and Windows CI coverage.

## [1.0.0] - 2026-07-25

### Added

- Initial public release of the stepwise R/R Markdown ophthalmology analysis skill.
- Progressive guidance for data management, reporting, ophthalmology definitions, study designs, and WHO ECIM indicators.
- Optional base-R project scaffold.
- Central `analysis.Rmd` template with decision gates, missing-data planning, freeze metadata, and reproducibility output.
- Git-ignored raw, derived, frozen, and export data directories.
- Validated publication-formatting helpers and base-R regression tests.
- Dependency-free readiness self-test and continuous validation workflow.
- Non-installing R/CRAN package update checks, R path diagnostics, RStudio-bundled Pandoc discovery, and an isolated Python-to-Pandoc access probe.
- Agent-facing metadata, installation instructions, and MIT licensing.
