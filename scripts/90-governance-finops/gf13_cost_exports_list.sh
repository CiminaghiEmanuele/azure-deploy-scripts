#!/usr/bin/env bash
set -euo pipefail
# List Cost Management exports for a scope

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
List Cost Management exports.

Required:
  SCOPE (e.g. /subscriptions/<id>)

Usage:
  SCOPE="/subscriptions/<id>" ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }
require_az
require_env SCOPE

run "az costmanagement export list --scope '$SCOPE' -o table"