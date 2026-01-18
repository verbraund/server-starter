#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

RELEASES_DIR="$PROJECT_ROOT/releases"
CURRENT_LINK="$PROJECT_ROOT/current"

RELEASES=($(ls -1tr $RELEASES_DIR))
NUM_RELEASES=${#RELEASES[@]}

if [ $NUM_RELEASES -lt 2 ]; then
  echo "Rollback is impossible - less than two releases."
  exit 1
fi

PREV_RELEASE=${RELEASES[$NUM_RELEASES-2]}

ln -sfn $RELEASES_DIR/$PREV_RELEASE $CURRENT_LINK
echo "Rolled back to release: $PREV_RELEASE"
