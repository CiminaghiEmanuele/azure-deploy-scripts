#!/usr/bin/env bash
set -euo pipefail
# Crea Container Apps Environment + App (hello world container)

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Crea Container Apps Environment e una Container App.

Richiesti:
  RG LOC
  ENV_NAME
  APP_NAME
  IMAGE (es. mcr.microsoft.com/azuredocs/containerapps-helloworld:latest)

Opzionali:
  INGRESS=external|internal (default: external)
  TARGET_PORT=80

Uso:
  RG=rg-app LOC=italynorth ENV_NAME=cae-demo APP_NAME=ca-demo IMAGE=mcr.microsoft.com/azuredocs/containerapps-helloworld:latest ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }
require_az
require_env RG LOC ENV_NAME APP_NAME IMAGE

INGRESS="${INGRESS:-external}"
TARGET_PORT="${TARGET_PORT:-80}"

run "az extension add --name containerapp -o none" || true
run "az containerapp env create -g '$RG' -n '$ENV_NAME' -l '$LOC' -o table"
run "az containerapp create -g '$RG' -n '$APP_NAME' --environment '$ENV_NAME' --image '$IMAGE' --ingress '$INGRESS' --target-port '$TARGET_PORT' --tags $(safe_default_tags) -o table"