#!/usr/bin/env bash
set -euo pipefail
# Reservations/Savings Plan checklist

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Reservations and Savings Plans checklist.

Usage:
  ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

log "Checklist:"
log "1) Identify steady-state workloads (VMs, SQL, App Service plans)."
log "2) Choose commitment: Reservations vs Savings Plans depending on flexibility."
log "3) Validate AHB eligibility (Windows/SQL)."
log "4) Track utilization and scope (shared vs single subscription)."
log "5) Re-evaluate quarterly and after major migrations."