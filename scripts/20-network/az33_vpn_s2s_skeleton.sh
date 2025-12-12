#!/usr/bin/env bash
set -euo pipefail

# az33_vpn_s2s_skeleton.sh
# Non crea tutto automaticamente perchÃ© i parametri S2S variano (ASN/BGP, IPsec policy, device vendor).
# Ti lascia uno skeleton "sicuro" e una checklist rapida.

SCRIPT_NAME=$(basename "$0")
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$ROOT_DIR/lib/common.sh"

usage() {
  cat <<USAGE
$SCRIPT_NAME
Skeleton e checklist per VPN Site-to-Site (RouteBased).

Richiesti:
  (nessuno) - stampa comandi e checklist

Uso:
  ./$SCRIPT_NAME

Suggerimento:
  - Preparare prima VNet + GatewaySubnet
  - PIP Standard statico
  - SKU gateway coerente con throughput/SLA
USAGE
}
[[ "${1:-}" =~ ^(-h|--help)$ ]] && { usage; exit 0; }

log "Checklist VPN S2S:"
log "1) Definisci address space on-prem e Azure (non sovrapposti)"
log "2) Crea GatewaySubnet (CIDR dedicato, es. /27 o /26)"
log "3) Public IP Standard statico"
log "4) Crea Virtual Network Gateway (RouteBased)"
log "5) Crea Local Network Gateway (on-prem public IP + address space)"
log "6) Crea connection + (opzionale) BGP"
echo ""
log "Skeleton comandi (da adattare):"
echo "az network public-ip create -g <RG> -n <PIP> -l <LOC> --sku Standard --allocation-method Static"
echo "az network vnet subnet create -g <RG> --vnet-name <VNET> -n GatewaySubnet --address-prefixes <CIDR>"
echo "az network vnet-gateway create -g <RG> -n <VGW> -l <LOC> --public-ip-addresses <PIP> --vnet <VNET> --gateway-type Vpn --vpn-type RouteBased --sku VpnGw1"
echo "az network local-gateway create -g <RG> -n <LGW> --gateway-ip-address <ONPREM_PUBLIC_IP> --local-address-prefixes <ONPREM_PREFIXES>"
echo "az network vpn-connection create -g <RG> -n <CONN> --vnet-gateway1 <VGW> --local-gateway2 <LGW> --shared-key <PSK>"