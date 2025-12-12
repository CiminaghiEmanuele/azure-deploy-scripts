#!/usr/bin/env bash
set -euo pipefail
SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
  cat <<USAGE
$SCRIPT_NAME
Crea peering bidirezionale tra due VNet.

Richiesti:
  RG1 VNET1
  RG2 VNET2

Opzionali:
  PEER1_NAME
  PEER2_NAME

Uso:
  RG1=rg-a VNET1=vnet-a RG2=rg-b VNET2=vnet-b ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }
require_az
require_env RG1 VNET1 RG2 VNET2

ID1="$(az network vnet show -g "$RG1" -n "$VNET1" --query id -o tsv)"
ID2="$(az network vnet show -g "$RG2" -n "$VNET2" --query id -o tsv)"

P1="${PEER1_NAME:-peer-to-$VNET2}"
P2="${PEER2_NAME:-peer-to-$VNET1}"

run "az network vnet peering create -g '$RG1' -n '$P1' --vnet-name '$VNET1' --remote-vnet '$ID2' --allow-vnet-access -o table"
run "az network vnet peering create -g '$RG2' -n '$P2' --vnet-name '$VNET2' --remote-vnet '$ID1' --allow-vnet-access -o table"