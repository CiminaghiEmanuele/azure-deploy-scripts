#!/usr/bin/env bash
set -euo pipefail
# Report resources missing specific tags

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
List resources missing one or more tags.

Required:
  TAGS   comma-separated tag names, e.g. "Owner,CostCenter,Env"

Usage:
  TAGS="Owner,CostCenter,Env" ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az
require_env TAGS

IFS=',' read -r -a ARR <<< "$TAGS"
for t in "${ARR[@]}"; do
  tag="$(echo "$t" | xargs)"
  echo ""
  log "Missing tag: $tag"
  az resource list --query "[?tags.$tag==null].[type,name,resourceGroup,location]" -o table
done