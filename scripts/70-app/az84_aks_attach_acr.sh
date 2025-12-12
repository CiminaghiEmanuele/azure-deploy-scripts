#!/usr/bin/env bash
set -euo pipefail
# Attacca ACR ad AKS (grant pull)

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Collega ACR ad AKS (aks can pull images).

Richiesti:
  RG
  AKS
  ACR_NAME   (nome ACR)

Uso:
  RG=rg-aks AKS=aks-demo ACR_NAME=acrdemo ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }
require_az
require_env RG AKS ACR_NAME

run "az aks update -g '$RG' -n '$AKS' --attach-acr '$ACR_NAME' -o table"