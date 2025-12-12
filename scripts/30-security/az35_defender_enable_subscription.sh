#!/usr/bin/env bash
set -euo pipefail

# az35_defender_enable_subscription.sh
# Abilita auto-provisioning (baseline). I piani Defender specifici vanno gestiti in policy/portal/terraform.

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
  cat <<USAGE
$SCRIPT_NAME
Abilita auto-provisioning di Microsoft Defender for Cloud (baseline).

Uso:
  ./$SCRIPT_NAME

Note:
  - Non abilita automaticamente tutti i "plans" (dipende da licenze/policy).
  - Scopo: mettere la subscription in modalitÃ  enterprise-ready.
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az

run "az security auto-provisioning-setting update -n default --auto-provision on -o json"
log "Auto-provisioning attivato. Verifica i piani Defender in Defender for Cloud."