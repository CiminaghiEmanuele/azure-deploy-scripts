#!/usr/bin/env bash
set -euo pipefail

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
  cat <<USAGE
$SCRIPT_NAME
Elenca risorse potenzialmente orfane in un Resource Group
(NIC, dischi, IP pubblici).

Variabili richieste:
  RG

Uso:
  RG=rg-demo ./$SCRIPT_NAME
USAGE
}

[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az
require_env RG

log "Network Interfaces:"
run "az network nic list -g '$RG' -o table"

log "Public IPs:"
run "az network public-ip list -g '$RG' -o table"

log "Managed Disks:"
run "az disk list -g '$RG' -o table"