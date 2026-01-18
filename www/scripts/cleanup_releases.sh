#!/bin/bash

set -eu

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
KEEP=5

cd "$RELEASES_DIR" || { echo "Releases dir not found: $RELEASES_DIR"; exit 1; }

count=$(ls -1tr | wc -l)
to_delete=$((count - KEEP))

if [ $to_delete -le 0 ]; then
    echo "Nothing to cleanup."
    exit 0
fi

ls -1tr | head -n $to_delete | while read dir; do
    echo "Removing old release: $dir"
    rm -rf "$dir"
done

echo "Cleanup finished."
