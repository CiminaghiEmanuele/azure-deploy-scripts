#!/usr/bin/env bash
set -euo pipefail
# Assign built-in policy: Allowed virtual machine SKUs (restrict VM sizes)

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Assign built-in policy "Allowed virtual machine SKUs".

Required:
  ASSIGNMENT_NAME
  SKUS_JSON  e.g. '["Standard_D2s_v5","Standard_D4s_v5"]'

Optional:
  SUBSCRIPTION_ID (default current)

Usage:
  ASSIGNMENT_NAME=allowed-vm-skus SKUS_JSON='["Standard_D2s_v5","Standard_D4s_v5"]' ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az
require_env ASSIGNMENT_NAME SKUS_JSON

SUB_ID="${SUBSCRIPTION_ID:-$(az account show --query id -o tsv)}"
SCOPE="/subscriptions/$SUB_ID"

POLICY_DEF_ID="$(az policy definition list --query "[?displayName=='Allowed virtual machine SKUs'].id | [0]" -o tsv)"
[[ -n "$POLICY_DEF_ID" ]] || die "Cannot find built-in policy 'Allowed virtual machine SKUs'. Use gf01 to search."

cat > params.json <<EOF
{ "listOfAllowedSKUs": { "value": $SKUS_JSON } }
EOF

run "az policy assignment create --name '$ASSIGNMENT_NAME' --scope '$SCOPE' --policy '$POLICY_DEF_ID' --params @params.json -o table"
rm -f params.json