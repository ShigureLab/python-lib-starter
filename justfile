VERSION := `poetry run python -c "import sys; from moelib import __version__ as version; sys.stdout.write(version)"`

install:
  poetry install

test:
  poetry run pytest --workers auto
  just clean

fmt:
  poetry run isort .
  poetry run black .

lint:
  poetry run pyright moelib tests

fmt-docs:
  prettier --write '**/*.md'

build:
  poetry build

publish:
  touch moelib/py.typed
  poetry publish --build
  git tag "v{{VERSION}}"
  git push --tags
  just clean-builds

clean:
  find . -name "*.pyc" -print0 | xargs -0 rm -f
  rm -rf .pytest_cache/
  rm -rf .mypy_cache/
  find . -maxdepth 3 -type d -empty -print0 | xargs -0 -r rm -r

clean-builds:
  rm -rf build/
  rm -rf dist/
  rm -rf *.egg-info/

ci-fmt-check:
  poetry run isort --check-only .
  poetry run black --check --diff .
  prettier --check '**/*.md'

ci-lint:
  just lint

ci-test:
  poetry run pytest -m "(api or processor) and not (ci_skip or ignore)" --workers auto --reruns 3 --reruns-delay 1
  just clean