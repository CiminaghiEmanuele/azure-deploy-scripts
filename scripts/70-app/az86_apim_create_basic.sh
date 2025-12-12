#!/usr/bin/env bash
set -euo pipefail
# Crea APIM base (Developer SKU per demo)

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Crea API Management base.

Richiesti:
  RG LOC
  APIM
  PUBLISHER_NAME
  PUBLISHER_EMAIL

Opzionali:
  SKU=Developer (default)

Uso:
  RG=rg-app LOC=italynorth APIM=apim-demo PUBLISHER_NAME="V-Valley" PUBLISHER_EMAIL=it@example.com ./$SCRIPT_NAME

Note:
  - SKU Developer non e' per produzione.
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }
require_az
require_env RG LOC APIM PUBLISHER_NAME PUBLISHER_EMAIL

SKU="${SKU:-Developer}"

run "az apim create -g '$RG' -n '$APIM' -l '$LOC' --publisher-name '$PUBLISHER_NAME' --publisher-email '$PUBLISHER_EMAIL' --sku-name '$SKU' --tags $(safe_default_tags) -o table"