#!/usr/bin/env bash
set -euo pipefail
# Query KQL su Log Analytics (richiede workspace id e query)

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Esegue query KQL su Log Analytics.

Richiesti:
  LAW_ID   (workspace customerId GUID o resource id; qui usiamo resource id)
  QUERY

Opzionali:
  TIMESpan=PT1H (default)

Uso:
  LAW_ID="/subscriptions/.../workspaces/law-demo" QUERY="AzureActivity | take 10" ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az
require_env LAW_ID QUERY

TIMESPAN="${TIMESPAN:-PT1H}"

# Se LAW_ID e' un resource id, l'API accetta --workspace in forma resource id nelle versioni recenti.
run "az monitor log-analytics query --workspace '$LAW_ID' --analytics-query \"$QUERY\" --timespan '$TIMESPAN' -o json"