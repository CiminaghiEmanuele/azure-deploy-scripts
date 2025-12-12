#!/usr/bin/env bash
set -euo pipefail
# Crea Event Grid topic + subscription (webhook endpoint)

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Crea Event Grid Topic e una subscription webhook.

Richiesti:
  RG LOC
  TOPIC
  ENDPOINT   (webhook https)

Opzionali:
  SUB_NAME=sub1

Uso:
  RG=rg-app LOC=italynorth TOPIC=topic-demo ENDPOINT=https://example.com/hook ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az
require_env RG LOC TOPIC ENDPOINT

SUB_NAME="${SUB_NAME:-sub1}"

run "az eventgrid topic create -g '$RG' -n '$TOPIC' -l '$LOC' --tags $(safe_default_tags) -o table"
run "az eventgrid event-subscription create --source-resource-id $(az eventgrid topic show -g '$RG' -n '$TOPIC' --query id -o tsv) -n '$SUB_NAME' --endpoint '$ENDPOINT' -o table"