#!/usr/bin/env bash
set -euo pipefail
# Crea Budget su subscription (Cost Management)
# Nota: richiede scope subscription id e amount.

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Crea un budget mensile su subscription.

Richiesti:
  SUBSCRIPTION_ID
  BUDGET_NAME
  AMOUNT

Opzionali:
  START_DATE=YYYY-MM-01 (default: mese corrente)
  END_DATE=YYYY-MM-01 (default: +1 anno)
  THRESHOLD=80 (percentuale) solo notifica, non blocca

Uso:
  SUBSCRIPTION_ID=<id> BUDGET_NAME=budget-it AMOUNT=500 THRESHOLD=80 ./$SCRIPT_NAME

Note:
  - Il budget invia notifiche (non impone limiti).
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az
require_env SUBSCRIPTION_ID BUDGET_NAME AMOUNT

THRESHOLD="${THRESHOLD:-80}"

# Date default
if [[ -z "${START_DATE:-}" ]]; then
  START_DATE="$(date +%Y-%m-01)"
fi
if [[ -z "${END_DATE:-}" ]]; then
  END_DATE="$(date -d "+1 year" +%Y-%m-01)"
fi

SCOPE="/subscriptions/$SUBSCRIPTION_ID"

# costmanagement budget create (comando moderno)
run "az consumption budget create --budget-name '$BUDGET_NAME' --category cost --amount '$AMOUNT' --time-grain monthly --start-date '$START_DATE' --end-date '$END_DATE' --scope '$SCOPE' --notifications \"{\\\"n1\\\":{\\\"enabled\\\":true,\\\"operator\\\":\\\"GreaterThan\\\",\\\"threshold\\\":$THRESHOLD,\\\"contactEmails\\\":[\\\"\\\"],\\\"contactRoles\\\":[\\\"Owner\\\"],\\\"contactGroups\\\":[]}}\" -o json"