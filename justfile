VERSION := `poetry run python -c "import sys; from moelib import __version__ as version; sys.stdout.write(version)"`

install:
  poetry install

test:
  poetry run pytest
  just clean

fmt:
  poetry run isort .
  poetry run black .

lint:
  poetry run pyright moelib tests
  poetry run ruff .

fmt-docs:
  prettier --write '**/*.md'

build:
  touch moelib/py.typed
  poetry build

release:
  @echo 'Tagging v{{VERSION}}...'
  git tag "v{{VERSION}}"
  @echo 'Push to GitHub to trigger publish process...'
  git push --tags

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

ci-install:
  poetry install --no-interaction --no-root

ci-fmt-check:
  poetry run isort --check-only .
  poetry run black --check --diff .
  prettier --check '**/*.md'

ci-lint:
  just lint

ci-test:
  poetry run pytest --reruns 3 --reruns-delay 1
  just clean
