#!/usr/bin/env bash
set -euo pipefail
# Crea Azure SQL Server + DB

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Crea Azure SQL logical server + database.

Richiesti:
  RG LOC
  SQLSERVER
  ADMIN PASSWORD
  DB

Uso:
  RG=rg-db LOC=italynorth SQLSERVER=sqlsrvdemo ADMIN=sqladmin PASSWORD='P@ss!' DB=appdb ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }
require_az
require_env RG LOC SQLSERVER ADMIN PASSWORD DB

run "az sql server create -g '$RG' -n '$SQLSERVER' -l '$LOC' -u '$ADMIN' -p '$PASSWORD' -o table"
run "az sql db create -g '$RG' -s '$SQLSERVER' -n '$DB' --service-objective S0 -o table"