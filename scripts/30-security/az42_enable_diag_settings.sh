#!/usr/bin/env bash
set -euo pipefail

# az42_enable_diag_settings.sh
# Abilita Diagnostic Settings verso Log Analytics workspace, in modo generico su un resourceId.

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
  cat <<USAGE
$SCRIPT_NAME
Crea Diagnostic Settings su una risorsa verso un Log Analytics Workspace.

Richiesti:
  TARGET_ID   Resource ID della risorsa (scope diagnostic settings)
  LAW_ID      Resource ID del Log Analytics Workspace

Opzionali:
  NAME        Nome diag setting (default: diag-<timestamp>)

Uso:
  TARGET_ID="/subscriptions/.../providers/Microsoft.Web/sites/app" LAW_ID="/subscriptions/.../Microsoft.OperationalInsights/workspaces/law" ./$SCRIPT_NAME

Note:
  - Usa categoryGroup=allLogs e AllMetrics (baseline). Alcune risorse hanno categorie diverse.
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az
require_env TARGET_ID LAW_ID

NAME="${NAME:-diag-$(date +%H%M%S)}"

run "az monitor diagnostic-settings create --name '$NAME' --resource '$TARGET_ID' --workspace '$LAW_ID' --logs '[{\"categoryGroup\":\"allLogs\",\"enabled\":true}]' --metrics '[{\"category\":\"AllMetrics\",\"enabled\":true}]' -o json"