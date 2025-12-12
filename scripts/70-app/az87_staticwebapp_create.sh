#!/usr/bin/env bash
set -euo pipefail
# Crea Azure Static Web App (richiede repo GitHub e token/config)

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Crea una Static Web App.

Richiesti:
  RG LOC
  SWA

Opzionali:
  SKU=Free (default)

Uso:
  RG=rg-app LOC=italynorth SWA=swa-demo ./$SCRIPT_NAME

Note:
  - Il binding a GitHub repo/branch e' tipicamente fatto da portal o con parametri aggiuntivi.
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }
require_az
require_env RG LOC SWA

SKU="${SKU:-Free}"
run "az staticwebapp create -g '$RG' -n '$SWA' -l '$LOC' --sku '$SKU' -o table"