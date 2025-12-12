#!/usr/bin/env bash
set -euo pipefail
# Crea Azure Database for MySQL Flexible Server (baseline public access disabled by default)

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Crea MySQL Flexible Server.

Richiesti:
  RG LOC
  MYSQL_NAME
  ADMIN PASSWORD

Opzionali:
  SKU=Standard_D2ds_v4
  STORAGE_GB=128
  VERSION=8.0.21
  PUBLIC_ACCESS=Disabled|Enabled (default: Disabled)

Uso:
  RG=rg-db LOC=italynorth MYSQL_NAME=mysqldemo ADMIN=mysqladmin PASSWORD='P@ss!' ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az
require_env RG LOC MYSQL_NAME ADMIN PASSWORD

SKU="${SKU:-Standard_D2ds_v4}"
STORAGE_GB="${STORAGE_GB:-128}"
VERSION="${VERSION:-8.0.21}"
PUBLIC_ACCESS="${PUBLIC_ACCESS:-Disabled}"

run "az mysql flexible-server create -g '$RG' -l '$LOC' -n '$MYSQL_NAME' -u '$ADMIN' -p '$PASSWORD' --sku-name '$SKU' --storage-size '$STORAGE_GB' --version '$VERSION' --public-access '$PUBLIC_ACCESS' --tags $(safe_default_tags) -o table"