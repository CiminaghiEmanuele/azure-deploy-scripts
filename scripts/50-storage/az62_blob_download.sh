#!/usr/bin/env bash
set -euo pipefail
# Download blob

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Download file da Blob Storage.

Richiesti:
  SA CONTAINER BLOB OUT

Uso:
  SA=stprod CONTAINER=data BLOB=file.txt OUT=./file.txt ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }
require_az
require_env SA CONTAINER BLOB OUT

run "az storage blob download --account-name '$SA' -c '$CONTAINER' -n '$BLOB' -f '$OUT' --auth-mode login -o table"