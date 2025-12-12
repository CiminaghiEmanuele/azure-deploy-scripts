#!/usr/bin/env bash
set -euo pipefail

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
  cat <<USAGE
$SCRIPT_NAME
Elimina un Resource Group con conferma di sicurezza.

Variabili richieste:
  RG

Opzionali:
  FORCE=1   Salta la conferma manuale

Uso:
  RG=rg-demo ./$SCRIPT_NAME
USAGE
}

[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az
require_env RG

if [[ "${FORCE:-0}" != "1" ]]; then
  echo "ATTENZIONE: stai per eliminare il Resource Group '$RG'"
  read -r -p "Scrivi DELETE per confermare: " CONFIRM
  [[ "$CONFIRM" == "DELETE" ]] || die "Operazione annullata"
fi

run "az group delete -n '$RG' --yes --no-wait"