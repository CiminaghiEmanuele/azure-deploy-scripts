#!/usr/bin/env bash
set -euo pipefail

# az44_rbac_report.sh
# Report RBAC "leggibile" per uno scope.

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
  cat <<USAGE
$SCRIPT_NAME
Stampa un report RBAC per uno scope.

Richiesti:
  SCOPE

Uso:
  SCOPE="/subscriptions/<id>/resourceGroups/rg-demo" ./$SCRIPT_NAME

Output:
  TSV con principalName, role, scope
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az
require_env SCOPE

run "az role assignment list --scope '$SCOPE' --query '[].{principalName:principalName,role:roleDefinitionName,scope:scope}' -o tsv"