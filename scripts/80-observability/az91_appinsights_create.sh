#!/usr/bin/env bash
set -euo pipefail
# Crea Application Insights "workspace-based" (best practice)

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Crea Application Insights collegato a Log Analytics Workspace (workspace-based).

Richiesti:
  RG LOC
  AI_NAME
  LAW_ID   (resource id del workspace)

Uso:
  RG=rg-obs LOC=italynorth AI_NAME=appi-demo LAW_ID="/subscriptions/.../workspaces/law-demo" ./$SCRIPT_NAME

Note:
  - Se non hai LAW_ID: ricavalo con az90 + az monitor log-analytics workspace show --query id -o tsv
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az
require_env RG LOC AI_NAME LAW_ID

run "az extension add --name application-insights -o none" || true
run "az monitor app-insights component create -g '$RG' -l '$LOC' -a '$AI_NAME' --workspace '$LAW_ID' --application-type web --tags $(safe_default_tags) -o table"