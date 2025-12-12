#!/usr/bin/env bash
set -euo pipefail
# Export RBAC assignments at subscription scope to JSON (audit baseline)

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Export RBAC role assignments at subscription scope.

Optional:
  SUBSCRIPTION_ID (default current)
  OUT=rbac.json

Usage:
  OUT=rbac.json ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az

OUT="${OUT:-rbac.json}"
SUB_ID="${SUBSCRIPTION_ID:-$(az account show --query id -o tsv)}"
SCOPE="/subscriptions/$SUB_ID"

az role assignment list --scope "$SCOPE" -o json > "$OUT"
log "Saved: $OUT"