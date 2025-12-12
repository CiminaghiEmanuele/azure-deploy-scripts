#!/usr/bin/env bash
set -euo pipefail
# Policy compliance summary at subscription scope (requires policy insights provider)

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Policy compliance summary.

Optional:
  SUBSCRIPTION_ID (default current)

Usage:
  ./$SCRIPT_NAME
  SUBSCRIPTION_ID=<id> ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }
require_az

if [[ -n "${SUBSCRIPTION_ID:-}" ]]; then
  az account set -s "$SUBSCRIPTION_ID"
fi

# Query policy states summary
SUB_ID="$(az account show --query id -o tsv)"
SCOPE="/subscriptions/$SUB_ID"

run "az policy state summarize --scope '$SCOPE' -o json | head -n 200"