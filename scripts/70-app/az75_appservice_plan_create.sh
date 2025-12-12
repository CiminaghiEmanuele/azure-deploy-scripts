#!/usr/bin/env bash
set -euo pipefail
# Crea App Service Plan (Linux o Windows)

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Crea App Service Plan.

Richiesti:
  RG LOC
  PLAN

Opzionali:
  SKU=P1v3|S1|B1... (default: B1)
  IS_LINUX=1 (default: 1)

Uso:
  RG=rg-app LOC=italynorth PLAN=asp-demo SKU=S1 IS_LINUX=1 ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az
require_env RG LOC PLAN

SKU="${SKU:-B1}"
IS_LINUX="${IS_LINUX:-1}"
LINUX_FLAG="--is-linux"
if [[ "$IS_LINUX" != "1" ]]; then LINUX_FLAG=""; fi

# shellcheck disable=SC2086
run "az appservice plan create -g '$RG' -n '$PLAN' -l '$LOC' --sku '$SKU' $LINUX_FLAG --tags $(safe_default_tags) -o table"