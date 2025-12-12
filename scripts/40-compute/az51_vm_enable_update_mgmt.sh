#!/usr/bin/env bash
set -euo pipefail
# Nota: Update Management v2 passa da Azure Automation + LAW

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Checklist per Update Management (Azure Update Manager).

Uso:
  ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

log "Update Manager checklist:"
log "1) VM con Azure Monitor Agent"
log "2) Log Analytics Workspace collegato"
log "3) Patch orchestration configurata (portal / policy)"
log "4) Maintenance configuration (optional)"