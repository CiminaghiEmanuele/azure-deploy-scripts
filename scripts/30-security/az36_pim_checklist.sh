#!/usr/bin/env bash
set -euo pipefail

# az36_pim_checklist.sh
# PIM non Ã¨ completamente automatizzabile via az in modo consistente: checklist + best practice.

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
  cat <<USAGE
$SCRIPT_NAME
Checklist e best practice per configurare PIM (Entra + Azure RBAC).

Uso:
  ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

log "PIM - Best practice (enterprise):"
log "- Abilita PIM per Entra roles + Azure RBAC"
log "- Usa Eligible assignments (non Active) per Admin"
log "- Richiedi MFA + justification + ticket (se possibile)"
log "- Time-bound activation (es. 1-4 ore)"
log "- Access reviews periodiche"
log "- Alert per role activation anomala"
log ""
log "Suggerimento: documenta ruoli e owner (RACI) prima di attivare PIM."