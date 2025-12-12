#!/usr/bin/env bash
set -euo pipefail
# Crea Front Door Standard/Premium (endpoint + origin group + origin)
# Nota: comandi cambiano spesso; usa come baseline e adatta.

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Crea Front Door Standard/Premium (Azure Front Door) con un origin HTTP/HTTPS.

Richiesti:
  RG
  FD_PROFILE
  FD_ENDPOINT
  ORIGIN_HOST   (es. web-demo.azurewebsites.net)

Opzionali:
  SKU=Standard_AzureFrontDoor (default)
  ORIGIN_NAME=origin1
  ORIGIN_GROUP=og1

Uso:
  RG=rg-edge FD_PROFILE=fdprof FD_ENDPOINT=fdep ORIGIN_HOST=web-demo.azurewebsites.net ./$SCRIPT_NAME

Note:
  - Per scenari enterprise: WAF policy, custom domain, cert, health probe tuning.
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }
require_az
require_env RG FD_PROFILE FD_ENDPOINT ORIGIN_HOST

SKU="${SKU:-Standard_AzureFrontDoor}"
ORIGIN_NAME="${ORIGIN_NAME:-origin1}"
ORIGIN_GROUP="${ORIGIN_GROUP:-og1}"

run "az afd profile create -g '$RG' -n '$FD_PROFILE' --sku '$SKU' -o table"
run "az afd endpoint create -g '$RG' --profile-name '$FD_PROFILE' -n '$FD_ENDPOINT' -o table"
run "az afd origin-group create -g '$RG' --profile-name '$FD_PROFILE' --origin-group-name '$ORIGIN_GROUP' --probe-request-type GET --probe-protocol Https --probe-path / -o table"
run "az afd origin create -g '$RG' --profile-name '$FD_PROFILE' --origin-group-name '$ORIGIN_GROUP' --origin-name '$ORIGIN_NAME' --host-name '$ORIGIN_HOST' --origin-host-header '$ORIGIN_HOST' --priority 1 --weight 100 -o table"
log "Now create a route to connect endpoint to origin group (often needed)."
log "Example: az afd route create ..."