#!/usr/bin/env bash
set -euo pipefail
SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
  cat <<USAGE
$SCRIPT_NAME
Crea una VNet e una subnet.

Richiesti:
  RG LOC
  VNET VNET_CIDR
  SUBNET SUBNET_CIDR

Uso:
  RG=rg-demo LOC=italynorth VNET=vnet-demo VNET_CIDR=10.10.0.0/16 SUBNET=snet-app SUBNET_CIDR=10.10.1.0/24 ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }
require_az
require_env RG LOC VNET VNET_CIDR SUBNET SUBNET_CIDR

run "az network vnet create -g '$RG' -n '$VNET' -l '$LOC' --address-prefixes '$VNET_CIDR' --subnet-name '$SUBNET' --subnet-prefixes '$SUBNET_CIDR' -o table"