#!/usr/bin/env bash
set -euo pipefail

# az49_vm_resize.sh
# Resize VM (richiede che la size sia disponibile nel cluster).

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
  cat <<USAGE
$SCRIPT_NAME
Ridimensiona una VM (cambia SKU/size).

Richiesti:
  RG
  VM
  SIZE   (es. Standard_D4s_v5)

Uso:
  RG=rg-demo VM=vm01 SIZE=Standard_D4s_v5 ./$SCRIPT_NAME

Tip:
  Per vedere le size disponibili nella region:
    az vm list-sizes -l <loc> -o table
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az
require_env RG VM SIZE
run "az vm resize -g '$RG' -n '$VM' --size '$SIZE' -o table"