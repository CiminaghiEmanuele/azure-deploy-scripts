#!/usr/bin/env bash
set -euo pipefail
# Crea ACR e push di una immagine (richiede docker)

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Crea Azure Container Registry e pusha un'immagine.

Richiesti:
  RG LOC
  ACR
  IMAGE_TAG   (es. myapp:1.0)
  DOCKERFILE_DIR (es. ./app)

Opzionali:
  SKU=Basic|Standard|Premium (default: Basic)

Uso:
  RG=rg-app LOC=italynorth ACR=acrdemo IMAGE_TAG=myapp:1.0 DOCKERFILE_DIR=./app ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az
require_env RG LOC ACR IMAGE_TAG DOCKERFILE_DIR

require_cmd docker

SKU="${SKU:-Basic}"

if az acr show -g "$RG" -n "$ACR" >/dev/null 2>&1; then
  log "ACR already exists: $ACR"
else
  run "az acr create -g '$RG' -n '$ACR' -l '$LOC' --sku '$SKU' --admin-enabled false --tags $(safe_default_tags) -o table"
fi

run "az acr login -n '$ACR'"
LOGIN_SERVER="$(az acr show -n "$ACR" --query loginServer -o tsv)"
FULL_TAG="$LOGIN_SERVER/$IMAGE_TAG"

run "docker build -t '$FULL_TAG' '$DOCKERFILE_DIR'"
run "docker push '$FULL_TAG'"

log "Pushed: $FULL_TAG"