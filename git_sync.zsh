#!/usr/bin/env zsh
# git_sync.zsh
# Iterates over each subdirectory and runs:
#   git pull upstream 3.8
#   git push origin

set -euo pipefail

CRUX_VER=3.8

BASE_DIR="${1:-.}"  # Use first argument as base dir, default to current directory

succeeded=()
failed=()
skipped=()

echo "🔍 Scanning subdirectories in: $(realpath "$BASE_DIR")"
echo "-------------------------------------------"

for dir in "$BASE_DIR"/*/; do
  # Strip trailing slash for display
  dir="${dir%/}"

  # Skip if not a directory
  [[ -d "$dir" ]] || continue

  # Check if it's a git repo
  if [[ ! -d "$dir/.git" ]]; then
    echo "⏭️  Skipping '$dir' (not a git repository)"
    skipped+=("$dir")
    continue
  fi

  echo ""
  echo "📁 Processing: $dir"

  if (
    cd "$dir"

    echo "  ⬇️  Running: git pull upstream $CRUX_VER"
    if git pull upstream $CRUX_VER; then
      echo "  ✅ Pull succeeded"
    else
      echo "  ❌ Pull failed — skipping push for '$dir'" >&2
      exit 1
    fi

    echo "  ⬆️  Running: git push origin"
    if git push origin; then
      echo "  ✅ Push succeeded"
    else
      echo "  ❌ Push failed for '$dir'" >&2
      exit 1
    fi
  ); then
    succeeded+=("$dir")
  else
    failed+=("$dir")
  fi

done

echo ""
echo "==========================================="
echo "                 SUMMARY"
echo "==========================================="
echo "✅ Succeeded (${#succeeded[@]}): ${succeeded[@]:-none}"
echo "❌ Failed    (${#failed[@]}):    ${failed[@]:-none}"
echo "⏭️  Skipped   (${#skipped[@]}):  ${skipped[@]:-none}"
echo "==========================================="

# Exit with error code if any repo failed
[[ ${#failed[@]} -eq 0 ]]
