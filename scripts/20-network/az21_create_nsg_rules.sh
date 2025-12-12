#!/usr/bin/env bash
set -euo pipefail
SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
  cat <<USAGE
$SCRIPT_NAME
Crea NSG e (opzionale) regole base SSH/RDP.

Richiesti:
  RG LOC NSG

Opzionali:
  ALLOW_SSH=1
  ALLOW_RDP=1

Uso:
  RG=rg-demo LOC=italynorth NSG=nsg-app ALLOW_SSH=1 ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }
require_az
require_env RG LOC NSG

run "az network nsg create -g '$RG' -n '$NSG' -l '$LOC' -o table"

if [[ "${ALLOW_SSH:-0}" == "1" ]]; then
  run "az network nsg rule create -g '$RG' --nsg-name '$NSG' -n Allow-SSH --priority 1000 --access Allow --direction Inbound --protocol Tcp --destination-port-ranges 22 -o table"
fi

if [[ "${ALLOW_RDP:-0}" == "1" ]]; then
  run "az network nsg rule create -g '$RG' --nsg-name '$NSG' -n Allow-RDP --priority 1010 --access Allow --direction Inbound --protocol Tcp --destination-port-ranges 3389 -o table"
fi