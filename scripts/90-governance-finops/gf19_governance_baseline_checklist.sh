#!/usr/bin/env bash
set -euo pipefail
# Governance baseline checklist (practical)

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Governance baseline checklist.

Usage:
  ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

log "Baseline checklist:"
log "1) Management groups + subscription placement."
log "2) RBAC model + PIM for privileged roles."
log "3) Azure Policy: allowed locations, required tags, secure baselines."
log "4) Resource locks on critical RGs."
log "5) Diagnostic settings to LAW for key resources."
log "6) Cost budgets + cost exports + advisor cost reviews."
log "7) Naming convention + tagging convention enforced in CI/CD."