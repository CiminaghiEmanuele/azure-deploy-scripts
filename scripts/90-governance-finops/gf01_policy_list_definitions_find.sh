#!/usr/bin/env bash
set -euo pipefail
# Find policy definition by display name (useful to confirm exact built-in name)

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Find policy definition id by displayName (contains).

Required:
  QUERY (string)

Usage:
  QUERY="Allowed locations" ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az
require_env QUERY

run "az policy definition list --query \"[?contains(displayName, '$QUERY')].[displayName,id]\" -o table"