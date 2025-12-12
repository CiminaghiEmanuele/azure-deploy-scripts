#!/usr/bin/env bash
set -euo pipefail
# Abilita Azure Backup su una VM (Recovery Services Vault esistente)

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Abilita Azure Backup su una VM.

Richiesti:
  RG
  VM
  VAULT_RG
  VAULT

Uso:
  RG=rg-demo VM=vm01 VAULT_RG=rg-backup VAULT=rsv-prod ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }
require_az
require_env RG VM VAULT_RG VAULT

run "az backup protection enable-for-vm --resource-group '$RG' --vm '$VM' --vault-name '$VAULT' --vault-resource-group '$VAULT_RG' -o table"