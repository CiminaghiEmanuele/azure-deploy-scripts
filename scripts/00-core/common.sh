#!/bin/bash

# ==============================================================================
# COMMON UTILS FOR AZURE DEPLOY SCRIPTS
# ==============================================================================

# --- COLORS ---
# Usiamo tput se disponibile per maggiore compatibilità, altrimenti codici ANSI
if command -v tput &> /dev/null && tput setaf 1 &> /dev/null; then
    RED=$(tput setaf 1)
    GREEN=$(tput setaf 2)
    YELLOW=$(tput setaf 3)
    BLUE=$(tput setaf 4)
    CYAN=$(tput setaf 6)
    BOLD=$(tput bold)
    RESET=$(tput sgr0)
else
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    CYAN='\033[0;36m'
    BOLD='\033[1m'
    RESET='\033[0m'
fi

# --- LOGGING FUNCTIONS ---

log_header() {
    echo -e "\n${BOLD}${BLUE}=== $1 ===${RESET}\n"
}

log_info() {
    echo -e "${CYAN}[INFO]${RESET} $1"
}

log_success() {
    echo -e "${GREEN}[OK]${RESET}   $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${RESET} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${RESET} $1" >&2
}

# --- CHECKS & VALIDATION ---

# Verifica che l'utente sia loggato in Azure CLI
check_az_login() {
    log_info "Verifica login Azure..."
    if ! command -v az &> /dev/null; then
        log_error "Azure CLI non è installata. Installa 'az' prima di procedere."
        exit 1
    fi

    # Tenta di ottenere il token dell'account corrente.
    # Se fallisce, l'utente non è loggato.
    az account get-access-token --query "accessToken" -o tsv &> /dev/null
    if [ $? -ne 0 ]; then
        log_error "Non sei loggato in Azure."
        echo -e "Esegui: ${BOLD}az login${RESET}"
        exit 1
    fi
    
    local sub_name=$(az account show --query name -o tsv)
    local sub_id=$(az account show --query id -o tsv)
    log_success "Loggato su: ${BOLD}$sub_name${RESET} ($sub_id)"
}

# Verifica che le variabili d'ambiente richieste siano valorizzate
# Usage: verify_env_vars "RG" "LOC" "VM_NAME"
verify_env_vars() {
    local missing_vars=0
    for var_name in "$@"; do
        if [ -z "${!var_name}" ]; then
            log_error "Variabile mancante: ${BOLD}$var_name${RESET}"
            missing_vars=$((missing_vars + 1))
        fi
    done

    if [ $missing_vars -gt 0 ]; then
        echo -e "\n${YELLOW}Esempio di utilizzo:${RESET}"
        echo -e "${BOLD}$1=valore $2=valore ./nome_script.sh${RESET}\n"
        exit 1
    fi
}

# Verifica presenza tool opzionali (es. jq)
check_tool() {
    if ! command -v $1 &> /dev/null; then
        log_warn "Tool '$1' non trovato. Alcune funzionalità potrebbero essere limitate."
        return 1
    fi
    return 0
}

# --- CONFIRMATION ---

confirm_action() {
    local prompt_msg="${1:-Sei sicuro di voler procedere?}"
    echo -e -n "${YELLOW}$prompt_msg [y/N] ${RESET}"
    read -r response
    if [[ ! "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        log_warn "Operazione annullata dall'utente."
        exit 0
    fi
}