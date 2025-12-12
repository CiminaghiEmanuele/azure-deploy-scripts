#!/usr/bin/env bash
set -euo pipefail
SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
  cat <<USAGE
$SCRIPT_NAME
Crea una Private DNS Zone e collega una VNet.

Richiesti:
  RG
  ZONE     (es. privatelink.blob.core.windows.net)
  VNET_ID  Resource ID della VNet

Opzionali:
  LINK  Nome del link

Uso:
  RG=rg-demo ZONE=privatelink.blob.core.windows.net VNET_ID="/subscriptions/.../virtualNetworks/vnet-demo" ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }
require_az
require_env RG ZONE VNET_ID

LINK="${LINK:-link-$(date +%H%M%S)}"
run "az network private-dns zone create -g '$RG' -n '$ZONE' -o table"
run "az network private-dns link vnet create -g '$RG' -n '$LINK' -z '$ZONE' -v '$VNET_ID' -e false -o table"