#!/usr/bin/env bash
set -euo pipefail
# Deploy Logic App (Consumption) via template ARM/Bicep json/parameters.
# Qui: deploy generico ARM template (file json) su RG.

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Deploy di una Logic App tramite template ARM JSON (generico).

Richiesti:
  RG
  TEMPLATE_JSON   (path)
Opzionali:
  PARAMS_JSON     (path)

Uso:
  RG=rg-app TEMPLATE_JSON=./logicapp.json PARAMS_JSON=./params.json ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }
require_az
require_env RG TEMPLATE_JSON
[[ -f "$TEMPLATE_JSON" ]] || die "Missing TEMPLATE_JSON: $TEMPLATE_JSON"

PARAMS=""
if [[ -n "${PARAMS_JSON:-}" ]]; then
  [[ -f "$PARAMS_JSON" ]] || die "Missing PARAMS_JSON: $PARAMS_JSON"
  PARAMS="--parameters @$PARAMS_JSON"
fi

NAME="logicdeploy-$(date +%Y%m%d%H%M%S)"
# shellcheck disable=SC2086
run "az deployment group create -g '$RG' -n '$NAME' --template-file '$TEMPLATE_JSON' $PARAMS -o table"