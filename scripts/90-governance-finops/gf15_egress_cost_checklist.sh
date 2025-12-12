#!/usr/bin/env bash
set -euo pipefail
# Egress cost checklist (common hidden cost driver)

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Egress cost checklist.

Usage:
  ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

log "Checklist:"
log "1) Identify top bandwidth consumers (Front Door, CDN, Storage, VM outbound)."
log "2) Verify regions: cross-region traffic often increases cost."
log "3) Consider Private Link, caching, compression, and right routing."
log "4) Review logs/metrics for outbound spikes."
log "5) Check Azure pricing for Bandwidth and premium global network options."