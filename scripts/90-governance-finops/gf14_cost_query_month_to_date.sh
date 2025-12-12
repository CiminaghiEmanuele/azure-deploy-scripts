#!/usr/bin/env bash
set -euo pipefail
# Cost query (month-to-date) grouped by service using az rest (works even when some CLI commands vary)
# Requires: Subscription scope and appropriate permissions.

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Query Cost Management month-to-date grouped by service (top 20).
Uses az rest: Microsoft.CostManagement/query.

Required:
  SUBSCRIPTION_ID

Usage:
  SUBSCRIPTION_ID=<id> ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }
require_az
require_env SUBSCRIPTION_ID

SCOPE="/subscriptions/$SUBSCRIPTION_ID"

cat > body.json <<EOF
{
  "type": "ActualCost",
  "timeframe": "MonthToDate",
  "dataset": {
    "granularity": "None",
    "aggregation": { "totalCost": { "name": "PreTaxCost", "function": "Sum" } },
    "grouping": [{ "type": "Dimension", "name": "ServiceName" }],
    "sorting": [{ "direction": "Descending", "name": "totalCost" }]
  }
}
EOF

API="https://management.azure.com$SCOPE/providers/Microsoft.CostManagement/query?api-version=2023-03-01"

run "az rest --method post --uri '$API' --body @body.json --headers 'Content-Type=application/json' -o json | head -n 200"
rm -f body.json