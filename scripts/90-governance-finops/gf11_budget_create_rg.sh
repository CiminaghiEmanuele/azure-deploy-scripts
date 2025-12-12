#!/usr/bin/env bash
set -euo pipefail
# Create a monthly budget at resource group scope

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Create a monthly budget at RG scope.

Required:
  SUBSCRIPTION_ID
  RG
  BUDGET_NAME
  AMOUNT

Optional:
  START_DATE=YYYY-MM-01 (default current month)
  END_DATE=YYYY-MM-01 (default +1 year)
  THRESHOLD=80

Usage:
  SUBSCRIPTION_ID=<id> RG=rg-app BUDGET_NAME=rg-budget AMOUNT=300 THRESHOLD=80 ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az
require_env SUBSCRIPTION_ID RG BUDGET_NAME AMOUNT

THRESHOLD="${THRESHOLD:-80}"
START_DATE="${START_DATE:-$(date +%Y-%m-01)}"
END_DATE="${END_DATE:-$(date -d "+1 year" +%Y-%m-01)}"

SCOPE="/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RG"

run "az consumption budget create --budget-name '$BUDGET_NAME' --category cost --amount '$AMOUNT' --time-grain monthly --start-date '$START_DATE' --end-date '$END_DATE' --scope '$SCOPE' --notifications \"{\\\"n1\\\":{\\\"enabled\\\":true,\\\"operator\\\":\\\"GreaterThan\\\",\\\"threshold\\\":$THRESHOLD,\\\"contactEmails\\\":[\\\"\\\"],\\\"contactRoles\\\":[\\\"Owner\\\"],\\\"contactGroups\\\":[]}}\" -o json"