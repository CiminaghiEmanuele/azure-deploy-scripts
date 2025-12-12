#!/usr/bin/env bash
set -euo pipefail
# Policy lifecycle blob

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Applica lifecycle policy a blob storage.

Richiesti:
  RG
  SA

Opzionali:
  DAYS_COOL=30
  DAYS_DELETE=365

Uso:
  RG=rg-demo SA=stprod12345 ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }
require_az
require_env RG SA

DAYS_COOL="${DAYS_COOL:-30}"
DAYS_DELETE="${DAYS_DELETE:-365}"

cat > lifecycle.json <<EOF
{
  "rules": [
    {
      "name": "lifecycle-default",
      "type": "Lifecycle",
      "definition": {
        "actions": {
          "baseBlob": {
            "tierToCool": { "daysAfterModificationGreaterThan": $DAYS_COOL },
            "delete": { "daysAfterModificationGreaterThan": $DAYS_DELETE }
          }
        },
        "filters": { "blobTypes": ["blockBlob"] }
      }
    }
  ]
}
EOF

run "az storage account management-policy create -g '$RG' -n '$SA' --policy @lifecycle.json -o table"
rm -f lifecycle.json