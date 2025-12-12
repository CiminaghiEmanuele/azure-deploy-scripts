#!/usr/bin/env bash
set -euo pipefail
# Installa Azure Monitor Agent (AMA)

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Installa Azure Monitor Agent su una VM.

Richiesti:
  RG
  VM
  OS=linux|windows

Uso:
  RG=rg-demo VM=vm01 OS=linux ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }
require_az
require_env RG VM OS

if [[ "$OS" == "windows" ]]; then
  run "az vm extension set -g '$RG' --vm-name '$VM' --name AzureMonitorWindowsAgent --publisher Microsoft.Azure.Monitor -o table"
else
  run "az vm extension set -g '$RG' --vm-name '$VM' --name AzureMonitorLinuxAgent --publisher Microsoft.Azure.Monitor -o table"
fi