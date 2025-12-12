#!/usr/bin/env bash
set -euo pipefail
SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
  cat <<USAGE
$SCRIPT_NAME
Assegna un ruolo RBAC a un assignee (user/sp/uami) sul Resource Group.

Richiesti:
  RG
  ROLE      (es. "Reader", "Contributor", ...)
  ASSIGNEE  objectId / appId / UPN

Uso:
  RG=rg-demo ROLE=Reader ASSIGNEE=<id|upn> ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az
require_env RG ROLE ASSIGNEE

SCOPE="$(az group show -n "$RG" --query id -o tsv)"
run "az role assignment create --assignee '$ASSIGNEE' --role '$ROLE' --scope '$SCOPE' -o table"