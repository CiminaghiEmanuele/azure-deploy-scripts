#!/usr/bin/env bash
set -euo pipefail
# Swap slots (staging <-> production)

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Swap deployment slots.

Richiesti:
  RG
  APP
  SOURCE_SLOT
  TARGET_SLOT (default: production)

Uso:
  RG=rg-app APP=web-demo SOURCE_SLOT=staging TARGET_SLOT=production ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }
require_az
require_env RG APP SOURCE_SLOT

TARGET_SLOT="${TARGET_SLOT:-production}"
run "az webapp deployment slot swap -g '$RG' -n '$APP' --slot '$SOURCE_SLOT' --target-slot '$TARGET_SLOT' -o table"