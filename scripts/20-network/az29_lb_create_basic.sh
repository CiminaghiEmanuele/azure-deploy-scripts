#!/usr/bin/env bash
set -euo pipefail
SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
  cat <<USAGE
$SCRIPT_NAME
Crea un Load Balancer Standard base con frontend pubblico e backend pool.

Richiesti:
  RG LOC
  LB
  PIP

Uso:
  RG=rg-demo LOC=italynorth LB=lb1 PIP=pip-lb ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }
require_az
require_env RG LOC LB PIP

run "az network public-ip create -g '$RG' -n '$PIP' -l '$LOC' --sku Standard --allocation-method Static -o table"
run "az network lb create -g '$RG' -n '$LB' -l '$LOC' --sku Standard --public-ip-address '$PIP' --frontend-ip-name fe --backend-pool-name be -o table"