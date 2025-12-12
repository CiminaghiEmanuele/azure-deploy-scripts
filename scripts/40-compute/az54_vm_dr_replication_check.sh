#!/usr/bin/env bash
set -euo pipefail
# Controllo stato replica ASR

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Verifica stato replica ASR (se presente).

Richiesti:
  VM_ID

Uso:
  VM_ID="/subscriptions/.../virtualMachines/vm01" ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }
require_az
require_env VM_ID

run "az resource show --ids '$VM_ID' --query properties.extended.instanceView -o json"