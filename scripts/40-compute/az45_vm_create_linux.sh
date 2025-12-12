#!/usr/bin/env bash
set -euo pipefail

# az45_vm_create_linux.sh
# Crea una VM Ubuntu (baseline enterprise: tagging, no password, ssh keys).

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
  cat <<USAGE
$SCRIPT_NAME
Crea una VM Linux (Ubuntu 22.04) in una subnet esistente.

Richiesti:
  RG LOC
  VM
  ADMIN
  VNET
  SUBNET

Opzionali:
  SIZE=Standard_B2s
  IMAGE=Ubuntu2204
  PUBLIC_IP=none|new (default: none)

Uso:
  RG=rg-demo LOC=italynorth VM=vm01 ADMIN=azureuser VNET=vnet-demo SUBNET=snet-app SIZE=Standard_D2s_v5 ./$SCRIPT_NAME

Note:
  - Genera SSH keys se non presenti (az behavior).
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az
require_env RG LOC VM ADMIN VNET SUBNET

SIZE="${SIZE:-Standard_B2s}"
IMAGE="${IMAGE:-Ubuntu2204}"
PUBLIC_IP="${PUBLIC_IP:-none}"

PIP_FLAG="--public-ip-address \"\""
if [[ "$PUBLIC_IP" == "new" ]]; then
  PIP_FLAG=""
fi

# shellcheck disable=SC2086
run "az vm create -g '$RG' -n '$VM' -l '$LOC' --image '$IMAGE' --size '$SIZE' --admin-username '$ADMIN' --generate-ssh-keys --vnet-name '$VNET' --subnet '$SUBNET' --tags $(safe_default_tags) $PIP_FLAG -o table"