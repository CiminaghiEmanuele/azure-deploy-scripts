#!/usr/bin/env bash
set -euo pipefail
SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
  cat <<USAGE
$SCRIPT_NAME
Ruota (reset) il client secret di un'app/service principal.

Richiesti:
  APP_ID   appId o objectId dell'app

Uso:
  APP_ID=<appId> ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az
require_env APP_ID
run "az ad app credential reset --id '$APP_ID' -o json"
log "Aggiorna subito le applicazioni che usano il vecchio secret."