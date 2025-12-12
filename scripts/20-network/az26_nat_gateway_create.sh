#!/usr/bin/env bash
set -euo pipefail
SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
  cat <<USAGE
$SCRIPT_NAME
Crea NAT Gateway + Public IP (Standard) e lo associa a una subnet.

Richiesti:
  RG LOC
  NAT   Nome NAT gateway
  PIP   Nome public IP
  VNET
  SUBNET

Uso:
  RG=rg-demo LOC=italynorth NAT=nat1 PIP=pip-nat VNET=vnet-demo SUBNET=snet-app ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }
require_az
require_env RG LOC NAT PIP VNET SUBNET

run "az network public-ip create -g '$RG' -n '$PIP' -l '$LOC' --sku Standard --allocation-method Static -o table"
run "az network nat gateway create -g '$RG' -n '$NAT' -l '$LOC' --public-ip-addresses '$PIP' -o table"
run "az network vnet subnet update -g '$RG' --vnet-name '$VNET' -n '$SUBNET' --nat-gateway '$NAT' -o table"