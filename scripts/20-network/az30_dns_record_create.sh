#!/usr/bin/env bash
set -euo pipefail

# az30_dns_record_create.sh
# Crea un record A in una DNS Zone (public DNS) dentro un Resource Group.

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
  cat <<USAGE
$SCRIPT_NAME
Crea un record A in una DNS Zone Azure (public).

Richiesti:
  RG       Resource Group della DNS zone
  ZONE     Nome zona (es. contoso.com)
  RECORD   Record set name (es. www)
  IP       IPv4 da associare

Uso:
  RG=rg-dns ZONE=contoso.com RECORD=www IP=1.2.3.4 ./$SCRIPT_NAME

Note:
  - Per Private DNS usa az23/az24 + private-dns record-set (non questo).
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az
require_env RG ZONE RECORD IP

# Idempotenza: crea record-set se non esiste.
if az network dns record-set a show -g "$RG" -z "$ZONE" -n "$RECORD" >/dev/null 2>&1; then
  log "Record-set esistente: $RECORD.$ZONE (aggiungo/aggiorno IP)."
else
  run "az network dns record-set a create -g '$RG' -z '$ZONE' -n '$RECORD' -o table"
fi

# Rimuovo eventuali record uguali e lo riaggiungo per evitare duplicati.
run "az network dns record-set a remove-record -g '$RG' -z '$ZONE' -n '$RECORD' -a '$IP' --keep-empty-record-set true -o none" || true
run "az network dns record-set a add-record -g '$RG' -z '$ZONE' -n '$RECORD' -a '$IP' -o table"