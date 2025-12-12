#!/usr/bin/env bash
set -euo pipefail

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
  cat <<USAGE
$SCRIPT_NAME
Esegue un WHAT-IF su un template Bicep a livello Resource Group.

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

run "az deployment group what-if -g '$RG' -f '$TEMPLATE'"