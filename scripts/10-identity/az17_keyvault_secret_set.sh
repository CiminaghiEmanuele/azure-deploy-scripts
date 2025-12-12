#!/usr/bin/env bash
set -euo pipefail
SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
  cat <<USAGE
$SCRIPT_NAME
Imposta un secret in Key Vault.

Richiesti:
  KV
  SECRET_NAME
  SECRET_VALUE

Uso:
  KV=kv-demo SECRET_NAME=ApiKey SECRET_VALUE='xxx' ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az
require_env KV SECRET_NAME SECRET_VALUE
run "az keyvault secret set --vault-name '$KV' -n '$SECRET_NAME' --value '$SECRET_VALUE' -o table"