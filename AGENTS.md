# Repository Guidelines

## Project Structure & Module Organization
The root contains the `Dockerfile` that defines the Wayback Machine downloader image and the `Makefile` that orchestrates builds and fetches. Use `site/` as the writable output directory for recovered HTML assets; keep scraped data in subfolders that mirror the target URL structure for easy diffing. Reserve `scripts/` for repeatable helpers (Bash or Ruby) and document each script with a short header describing its purpose. Do not commit local Python environments such as `.venv/`; treat them as disposable.

## Build, Test, and Development Commands
`make build` builds the `wayback-downloader` image locally, ensuring Docker dependencies stay consistent across machines. Run

```bash
make fetch
```

to download the current snapshot (`20240807175123`) of `http://secretgardens.com` into `site/`; adjust the target timestamp in the makefile rule when adding new snapshots. When iterating quickly, you can invoke the container directly:

```bash
docker run --rm -v "$(pwd)/site:/site" wayback-downloader --help
```

to test flags without writing files.

## Coding Style & Naming Conventions
Keep Docker instructions uppercase and group related `RUN` commands; prefer multi-line `RUN` blocks with trailing backslashes for readability. Makefile targets must be tab-indented and guarded with phony declarations when they do not produce artifacts. Place shell helpers in `scripts/` with filenames that describe their action (`sync_site.sh`, `audit_links.sh`). Inside shell scripts, start with `#!/usr/bin/env bash` and `set -euo pipefail`, follow POSIX-compliant quoting, and document required environment variables.

## Testing Guidelines
There is no automated test harness yet, so validate changes by running `make fetch` against a temporary timestamp and confirming that the retrieved structure matches expectations (e.g., correct directory nesting, no binary assets missing). When modifying the Makefile or Dockerfile, run the associated command in dry-run mode (`--help`, alternate URL) to catch regressions. Consider adding smoke-test scripts under `scripts/` when introducing new behaviors.

## Commit & Pull Request Guidelines
Adopt a Conventional Commits-style subject (`feat: update fetch timestamp`) limited to 72 characters, followed by a concise body explaining the why. Reference related issues or incident tickets using `Refs #123`. Pull requests should include: a summary of the change, verification steps (commands executed, logs of successful runs), and any follow-up tasks such as updating snapshots. Attach diffs or screenshots when asset changes alter appearance.
