#!/usr/bin/env bash
set -euo pipefail
# Crea Function App (consumption) + Storage

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Crea Function App (Consumption) con Storage Account esistente.

Richiesti:
  RG LOC
  FUNC
  SA

Opzionali:
  RUNTIME=node|python|dotnet|java (default: node)
  VERSION=20 (default: 20)

Uso:
  RG=rg-app LOC=italynorth FUNC=fn-demo SA=stprod12345 RUNTIME=node VERSION=20 ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }
require_az
require_env RG LOC FUNC SA

RUNTIME="${RUNTIME:-node}"
VERSION="${VERSION:-20}"

run "az functionapp create -g '$RG' -n '$FUNC' -l '$LOC' --storage-account '$SA' --consumption-plan-location '$LOC' --runtime '$RUNTIME' --runtime-version '$VERSION' --functions-version 4 --tags $(safe_default_tags) -o table"