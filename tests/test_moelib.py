from __future__ import annotations

from pathlib import Path

# This can be replaced with tomllib if you are using Python 3.11+
import tomli as tomllib

from moelib import __version__

with Path("pyproject.toml").open("rb") as f:
    project_info = tomllib.load(f)


def test_version():
    assert __version__ == project_info["tool"]["poetry"]["version"]
