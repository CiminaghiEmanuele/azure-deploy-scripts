#!/usr/bin/env bash
set -euo pipefail

# az47_vm_attach_data_disks.sh
# Attacca N dischi dati nuovi alla VM.

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
  cat <<USAGE
$SCRIPT_NAME
Crea e attacca dischi dati (managed disks) a una VM.

Richiesti:
  RG
  VM
  COUNT     Numero dischi da creare/attaccare
  SIZE_GB   Size per disco (GB)

Opzionali:
  SKU=Premium_LRS|StandardSSD_LRS|Standard_LRS (default: StandardSSD_LRS)
  PREFIX    prefisso nome disco (default: <VM>-data)

Uso:
  RG=rg-demo VM=vm01 COUNT=2 SIZE_GB=128 SKU=Premium_LRS ./$SCRIPT_NAME

Note:
  - Non inizializza/formatta i dischi dentro l'OS (serve step separato).
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az
require_env RG VM COUNT SIZE_GB

SKU="${SKU:-StandardSSD_LRS}"
PREFIX="${PREFIX:-$VM-data}"

for i in $(seq 1 "$COUNT"); do
  DISK_NAME="${PREFIX}${i}"
  run "az vm disk attach -g '$RG' --vm-name '$VM' --new --size-gb '$SIZE_GB' --sku '$SKU' --name '$DISK_NAME' -o table"
done