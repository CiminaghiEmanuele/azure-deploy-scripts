#!/usr/bin/env bash
set -euo pipefail
# Upload blob

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Upload file su Blob Storage.

Richiesti:
  SA CONTAINER FILE

Uso:
  SA=stprod CONTAINER=data FILE=./local.txt ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }
require_az
require_env SA CONTAINER FILE

run "az storage blob upload --account-name '$SA' -c '$CONTAINER' -f '$FILE' -n $(basename "$FILE") --auth-mode login -o table"