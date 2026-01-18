#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

## Create link
ln -sfn $PROJECT_ROOT/www/releases/1 $PROJECT_ROOT/www/current
## Create containers
docker compose up -d