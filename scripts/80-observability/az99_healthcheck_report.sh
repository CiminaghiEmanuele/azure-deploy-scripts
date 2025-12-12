#!/usr/bin/env bash
set -euo pipefail
# Report rapido "healthcheck" su subscription: risorse + advisor recommendations + service health events (se accessibile)

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Report healthcheck rapido (inventory + advisor).

Opzionali:
  SUBSCRIPTION_ID (se vuoi forzare una subscription)

Uso:
  ./$SCRIPT_NAME
  SUBSCRIPTION_ID=<id> ./$SCRIPT_NAME

Output:
  - Lista risorse (top 50)
  - Advisor recommendations (top 50)

Note:
  - Service Health events non sempre accessibili via CLI in modo consistente.
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az

if [[ -n "${SUBSCRIPTION_ID:-}" ]]; then
  run "az account set -s '$SUBSCRIPTION_ID'"
fi

log "Resources (top 50):"
az resource list --query "[0:50].[type,name,resourceGroup,location]" -o table

echo ""
log "Advisor recommendations (top 50):"
az advisor recommendation list --query "[0:50].[category,impact,shortDescription.solution,resourceMetadata.resourceId]" -o table