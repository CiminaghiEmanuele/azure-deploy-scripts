#!/usr/bin/env bash
set -euo pipefail
# Assign built-in policy: Inherit a tag from the resource group (useful for CostCenter/Env propagation)

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Assign policy "Inherit a tag from the resource group".

Required:
  ASSIGNMENT_NAME
  TAG_NAME

Optional:
  SUBSCRIPTION_ID (default current)

Usage:
  ASSIGNMENT_NAME=inherit-costcenter TAG_NAME=CostCenter ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az
require_env ASSIGNMENT_NAME TAG_NAME

SUB_ID="${SUBSCRIPTION_ID:-$(az account show --query id -o tsv)}"
SCOPE="/subscriptions/$SUB_ID"

POLICY_DEF_ID="$(az policy definition list --query "[?displayName=='Inherit a tag from the resource group'].id | [0]" -o tsv)"
[[ -n "$POLICY_DEF_ID" ]] || die "Cannot find built-in policy 'Inherit a tag from the resource group'. Use gf01."

cat > params.json <<EOF
{ "tagName": { "value": "$TAG_NAME" } }
EOF

run "az policy assignment create --name '$ASSIGNMENT_NAME' --scope '$SCOPE' --policy '$POLICY_DEF_ID' --params @params.json -o table"
rm -f params.json