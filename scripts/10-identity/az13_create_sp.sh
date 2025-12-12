#!/usr/bin/env bash
set -euo pipefail
SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
  cat <<USAGE
$SCRIPT_NAME
Crea un Service Principal (app registration) e assegna RBAC sulla subscription corrente.

Richiesti:
  NAME   Nome SP

Opzionali:
  ROLE   Default: Contributor
  SCOPE  Default: subscription corrente

Uso:
  NAME=sp-demo ROLE=Reader ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az
require_env NAME

ROLE="${ROLE:-Contributor}"
SUBID="$(az account show --query id -o tsv)"
SCOPE="${SCOPE:-/subscriptions/$SUBID}"

run "az ad sp create-for-rbac -n '$NAME' --role '$ROLE' --scopes '$SCOPE' -o json"
log "Salva in modo sicuro appId e password (client secret)."