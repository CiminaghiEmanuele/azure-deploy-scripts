#!/usr/bin/env bash
set -euo pipefail
SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
  cat <<USAGE
$SCRIPT_NAME
Assegna un ruolo RBAC a un assignee su uno scope arbitrario.

Richiesti:
  SCOPE     (es. /subscriptions/.../resourceGroups/... )
  ROLE
  ASSIGNEE

Uso:
  SCOPE="/subscriptions/<id>/resourceGroups/rg-demo" ROLE=Reader ASSIGNEE=<id|upn> ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az
require_env SCOPE ROLE ASSIGNEE
run "az role assignment create --assignee '$ASSIGNEE' --role '$ROLE' --scope '$SCOPE' -o table"