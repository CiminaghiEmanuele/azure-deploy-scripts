#!/usr/bin/env bash
set -euo pipefail
SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
  cat <<USAGE
$SCRIPT_NAME
Crea una User Assigned Managed Identity (UAMI).

Richiesti:
  RG   Resource Group
  LOC  Location (es. italynorth)
  UAMI Nome identity

Uso:
  RG=rg-demo LOC=italynorth UAMI=uami-demo ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az
require_env RG LOC UAMI
run "az identity create -g '$RG' -n '$UAMI' -l '$LOC' -o table"