#!/usr/bin/env bash
set -euo pipefail

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
  cat <<USAGE
$SCRIPT_NAME
Verifica che Azure CLI sia installata e che l'utente sia autenticato.

Uso:
  ./$SCRIPT_NAME

Output:
  Contesto dell'account Azure attivo.
USAGE
}

[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az
run "az account show -o table"
log "Azure CLI autenticata correttamente."