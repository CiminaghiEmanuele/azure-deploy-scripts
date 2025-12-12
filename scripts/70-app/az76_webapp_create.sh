#!/usr/bin/env bash
set -euo pipefail
# Crea Web App

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Crea Web App su App Service Plan.

Richiesti:
  RG
  APP
  PLAN

Opzionali:
  RUNTIME="NODE:20-lts" (Linux) oppure "DOTNET:8" ecc.
  HTTPS_ONLY=true (default true)

Uso:
  RG=rg-app APP=web-demo PLAN=asp-demo RUNTIME="NODE:20-lts" ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az
require_env RG APP PLAN

RUNTIME="${RUNTIME:-NODE:20-lts}"
HTTPS_ONLY="${HTTPS_ONLY:-true}"

run "az webapp create -g '$RG' -n '$APP' -p '$PLAN' --runtime '$RUNTIME' -o table"
run "az webapp update -g '$RG' -n '$APP' --https-only '$HTTPS_ONLY' -o table"