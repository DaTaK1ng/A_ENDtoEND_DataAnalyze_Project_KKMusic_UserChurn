#!/usr/bin/env bash
#
# Download v2-only KKBox data (~2.6 GB total).
# Requires: kaggle CLI installed and ~/.kaggle/kaggle.json configured.
#
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
RAW_DIR="$PROJECT_ROOT/data/raw"

mkdir -p "$RAW_DIR"
cd "$RAW_DIR"

if ! command -v kaggle &>/dev/null; then
  echo "kaggle CLI not found. Install with: pip install kaggle"
  exit 1
fi

if [[ ! -f "$HOME/.kaggle/kaggle.json" ]]; then
  echo "Kaggle API token missing. Place it at ~/.kaggle/kaggle.json"
  exit 1
fi

FILES=(
  "members_v3.csv.7z"
  "transactions_v2.csv.7z"
  "user_logs_v2.csv.7z"
  "train_v2.csv.7z"
)

echo "Downloading ${#FILES[@]} v2 files into $RAW_DIR"
for f in "${FILES[@]}"; do
  if [[ -f "${f%.7z}" ]]; then
    echo "  $f already extracted, skipping."
    continue
  fi
  echo "  -> $f"
  kaggle competitions download -c kkbox-churn-prediction-challenge -f "$f"
done

echo "Extracting 7z archives..."
if ! command -v 7z &>/dev/null; then
  echo "7z not found. Install with: brew install p7zip"
  exit 1
fi

for f in *.7z; do
  if [[ -f "$f" ]]; then
    7z x -y "$f"
    rm "$f"
  fi
done

echo "Done."
echo "Files in $RAW_DIR:"
ls -lh
