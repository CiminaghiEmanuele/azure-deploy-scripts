#!/usr/bin/env bash
set -euo pipefail
# Abilita diagnostic settings verso LAW su una risorsa (generic)
# Usa categoryGroup=allLogs e AllMetrics (baseline). Se una risorsa non supporta allLogs, devi specificare categories.

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Crea Diagnostic Settings su una risorsa verso LAW (baseline).

Richiesti:
  TARGET_ID  resource id della risorsa
  LAW_ID     resource id del workspace

Opzionali:
  NAME=diag-<timestamp>

Uso:
  TARGET_ID="/subscriptions/.../providers/Microsoft.Web/sites/app" \
  LAW_ID="/subscriptions/.../providers/Microsoft.OperationalInsights/workspaces/law" \
  ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az
require_env TARGET_ID LAW_ID

NAME="${NAME:-diag-$(date +%H%M%S)}"

run "az monitor diagnostic-settings create --name '$NAME' --resource '$TARGET_ID' --workspace '$LAW_ID' --logs '[{\"categoryGroup\":\"allLogs\",\"enabled\":true}]' --metrics '[{\"category\":\"AllMetrics\",\"enabled\":true}]' -o json"