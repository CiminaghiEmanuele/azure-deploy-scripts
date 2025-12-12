#!/usr/bin/env bash
set -euo pipefail
# Crea Private Endpoint per Storage Account
# Wrapper corretto verso az24_private_endpoint_create.sh

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Crea un Private Endpoint per uno Storage Account usando lo script standard az24.

Richiesti:
  RG
  LOC
  PE_NAME
  SUBNET_ID
  SA_ID        Resource ID dello Storage Account

Opzionali:
  GROUP_ID     Default: blob
  CONN_NAME    Nome connessione private endpoint

Uso:
  RG=rg-demo LOC=italynorth PE_NAME=pe-st \
  SUBNET_ID="/subscriptions/.../subnets/snet-pe" \
  SA_ID="/subscriptions/.../storageAccounts/mystorage" \
  ./$SCRIPT_NAME
USAGE
}

[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az
require_env RG LOC PE_NAME SUBNET_ID SA_ID

# az24 usa TARGET_ID come nome variabile
TARGET_ID="$SA_ID"
GROUP_ID="${GROUP_ID:-blob}"

export RG LOC PE_NAME SUBNET_ID TARGET_ID GROUP_ID CONN_NAME

run "$ROOT_DIR/scripts/20-network/az24_private_endpoint_create.sh"