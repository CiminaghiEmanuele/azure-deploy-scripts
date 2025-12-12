#!/usr/bin/env bash
set -euo pipefail
SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
  cat <<USAGE
$SCRIPT_NAME
Crea una Route Table (UDR) e, se NVA_IP Ã¨ valorizzato, crea una default route verso Virtual Appliance.

Richiesti:
  RG LOC RT

Opzionali:
  NVA_IP  (es. 10.10.10.4)

Uso:
  RG=rg-demo LOC=italynorth RT=rt-app NVA_IP=10.10.10.4 ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }
require_az
require_env RG LOC RT

run "az network route-table create -g '$RG' -n '$RT' -l '$LOC' -o table"

if [[ -n "${NVA_IP:-}" ]]; then
  run "az network route-table route create -g '$RG' --route-table-name '$RT' -n default-to-nva --address-prefix 0.0.0.0/0 --next-hop-type VirtualAppliance --next-hop-ip-address '$NVA_IP' -o table"
fi