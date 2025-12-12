#!/usr/bin/env bash
set -euo pipefail
# Crea VM da Shared Image Gallery

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Crea una VM da Shared Image Gallery.

Richiesti:
  RG LOC VM IMAGE_ID ADMIN VNET SUBNET

Uso:
  RG=rg-demo LOC=italynorth VM=vm01 IMAGE_ID="/subscriptions/.../galleries/.../images/..." ADMIN=azureuser VNET=vnet SUBNET=snet ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }
require_az
require_env RG LOC VM IMAGE_ID ADMIN VNET SUBNET

run "az vm create -g '$RG' -n '$VM' -l '$LOC' --image '$IMAGE_ID' --admin-username '$ADMIN' --generate-ssh-keys --vnet-name '$VNET' --subnet '$SUBNET' --tags $(safe_default_tags) -o table"