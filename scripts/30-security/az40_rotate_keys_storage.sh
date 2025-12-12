#!/usr/bin/env bash
set -euo pipefail

# az40_rotate_keys_storage.sh
# Rotazione key1 di Storage (attenzione: impatta chi usa key-based auth).

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
  cat <<USAGE
$SCRIPT_NAME
Rigenera una key di Storage Account (default key1).

Richiesti:
  RG
  SA

Opzionali:
  KEY=key1 | key2 (default: key1)

Uso:
  RG=rg-demo SA=stdev12345 KEY=key2 ./$SCRIPT_NAME

Attenzione:
  - Se app/servizi usano account key, devi aggiornare i secret subito.
  - Preferire Entra ID (RBAC) quando possibile.
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az
require_env RG SA

KEY="${KEY:-key1}"
run "az storage account keys renew -g '$RG' -n '$SA' --key '$KEY' -o table"