#!/usr/bin/env bash
set -euo pipefail
# Abilita soft delete blob

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Abilita soft delete su blob.

Richiesti:
  SA

Opzionali:
  DAYS=30

Uso:
  SA=stprod12345 DAYS=14 ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }
require_az
require_env SA

DAYS="${DAYS:-30}"
run "az storage account blob-service-properties update --account-name '$SA' --enable-delete-retention true --delete-retention-days $DAYS -o table"