#!/usr/bin/env bash
set -euo pipefail

# az32_firewall_policy_create.sh
# Crea una Azure Firewall Policy (utile per standardizzare regole, TLS inspection, DNAT, ecc.)

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
  cat <<USAGE
$SCRIPT_NAME
Crea una Azure Firewall Policy.

Richiesti:
  RG LOC
  FWP   Nome firewall policy

Uso:
  RG=rg-net LOC=italynorth FWP=fwpol-hub ./$SCRIPT_NAME

Note:
  - La policy poi si collega a un Azure Firewall.
  - Questo script crea SOLO la policy (baseline).
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az
require_env RG LOC FWP

if az network firewall policy show -g "$RG" -n "$FWP" >/dev/null 2>&1; then
  log "Firewall policy giÃ  esistente: $FWP"
else
  run "az network firewall policy create -g '$RG' -n '$FWP' -l '$LOC' -o table"
fi