#!/usr/bin/env bash
set -euo pipefail
# Crea metric alert CPU alta su una VM (Azure Monitor Metrics)

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Crea alert su CPU alta per una VM (metric alert).

Richiesti:
  RG
  ALERT_NAME
  VM_ID    (resource id VM)
  ACTION_GROUP_ID (resource id action group)

Opzionali:
  THRESHOLD=80
  WINDOW=5m
  EVAL=1m
  SEVERITY=2

Uso:
  RG=rg-obs ALERT_NAME=vmcpu VM_ID="/subscriptions/.../virtualMachines/vm01" ACTION_GROUP_ID="/subscriptions/.../actionGroups/ag1" ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az
require_env RG ALERT_NAME VM_ID ACTION_GROUP_ID

THRESHOLD="${THRESHOLD:-80}"
WINDOW="${WINDOW:-5m}"
EVAL="${EVAL:-1m}"
SEVERITY="${SEVERITY:-2}"

run "az monitor metrics alert create -g '$RG' -n '$ALERT_NAME' --scopes '$VM_ID' --condition \"avg Percentage CPU > $THRESHOLD\" --window-size '$WINDOW' --evaluation-frequency '$EVAL' --severity '$SEVERITY' --action '$ACTION_GROUP_ID' -o table"