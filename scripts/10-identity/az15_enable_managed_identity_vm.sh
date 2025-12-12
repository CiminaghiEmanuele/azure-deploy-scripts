#!/usr/bin/env bash
set -euo pipefail
SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
  cat <<USAGE
$SCRIPT_NAME
Abilita la System Assigned Managed Identity su una VM.

Richiesti:
  RG
  VM

Uso:
  RG=rg-demo VM=vm01 ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az
require_env RG VM
run "az vm identity assign -g '$RG' -n '$VM' -o json"