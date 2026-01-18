#!/bin/bash

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

## Create link
ln -sfn releases/1 $PROJECT_ROOT/www/current
## Create containers
docker compose up -d