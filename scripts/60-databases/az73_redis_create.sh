#!/usr/bin/env bash
set -euo pipefail
# Crea Azure Cache for Redis (Basic/Standard/Premium). Enterprise baseline: TLS 1.2

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Crea Azure Cache for Redis.

Richiesti:
  RG LOC
  REDIS

Opzionali:
  SKU=Basic|Standard|Premium (default: Basic)
  SIZE=C0|C1|C2|C3|C4|C5|C6 (default: C1)

Uso:
  RG=rg-db LOC=italynorth REDIS=redisdemo SKU=Standard SIZE=C2 ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az
require_env RG LOC REDIS

SKU="${SKU:-Basic}"
SIZE="${SIZE:-C1}"

run "az redis create -g '$RG' -n '$REDIS' -l '$LOC' --sku '$SKU' --vm-size '$SIZE' --minimum-tls-version 1.2 --tags $(safe_default_tags) -o table"