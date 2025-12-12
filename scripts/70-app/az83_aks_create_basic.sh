#!/usr/bin/env bash
set -euo pipefail
# Crea AKS base (scelte volutamente conservative per un quickstart)

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
cat <<USAGE
$SCRIPT_NAME
Crea un cluster AKS base.

Richiesti:
  RG LOC
  AKS

Opzionali:
  NODE_COUNT=2
  NODE_SIZE=Standard_D4s_v5
  K8S_VERSION="" (vuoto = default)
  ENABLE_MONITORING=1 (default: 1)

Uso:
  RG=rg-aks LOC=italynorth AKS=aks-demo NODE_COUNT=2 ./$SCRIPT_NAME
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }
require_az
require_env RG LOC AKS

NODE_COUNT="${NODE_COUNT:-2}"
NODE_SIZE="${NODE_SIZE:-Standard_D4s_v5}"
K8S_VERSION="${K8S_VERSION:-}"
ENABLE_MONITORING="${ENABLE_MONITORING:-1}"

MON_FLAG="--enable-addons monitoring"
if [[ "$ENABLE_MONITORING" != "1" ]]; then MON_FLAG=""; fi

VER_FLAG=""
if [[ -n "$K8S_VERSION" ]]; then VER_FLAG="--kubernetes-version $K8S_VERSION"; fi

# shellcheck disable=SC2086
run "az aks create -g '$RG' -n '$AKS' -l '$LOC' --node-count '$NODE_COUNT' --node-vm-size '$NODE_SIZE' --enable-managed-identity --generate-ssh-keys $MON_FLAG $VER_FLAG --tags $(safe_default_tags) -o table"