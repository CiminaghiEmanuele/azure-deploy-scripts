#!/usr/bin/env bash
set -euo pipefail

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
  cat <<USAGE
$SCRIPT_NAME
Aggiorna o aggiunge tag a un Resource Group.

Variabili richieste:
  RG

Opzionali:
  TAGS_JSON  Tag JSON (merge)

Uso:
  RG=rg-demo TAGS_JSON='{"Env":"prod"}' ./$SCRIPT_NAME
USAGE
}

[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az
require_env RG

run "az group update -n '$RG' --set tags=$(safe_default_tags) -o table"