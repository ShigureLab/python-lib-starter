import sys

from moelib import __version__

if sys.version_info >= (3, 11):  # pragma: >=3.11 cover
    import tomllib
else:  # pragma: <3.11 cover
    import tomli as tomllib


with open("pyproject.toml", "rb") as f:
    project_info = tomllib.load(f)


def test_version():
    assert __version__ == project_info["tool"]["poetry"]["version"]
