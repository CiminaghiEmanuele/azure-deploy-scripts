#!/usr/bin/env bash
set -euo pipefail

# az38_storage_secure_baseline.sh
# Baseline storage: HTTPS-only, TLS1_2, blob public access off, (opzionale) public network access.

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
  cat <<USAGE
$SCRIPT_NAME
Applica baseline di sicurezza a uno Storage Account.

Richiesti:
  RG
  SA

Opzionali:
  PUBLIC_NETWORK_ACCESS=Disabled   (default: Enabled)

Uso:
  RG=rg-demo SA=stdev12345 PUBLIC_NETWORK_ACCESS=Disabled ./$SCRIPT_NAME

Note:
  - Per chiusura totale serve anche Private Endpoint + DNS.
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az
require_env RG SA

PNA="${PUBLIC_NETWORK_ACCESS:-Enabled}"
run "az storage account update -g '$RG' -n '$SA' --https-only true --min-tls-version TLS1_2 --allow-blob-public-access false --public-network-access '$PNA' -o table"