#!/usr/bin/env bash
set -euo pipefail
# Crea Azure Database for PostgreSQL Flexible Server (baseline public access disabled by default)

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Crea PostgreSQL Flexible Server.

Richiesti:
  RG LOC
  PG_NAME
  ADMIN PASSWORD

Opzionali:
  SKU=Standard_D2s_v3
  STORAGE_GB=128
  VERSION=16
  PUBLIC_ACCESS=Disabled|Enabled (default: Disabled)

Uso:
  RG=rg-db LOC=italynorth PG_NAME=pgdemo ADMIN=pgadmin PASSWORD='P@ss!' ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az
require_env RG LOC PG_NAME ADMIN PASSWORD

SKU="${SKU:-Standard_D2s_v3}"
STORAGE_GB="${STORAGE_GB:-128}"
VERSION="${VERSION:-16}"
PUBLIC_ACCESS="${PUBLIC_ACCESS:-Disabled}"

run "az postgres flexible-server create -g '$RG' -l '$LOC' -n '$PG_NAME' -u '$ADMIN' -p '$PASSWORD' --sku-name '$SKU' --storage-size '$STORAGE_GB' --version '$VERSION' --public-access '$PUBLIC_ACCESS' --tags $(safe_default_tags) -o table"