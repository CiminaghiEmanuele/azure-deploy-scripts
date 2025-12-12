#!/usr/bin/env bash
set -euo pipefail

# az39_sql_secure_baseline.sh
# Baseline per Azure SQL logical server: TLS 1.2 + (opzionale) public network access disable.

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
  cat <<USAGE
$SCRIPT_NAME
Applica baseline a un Azure SQL Server (logical server).

Richiesti:
  RG
  SQLSERVER

Opzionali:
  PUBLIC_NETWORK_ACCESS=Disabled (default: Enabled)

Uso:
  RG=rg-data SQLSERVER=sqlsrv-demo PUBLIC_NETWORK_ACCESS=Disabled ./$SCRIPT_NAME

Note:
  - Per accesso privato: Private Endpoint + Private DNS + firewall.
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az
require_env RG SQLSERVER

PNA="${PUBLIC_NETWORK_ACCESS:-Enabled}"
run "az sql server update -g '$RG' -n '$SQLSERVER' --minimal-tls-version 1.2 --public-network-access '$PNA' -o table"