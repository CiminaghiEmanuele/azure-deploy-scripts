#!/usr/bin/env bash
set -euo pipefail
# Crea metric alert su Web App per HTTP 5xx (ServerErrors)

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Crea alert su HTTP 5xx per Web App (metric alert).

Richiesti:
  RG
  ALERT_NAME
  APP_ID
  ACTION_GROUP_ID

Opzionali:
  THRESHOLD=5 (numero errori nel window)
  WINDOW=5m
  EVAL=1m
  SEVERITY=2

Uso:
  RG=rg-obs ALERT_NAME=app5xx APP_ID="/subscriptions/.../sites/web" ACTION_GROUP_ID="/subscriptions/.../actionGroups/ag1" ./$SCRIPT_NAME

Note:
  - La metrica puo' essere Http5xx o ServerErrors a seconda del provider; qui usiamo Http5xx.
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az
require_env RG ALERT_NAME APP_ID ACTION_GROUP_ID

THRESHOLD="${THRESHOLD:-5}"
WINDOW="${WINDOW:-5m}"
EVAL="${EVAL:-1m}"
SEVERITY="${SEVERITY:-2}"

run "az monitor metrics alert create -g '$RG' -n '$ALERT_NAME' --scopes '$APP_ID' --condition \"total Http5xx > $THRESHOLD\" --window-size '$WINDOW' --evaluation-frequency '$EVAL' --severity '$SEVERITY' --action '$ACTION_GROUP_ID' -o table"