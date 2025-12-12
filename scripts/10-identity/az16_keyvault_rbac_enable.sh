#!/usr/bin/env bash
set -euo pipefail
SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
  cat <<USAGE
$SCRIPT_NAME
Crea un Key Vault con RBAC abilitato (consigliato) e accesso pubblico consentito (modificabile poi).

Richiesti:
  RG
  LOC
  KV

Uso:
  RG=rg-demo LOC=italynorth KV=kv-demo-12345 ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az
require_env RG LOC KV
run "az keyvault create -g '$RG' -n '$KV' -l '$LOC' --enable-rbac-authorization true --public-network-access Enabled -o table"