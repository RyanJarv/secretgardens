#!/usr/bin/env bash
# Assemble a single site version in ./docs by layering timestamped snapshots.
set -euo pipefail

SOURCE_ROOT="${SOURCE_ROOT:-site/websites/secretgardens.com}"
TARGET_DIR="${TARGET_DIR:-docs}"

usage() {
  cat <<'EOF'
Usage: promote_snapshot.sh [TIMESTAMP...]

Copies one or more snapshots from site/websites/secretgardens.com into ./docs.
If no timestamps are provided, every snapshot directory under the source root
is processed in lexicographic (oldest-first) order.

The first snapshot overwrites docs/ entirely. Subsequent snapshots fill in any
missing files without clobbering existing ones.

Environment overrides:
  SOURCE_ROOT   Override snapshot source directory (default: site/websites/secretgardens.com)
  TARGET_DIR    Override destination directory (default: docs)
EOF
}

if [[ "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

if [[ ! -d "${SOURCE_ROOT}" ]]; then
  echo "Error: snapshot source directory '${SOURCE_ROOT}' does not exist." >&2
  exit 1
fi

mapfile -t snapshots < <(
  if [[ "$#" -gt 0 ]]; then
    printf '%s\n' "$@" | sed '/^[[:space:]]*$/d'
  else
    find "${SOURCE_ROOT}" -mindepth 1 -maxdepth 1 -type d -print 2>/dev/null | sed 's#.*/##' | sort
  fi
)

if [[ "${#snapshots[@]}" -eq 0 ]]; then
  echo "Error: no snapshot directories found to promote." >&2
  exit 1
fi

mkdir -p "${TARGET_DIR}"

if [[ -n "$(ls -A "${TARGET_DIR}" 2>/dev/null || true)" ]]; then
  rm -rf "${TARGET_DIR:?}/"*
fi

first_snapshot=1
for snapshot in "${snapshots[@]}"; do
  src="${SOURCE_ROOT%/}/${snapshot}"
  if [[ ! -d "${src}" ]]; then
    echo "Warning: snapshot '${snapshot}' not found under ${SOURCE_ROOT}, skipping." >&2
    continue
  fi

  if [[ "${first_snapshot}" -eq 1 ]]; then
    rsync -a --delete "${src}/" "${TARGET_DIR}/"
    first_snapshot=0
  else
    rsync -a --ignore-existing "${src}/" "${TARGET_DIR}/"
  fi
done

echo "Promoted ${#snapshots[@]} snapshot(s) into '${TARGET_DIR}'."
