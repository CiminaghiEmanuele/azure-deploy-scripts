#!/usr/bin/env bash
set -euo pipefail
SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
  cat <<USAGE
$SCRIPT_NAME
Recupera il valore di un secret da Key Vault (stampa in stdout).

Richiesti:
  KV
  SECRET_NAME

Uso:
  KV=kv-demo SECRET_NAME=ApiKey ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az
require_env KV SECRET_NAME
run "az keyvault secret show --vault-name '$KV' -n '$SECRET_NAME' --query value -o tsv"