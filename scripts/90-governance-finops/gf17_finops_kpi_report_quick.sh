#!/usr/bin/env bash
set -euo pipefail
# Quick FinOps KPIs: total resources, top groups by count, tag coverage (proxy metrics)

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Quick FinOps KPI proxy report (count-based).

Optional:
  TAGS="Owner,CostCenter,Env" (default)

Usage:
  ./$SCRIPT_NAME
  TAGS="Owner,CostCenter,Env,App" ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }
require_az

TAGS="${TAGS:-Owner,CostCenter,Env}"

log "Total resources:"
az resource list --query "length([])" -o tsv

echo ""
log "Top 20 resource groups by resource count:"
az resource list --query "[].resourceGroup" -o tsv | sort | uniq -c | sort -nr | head -n 20

echo ""
log "Tag coverage:"
IFS=',' read -r -a ARR <<< "$TAGS"
for t in "${ARR[@]}"; do
  tag="$(echo "$t" | xargs)"
  missing="$(az resource list --query \"length([?tags.$tag==null])\" -o tsv)"
  echo "Missing $tag: $missing"
done