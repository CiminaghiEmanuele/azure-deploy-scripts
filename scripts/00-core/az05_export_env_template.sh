#!/usr/bin/env bash
set -euo pipefail

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
  cat <<USAGE
$SCRIPT_NAME
Genera un file examples/env.example con variabili standard di deploy.

Uso:
  ./$SCRIPT_NAME
USAGE
}

[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

cat > "$ROOT_DIR/examples/env.example" <<EOF
export SUBSCRIPTION=""
export LOC="italynorth"
export RG="rg-demo-dev-itn"
export VNET="vnet-demo"
export SUBNET="snet-app"
export SA="stdev12345"
export KV="kv-demo-12345"
export TAGS_JSON='{"Owner":"team","Env":"dev"}'
EOF

log "Creato examples/env.example"