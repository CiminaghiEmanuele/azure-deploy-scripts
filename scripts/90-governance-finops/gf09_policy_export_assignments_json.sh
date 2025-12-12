#!/usr/bin/env bash
set -euo pipefail
# Export policy assignments to JSON (for documentation / audits)

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Export policy assignments at a scope to JSON.

Optional:
  SCOPE (default current subscription)
  OUT=policy-assignments.json

Usage:
  OUT=policy-assignments.json ./$SCRIPT_NAME
  SCOPE="/subscriptions/<id>" OUT=policy-assignments.json ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az

OUT="${OUT:-policy-assignments.json}"
if [[ -n "${SCOPE:-}" ]]; then
  az policy assignment list --scope "$SCOPE" -o json > "$OUT"
else
  SUB_ID="$(az account show --query id -o tsv)"
  az policy assignment list --scope "/subscriptions/$SUB_ID" -o json > "$OUT"
fi

log "Saved: $OUT"