#!/usr/bin/env bash
set -euo pipefail

# az37_keyvault_private_only.sh
# Disabilita public network access. Da usare dopo aver predisposto Private Endpoint + Private DNS.

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
  cat <<USAGE
$SCRIPT_NAME
Disabilita accesso pubblico su Key Vault (publicNetworkAccess=Disabled).

Richiesti:
  RG
  KV

Uso:
  RG=rg-sec KV=kv-demo-12345 ./$SCRIPT_NAME

Attenzione:
  - Assicurati di avere Private Endpoint + DNS funzionanti,
    altrimenti rischi di tagliarti fuori.
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az
require_env RG KV

run "az keyvault update -g '$RG' -n '$KV' --public-network-access Disabled -o table"