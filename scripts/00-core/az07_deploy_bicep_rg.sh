#!/usr/bin/env bash
set -euo pipefail

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
  cat <<USAGE
$SCRIPT_NAME
Deploy di un template Bicep su Resource Group.

Variabili richieste:
  RG
  TEMPLATE

Uso:
  RG=rg-demo TEMPLATE=main.bicep ./$SCRIPT_NAME
USAGE
}

[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az
require_env RG TEMPLATE

NAME="deploy-$(date +%Y%m%d%H%M%S)"
run "az deployment group create -g '$RG' -n '$NAME' -f '$TEMPLATE' -o table"