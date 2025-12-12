#!/usr/bin/env bash
set -euo pipefail

# az48_vm_run_command.sh
# Esegue un comando remoto su VM (Linux: RunShellScript, Windows: RunPowerShellScript).

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
  cat <<USAGE
$SCRIPT_NAME
Esegue un comando su una VM tramite Run Command.

Richiesti:
  RG
  VM
  COMMAND     stringa comando da eseguire

Opzionali:
  OS=auto|linux|windows (default: auto)

Uso:
  RG=rg-demo VM=vm01 COMMAND='uname -a' ./$SCRIPT_NAME
  RG=rg-demo VM=vmwin01 OS=windows COMMAND='Get-ComputerInfo | select CsName' ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az
require_env RG VM COMMAND

OS="${OS:-auto}"
if [[ "$OS" == "auto" ]]; then
  OSTYPE="$(az vm get-instance-view -g "$RG" -n "$VM" --query "storageProfile.osDisk.osType" -o tsv)"
  if [[ "$OSTYPE" == "Windows" ]]; then OS="windows"; else OS="linux"; fi
fi

if [[ "$OS" == "windows" ]]; then
  run "az vm run-command invoke -g '$RG' -n '$VM' --command-id RunPowerShellScript --scripts '$COMMAND' -o json"
else
  run "az vm run-command invoke -g '$RG' -n '$VM' --command-id RunShellScript --scripts '$COMMAND' -o json"
fi