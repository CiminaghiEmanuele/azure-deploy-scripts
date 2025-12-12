#!/usr/bin/env bash
set -euo pipefail
# Crea Storage Account con baseline enterprise

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Crea Storage Account con HTTPS, TLS1.2, no public blob.

Richiesti:
  RG LOC SA

Opzionali:
  SKU=Standard_LRS
  KIND=StorageV2

Uso:
  RG=rg-demo LOC=italynorth SA=stprod12345 ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }
require_az
require_env RG LOC SA

SKU="${SKU:-Standard_LRS}"
KIND="${KIND:-StorageV2}"

run "az storage account create -g '$RG' -n '$SA' -l '$LOC' --sku '$SKU' --kind '$KIND' --https-only true --min-tls-version TLS1_2 --allow-blob-public-access false --tags $(safe_default_tags) -o table"