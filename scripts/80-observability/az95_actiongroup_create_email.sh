#!/usr/bin/env bash
set -euo pipefail
# Crea Action Group con receiver email (notifiche alert)
# Nota: per Teams/ITSM/Webhook richiede receiver diversi.

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Crea Action Group con email receiver.

Richiesti:
  RG
  AG_NAME
  SHORT_NAME (max 12 chars)
  EMAIL

Uso:
  RG=rg-obs AG_NAME=ag-ops SHORT_NAME=agops EMAIL=ops@contoso.com ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az
require_env RG AG_NAME SHORT_NAME EMAIL

run "az monitor action-group create -g '$RG' -n '$AG_NAME' --short-name '$SHORT_NAME' --action email ops '$EMAIL' -o table"