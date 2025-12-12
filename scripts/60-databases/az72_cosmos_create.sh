#!/usr/bin/env bash
set -euo pipefail
# Crea Cosmos DB account (SQL API) - baseline: disable public access optional

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Crea Cosmos DB account (SQL API).

Richiesti:
  RG LOC
  COSMOS

Opzionali:
  PUBLIC_NETWORK_ACCESS=Disabled|Enabled (default: Enabled)
  CONSISTENCY=Session|Strong|BoundedStaleness|Eventual|ConsistentPrefix (default: Session)

Uso:
  RG=rg-db LOC=italynorth COSMOS=cosmosdemo PUBLIC_NETWORK_ACCESS=Disabled ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az
require_env RG LOC COSMOS

PNA="${PUBLIC_NETWORK_ACCESS:-Enabled}"
CONS="${CONSISTENCY:-Session}"

run "az cosmosdb create -g '$RG' -n '$COSMOS' -l '$LOC' --default-consistency-level '$CONS' --public-network-access '$PNA' --tags $(safe_default_tags) -o table"