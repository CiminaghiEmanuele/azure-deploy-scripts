#!/usr/bin/env bash
set -euo pipefail

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
  cat <<USAGE
$SCRIPT_NAME
Crea un Resource Group Azure con tagging standard.

Variabili richieste:
  RG     Nome Resource Group
  LOC    Regione (es. italynorth)

Opzionali:
  TAGS_JSON  Tag in formato JSON

Uso:
  RG=rg-demo LOC=italynorth ./$SCRIPT_NAME
USAGE
}

[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az
require_env RG LOC

run "az group create -n '$RG' -l '$LOC' --tags $(safe_default_tags) -o table"