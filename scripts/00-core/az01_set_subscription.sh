#!/usr/bin/env bash
set -euo pipefail

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
  cat <<USAGE
$SCRIPT_NAME
Imposta la subscription Azure attiva.

Variabili richieste:
  SUBSCRIPTION   ID o nome subscription

Uso:
  SUBSCRIPTION=<id|name> ./$SCRIPT_NAME
USAGE
}

[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az
require_env SUBSCRIPTION

run "az account set --subscription '$SUBSCRIPTION'"
run "az account show -o table"