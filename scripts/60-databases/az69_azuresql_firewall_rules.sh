#!/usr/bin/env bash
set -euo pipefail
# Firewall SQL

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Aggiunge regola firewall su Azure SQL Server.

Richiesti:
  RG
  SQLSERVER
  START_IP
  END_IP
  NAME

Uso:
  RG=rg-db SQLSERVER=sqlsrv START_IP=1.2.3.4 END_IP=1.2.3.4 NAME=office ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }
require_az
require_env RG SQLSERVER START_IP END_IP NAME

run "az sql server firewall-rule create -g '$RG' -s '$SQLSERVER' -n '$NAME' --start-ip-address '$START_IP' --end-ip-address '$END_IP' -o table"