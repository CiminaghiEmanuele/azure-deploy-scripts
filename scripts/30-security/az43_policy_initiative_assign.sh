#!/usr/bin/env bash
set -euo pipefail

# az43_policy_initiative_assign.sh
# Assegna una Initiative (Policy Set Definition) built-in cercandola per displayName.
# Enterprise note: meglio salvare l'ID esplicito (piÃ¹ stabile), ma qui restiamo comodi.

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
  cat <<USAGE
$SCRIPT_NAME
Assegna una Policy Initiative (built-in) a uno scope.

Richiesti:
  SCOPE            (es. /subscriptions/<id> oppure /subscriptions/<id>/resourceGroups/<rg>)
  POLICY_SET_NAME  displayName della initiative

Opzionali:
  ASSIGN_NAME      (default: assign-<timestamp>)
  LOCATION         (se richiesto da alcune policy, default: italynorth)

Uso:
  SCOPE="/subscriptions/<id>" POLICY_SET_NAME="Azure Security Benchmark" ./$SCRIPT_NAME

Note:
  - Se non trova l'initiative per nome, esci con errore.
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

require_az
require_env SCOPE POLICY_SET_NAME

ASSIGN_NAME="${ASSIGN_NAME:-assign-$(date +%H%M%S)}"
LOCATION="${LOCATION:-italynorth}"

DEF_ID="$(az policy set-definition list --query "[?displayName=='$POLICY_SET_NAME']|[0].id" -o tsv)"
[[ -n "$DEF_ID" ]] || die "Policy initiative non trovata: $POLICY_SET_NAME"

# Alcune iniziative richiedono location anche se scope Ã¨ subscription.
run "az policy assignment create -n '$ASSIGN_NAME' --scope '$SCOPE' --policy-set-definition '$DEF_ID' -l '$LOCATION' -o table"