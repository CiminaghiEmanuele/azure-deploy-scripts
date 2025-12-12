#!/usr/bin/env bash
set -euo pipefail
# Imposta app settings (KEY=VALUE ...)

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Imposta App Settings su Web App.

Richiesti:
  RG
  APP
  SETTINGS   stringa tipo: "K1=V1 K2=V2"

Uso:
  RG=rg-app APP=web-demo SETTINGS="ENV=prod API_URL=https://..." ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }
require_az
require_env RG APP SETTINGS

run "az webapp config appsettings set -g '$RG' -n '$APP' --settings $SETTINGS -o table"