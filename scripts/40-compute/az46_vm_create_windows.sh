#!/usr/bin/env bash
set -euo pipefail

# az46_vm_create_windows.sh
# Crea VM Windows (baseline: password required, tagging).

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
  cat <<USAGE
$SCRIPT_NAME
Crea una VM Windows Server 2022 Datacenter in una subnet esistente.

Richiesti:
  RG LOC
  VM
  ADMIN
  PASSWORD
  VNET
  SUBNET

Opzionali:
  SIZE=Standard_D2s_v5
  IMAGE=Win2022Datacenter
  PUBLIC_IP=none|new (default: none)

Uso:
  RG=rg-demo LOC=italynorth VM=vmwin01 ADMIN=localadmin PASSWORD='P@ssw0rd!...' VNET=vnet-demo SUBNET=snet-app ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az
require_env RG LOC VM ADMIN PASSWORD VNET SUBNET

SIZE="${SIZE:-Standard_D2s_v5}"
IMAGE="${IMAGE:-Win2022Datacenter}"
PUBLIC_IP="${PUBLIC_IP:-none}"

PIP_FLAG="--public-ip-address \"\""
if [[ "$PUBLIC_IP" == "new" ]]; then
  PIP_FLAG=""
fi

# shellcheck disable=SC2086
run "az vm create -g '$RG' -n '$VM' -l '$LOC' --image '$IMAGE' --size '$SIZE' --admin-username '$ADMIN' --admin-password '$PASSWORD' --vnet-name '$VNET' --subnet '$SUBNET' --tags $(safe_default_tags) $PIP_FLAG -o table"