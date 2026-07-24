#!/usr/bin/env python3
"""Verify that one Python interpreter can execute Pandoc without dependencies."""

from __future__ import annotations

import argparse
import os
import shutil
import subprocess
import sys
from pathlib import Path


def candidate_paths(explicit: str | None) -> list[Path]:
    candidates: list[Path] = []
    if explicit:
        candidates.append(Path(explicit).expanduser())
    for variable in ("PANDOC", "PANDOC_PATH"):
        value = os.environ.get(variable)
        if value:
            candidates.append(Path(value).expanduser())
    rstudio_dir = os.environ.get("RSTUDIO_PANDOC")
    if rstudio_dir:
        candidates.append(Path(rstudio_dir).expanduser() / "pandoc")
    on_path = shutil.which("pandoc")
    if on_path:
        candidates.append(Path(on_path))

    unique: list[Path] = []
    for candidate in candidates:
        resolved = candidate.resolve()
        if resolved not in unique:
            unique.append(resolved)
    return unique


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--pandoc", help="Exact Pandoc executable discovered by R")
    args = parser.parse_args()

    for candidate in candidate_paths(args.pandoc):
        if not candidate.is_file():
            continue
        try:
            result = subprocess.run(
                [str(candidate), "--version"],
                check=True,
                capture_output=True,
                text=True,
                timeout=10,
            )
        except (OSError, subprocess.SubprocessError):
            continue
        first_line = result.stdout.splitlines()[0] if result.stdout else "Pandoc"
        print(f"{first_line}; executable={candidate}")
        return 0

    print(
        "Pandoc is not executable from this Python environment. "
        "Pass --pandoc /absolute/path/from/R-selftest.",
        file=sys.stderr,
    )
    return 1


if __name__ == "__main__":
    raise SystemExit(main())
