#!/usr/bin/env bash
set -euo pipefail
# File share

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Crea File Share.

Richiesti:
  SA
  SHARE

Opzionali:
  QUOTA=100

Uso:
  SA=stprod SHARE=files QUOTA=500 ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }
require_az
require_env SA SHARE

QUOTA="${QUOTA:-100}"
run "az storage share create --account-name '$SA' -n '$SHARE' --quota $QUOTA --auth-mode login -o table"