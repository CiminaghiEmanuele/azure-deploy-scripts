#!/usr/bin/env bash
set -euo pipefail

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
  cat <<USAGE
$SCRIPT_NAME
Deploy di un template Bicep a livello subscription.

Variabili richieste:
  LOC
  TEMPLATE

Uso:
  LOC=italynorth TEMPLATE=sub.bicep ./$SCRIPT_NAME
USAGE
}

[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az
require_env LOC TEMPLATE

NAME="subdeploy-$(date +%Y%m%d%H%M%S)"
run "az deployment sub create -n '$NAME' -l '$LOC' -f '$TEMPLATE' -o table"