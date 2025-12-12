#!/usr/bin/env bash
set -euo pipefail
# Genera SAS (uso limitato!)

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Genera SAS temporaneo per container.

Richiesti:
  SA
  CONTAINER

Opzionali:
  HOURS=1
  PERMS=rl

Uso:
  SA=stprod CONTAINER=data ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }
require_az
require_env SA CONTAINER

HOURS="${HOURS:-1}"
PERMS="${PERMS:-rl}"
EXPIRY="$(date -u -d "+$HOURS hour" '+%Y-%m-%dT%H:%MZ')"

run "az storage container generate-sas --account-name '$SA' -n '$CONTAINER' --permissions '$PERMS' --expiry '$EXPIRY' --auth-mode login -o tsv"