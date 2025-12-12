#!/usr/bin/env bash
set -euo pipefail
# Deploy ZIP su Web App (zipdeploy)

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Esegue ZIP deploy su Web App.

Richiesti:
  RG
  APP
  ZIP   path al file zip

Uso:
  RG=rg-app APP=web-demo ZIP=./app.zip ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az
require_env RG APP ZIP

[[ -f "$ZIP" ]] || die "ZIP not found: $ZIP"
run "az webapp deployment source config-zip -g '$RG' -n '$APP' --src '$ZIP' -o table"