#!/usr/bin/env bash
set -euo pipefail
# Registra SQL VM con SQL IaaS Agent

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Registra una VM SQL nel SQL IaaS Agent.

Richiesti:
  RG
  VM

Uso:
  RG=rg-db VM=sqlvm01 ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }
require_az
require_env RG VM

run "az sql vm create -g '$RG' -n '$VM' --license-type PAYG -o table"