#!/usr/bin/env bash
set -euo pipefail

# az41_update_tls_min.sh
# Forza minTlsVersion su App Service (baseline).

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
  cat <<USAGE
$SCRIPT_NAME
Imposta min TLS version su App Service.

Richiesti:
  RG
  APP

Opzionali:
  TLS=1.2 (default 1.2)

Uso:
  RG=rg-app APP=web-demo TLS=1.2 ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az
require_env RG APP

TLS="${TLS:-1.2}"
run "az webapp update -g '$RG' -n '$APP' --set siteConfig.minTlsVersion='$TLS' -o table"