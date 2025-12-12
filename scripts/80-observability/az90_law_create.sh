#!/usr/bin/env bash
set -euo pipefail
# Crea Log Analytics Workspace (LAW) baseline

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Crea Log Analytics Workspace.

Richiesti:
  RG LOC
  LAW

Opzionali:
  SKU=PerGB2018 (default)
  RETENTION_DAYS=30

Uso:
  RG=rg-obs LOC=italynorth LAW=law-demo RETENTION_DAYS=30 ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az
require_env RG LOC LAW

SKU="${SKU:-PerGB2018}"
RETENTION_DAYS="${RETENTION_DAYS:-30}"

run "az monitor log-analytics workspace create -g '$RG' -n '$LAW' -l '$LOC' --sku '$SKU' --retention-time '$RETENTION_DAYS' --tags $(safe_default_tags) -o table"