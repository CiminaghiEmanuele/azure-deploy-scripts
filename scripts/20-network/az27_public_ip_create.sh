#!/usr/bin/env bash
set -euo pipefail
SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
  cat <<USAGE
$SCRIPT_NAME
Crea un Public IP Standard statico.

Richiesti:
  RG LOC PIP

Uso:
  RG=rg-demo LOC=italynorth PIP=pip01 ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }
require_az
require_env RG LOC PIP

run "az network public-ip create -g '$RG' -n '$PIP' -l '$LOC' --sku Standard --allocation-method Static -o table"