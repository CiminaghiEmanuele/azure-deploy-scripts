#!/usr/bin/env bash
set -euo pipefail
# Inventory base

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Esporta elenco container + blob (inventario base).

Richiesti:
  SA

Uso:
  SA=stprod ./$SCRIPT_NAME > inventory.txt
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }
require_az
require_env SA

az storage container list --account-name "$SA" --auth-mode login -o table