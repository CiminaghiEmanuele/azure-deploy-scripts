#!/usr/bin/env bash
set -euo pipefail
# List policy assignments at a scope (default subscription)

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
List policy assignments.

Optional:
  SCOPE (default: current subscription)

Usage:
  ./$SCRIPT_NAME
  SCOPE="/subscriptions/<id>" ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az

if [[ -n "${SCOPE:-}" ]]; then
  run "az policy assignment list --scope '$SCOPE' -o table"
else
  SUB_ID="$(az account show --query id -o tsv)"
  run "az policy assignment list --scope '/subscriptions/$SUB_ID' -o table"
fi