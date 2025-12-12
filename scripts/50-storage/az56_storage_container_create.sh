#!/usr/bin/env bash
set -euo pipefail
# Crea container blob

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Crea un container blob.

Richiesti:
  SA
  CONTAINER

Uso:
  SA=stprod12345 CONTAINER=data ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }
require_az
require_env SA CONTAINER

run "az storage container create --account-name '$SA' -n '$CONTAINER' --auth-mode login -o table"