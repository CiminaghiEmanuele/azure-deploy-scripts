#!/usr/bin/env bash
set -euo pipefail
SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
  cat <<USAGE
$SCRIPT_NAME
Crea un gruppo Entra ID (Azure AD).

Richiesti:
  GROUP_NAME  Nome del gruppo

Uso:
  GROUP_NAME="Cloud Admins" ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az
require_env GROUP_NAME
MAIL_NICK="${MAIL_NICK:-$(echo "$GROUP_NAME" | tr -cd '[:alnum:]' | tr '[:upper:]' '[:lower:]')}"
run "az ad group create --display-name '$GROUP_NAME' --mail-nickname '$MAIL_NICK' -o json"