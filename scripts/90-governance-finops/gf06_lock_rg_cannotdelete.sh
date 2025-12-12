#!/usr/bin/env bash
set -euo pipefail
# Apply a CanNotDelete lock to a resource group

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Create a CanNotDelete lock on a resource group.

Required:
  RG
  LOCK_NAME

Usage:
  RG=rg-prod LOCK_NAME=rg-prod-protect ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az
require_env RG LOCK_NAME

run "az lock create --name '$LOCK_NAME' --lock-type CanNotDelete --resource-group '$RG' -o table"