#!/usr/bin/env bash
set -euo pipefail

# az31_ddos_plan_attach.sh
# Crea un DDoS Protection Plan e lo associa a una VNet (quando richiesto in scenari enterprise).

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
  cat <<USAGE
$SCRIPT_NAME
Crea un DDoS Protection Plan e abilita DDoS sulla VNet.

Richiesti:
  RG LOC
  DDOS   Nome DDoS plan
  VNET   Nome VNet

Uso:
  RG=rg-sec LOC=italynorth DDOS=ddos-plan1 VNET=vnet-hub ./$SCRIPT_NAME

Note:
  - Ha costi significativi: usalo solo se richiesto.
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az
require_env RG LOC DDOS VNET

# Crea il plan se non esiste
if az network ddos-protection show -g "$RG" -n "$DDOS" >/dev/null 2>&1; then
  log "DDoS plan giÃ  presente: $DDOS"
else
  run "az network ddos-protection create -g '$RG' -n '$DDOS' -l '$LOC' -o table"
fi

# Associa alla VNet
run "az network vnet update -g '$RG' -n '$VNET' --ddos-protection true --ddos-protection-plan '$DDOS' -o table"