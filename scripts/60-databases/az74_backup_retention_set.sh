#!/usr/bin/env bash
set -euo pipefail
# Set retention: implementazione generica per Postgres/MySQL Flexible (backup retention days)

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Imposta retention backup (giorni) su Postgres/MySQL Flexible Server.

Richiesti:
  TYPE=postgres|mysql
  RG
  NAME
  DAYS

Uso:
  TYPE=postgres RG=rg-db NAME=pgdemo DAYS=14 ./$SCRIPT_NAME
  TYPE=mysql    RG=rg-db NAME=mysqldemo DAYS=14 ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az
require_env TYPE RG NAME DAYS

if [[ "$TYPE" == "postgres" ]]; then
  run "az postgres flexible-server update -g '$RG' -n '$NAME' --backup-retention '$DAYS' -o table"
elif [[ "$TYPE" == "mysql" ]]; then
  run "az mysql flexible-server update -g '$RG' -n '$NAME' --backup-retention '$DAYS' -o table"
else
  die "TYPE must be postgres or mysql"
fi