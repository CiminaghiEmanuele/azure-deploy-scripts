#!/usr/bin/env bash
set -euo pipefail
SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
  cat <<USAGE
$SCRIPT_NAME
Crea un Private Endpoint verso una risorsa.

Richiesti:
  RG LOC
  PE_NAME
  SUBNET_ID
  TARGET_ID  (resource id della risorsa)
  GROUP_ID   (es. blob, vault, sqlServer, ...)

Uso:
  RG=rg-demo LOC=italynorth PE_NAME=pe-sa SUBNET_ID="/subscriptions/.../subnets/snet-pe" TARGET_ID="/subscriptions/.../storageAccounts/sa" GROUP_ID=blob ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }
require_az
require_env RG LOC PE_NAME SUBNET_ID TARGET_ID GROUP_ID

CONN_NAME="${CONN_NAME:-$PE_NAME-conn}"
run "az network private-endpoint create -g '$RG' -n '$PE_NAME' -l '$LOC' --subnet '$SUBNET_ID' --private-connection-resource-id '$TARGET_ID' --group-id '$GROUP_ID' --connection-name '$CONN_NAME' -o table"