#!/usr/bin/env bash
set -euo pipefail

# az34_expressroute_checklist.sh
# ER Ã¨ fortemente dipendente da provider/peering: qui diamo checklist pratica "enterprise".

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
  cat <<USAGE
$SCRIPT_NAME
Checklist ExpressRoute (pratica, enterprise).

Uso:
  ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

log "ExpressRoute checklist:"
log "1) Provider: disponibilitÃ  ER, location, bandwidth, tipo (MSEE, ecc.)"
log "2) Circuit: creazione circuito in Azure + Service Key"
log "3) Peering: Microsoft/Private peering (parametri ASN/VLAN/BGP)"
log "4) Gateway: ExpressRoute VNet Gateway in VNet dedicata (hub)"
log "5) Connection: collega circuito <-> gateway"
log "6) Routing: valida BGP routes, UDR/forced tunneling se serve"
log "7) DNS: se usi Private Endpoints, integra Private DNS"
log "8) HA: considerare dual circuits o provider ridondati (se richiesto)"