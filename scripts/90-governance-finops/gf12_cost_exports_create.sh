#!/usr/bin/env bash
set -euo pipefail
# Create Cost Management export to Storage (CSV)
# If your az CLI doesn't support this command, update az CLI or use portal as fallback.

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Create Cost Management export to Storage.

Required:
  SCOPE               (e.g. /subscriptions/<id> or RG scope)
  EXPORT_NAME
  STORAGE_ACCOUNT_ID
  CONTAINER
  DIRECTORY

Optional:
  SCHEDULE=Daily|Weekly|Monthly (default: Daily)

Usage:
  SCOPE="/subscriptions/<id>" EXPORT_NAME=cost-daily STORAGE_ACCOUNT_ID="/subscriptions/.../storageAccounts/st" CONTAINER=cost DIRECTORY=exports ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az
require_env SCOPE EXPORT_NAME STORAGE_ACCOUNT_ID CONTAINER DIRECTORY

SCHEDULE="${SCHEDULE:-Daily}"

cat > export.json <<EOF
{
  "properties": {
    "schedule": {
      "status": "Active",
      "recurrence": "$SCHEDULE",
      "recurrencePeriod": {
        "from": "$(date -u +%Y-%m-%dT00:00:00Z)",
        "to": "$(date -u -d "+1 year" +%Y-%m-%dT00:00:00Z)"
      }
    },
    "format": "Csv",
    "deliveryInfo": {
      "destination": {
        "resourceId": "$STORAGE_ACCOUNT_ID",
        "container": "$CONTAINER",
        "rootFolderPath": "$DIRECTORY"
      }
    },
    "definition": {
      "type": "ActualCost",
      "timeframe": "MonthToDate",
      "dataSet": { "granularity": "Daily" }
    }
  }
}
EOF

run "az costmanagement export create --scope '$SCOPE' --name '$EXPORT_NAME' --definition @export.json -o json"
rm -f export.json