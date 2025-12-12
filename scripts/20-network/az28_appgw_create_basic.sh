#!/usr/bin/env bash
set -euo pipefail
SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
  cat <<USAGE
$SCRIPT_NAME
Crea un Application Gateway v2 base (Standard_v2) con frontend pubblico.

Richiesti:
  RG LOC
  APPGW
  VNET
  SUBNET
  PIP

Nota:
  La subnet deve essere dedicata ad AppGW.

Uso:
  RG=rg-demo LOC=italynorth APPGW=appgw1 VNET=vnet-demo SUBNET=snet-appgw PIP=pip-appgw ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }
require_az
require_env RG LOC APPGW VNET SUBNET PIP

run "az network public-ip create -g '$RG' -n '$PIP' -l '$LOC' --sku Standard --allocation-method Static -o table"
run "az network application-gateway create -g '$RG' -n '$APPGW' -l '$LOC' --sku Standard_v2 --public-ip-address '$PIP' --vnet-name '$VNET' --subnet '$SUBNET' -o table"