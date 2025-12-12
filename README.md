Azure Deploy Scripts

Practical Azure CLI Toolkit for Real-World Deployments

🇮🇹 Italiano

Chi sono e perché esiste questo repository

Sono un Cloud Solution Architect / Azure Engineer che lavora quotidianamente su ambienti Azure reali: migrazioni, modernizzazione applicativa, sicurezza, governance, FinOps e operation e troubleshooting.

Questo repository nasce da un’esigenza concreta:

Avere script pratici, riutilizzabili e affidabili per lavorare su Azure in modo consistente, senza perdere tempo sul portale e senza reinventare ogni volta le stesse soluzioni.

Gli script presenti non sono esempi teorici, ma pattern operativi utilizzati come base in:

progetti cliente

attività di presales e assessment

academy tecniche

operation e troubleshooting

Requisiti

Shell Bash supportate

Azure Cloud Shell (consigliata)

Linux / macOS

WSL su Windows

Git Bash (supportata, attenzione ai line ending)

Strumenti

Azure CLI installata

Autenticazione attiva:

az login


Strumenti opzionali:

jq per una migliore lettura del JSON

Come usare gli script

Opzione 1 – Azure Cloud Shell (Consigliata)

Azure Cloud Shell è l’ambiente ideale perché preconfigurato: non avrai problemi di permessi, path o versioni della CLI.

Clona il repository e rendi eseguibili gli script:

git clone <URL_DEL_REPO>
cd azure-deploy-scripts
chmod +x scripts/**/*.sh 2>/dev/null || true


Esempio di esecuzione:

RG=rg-demo LOC=italynorth ./scripts/00-core/az02_create_rg.sh


Opzione 2 – Locale (Linux / macOS / WSL)

Se preferisci lavorare in locale, assicurati di avere Azure CLI installata e di aver fatto il login (az login).

Clona e prepara:

git clone <URL_DEL_REPO>
cd azure-deploy-scripts
chmod +x scripts/**/*.sh


Esecuzione:

RG=rg-demo LOC=italynorth ./scripts/00-core/az02_create_rg.sh


⚠️ Nota importante per utenti Windows (CRLF)

Se lavori su Windows e modifichi o generi file .sh (anche usando VS Code), potresti incorrere in errori dovuti ai line ending (CRLF invece di LF).

Sintomi tipici:

Errore: bad interpreter: No such file or directory

Errori di sintassi con caratteri invisibili come ^M

Soluzione rapida (Fix portabile):
Esegui questo comando sul file che ti dà problemi per convertirlo al volo:

tr -d '\r' < nomefile.sh > fixed.sh && mv fixed.sh nomefile.sh
chmod +x nomefile.sh


Questo passaggio è normale, corretto e volutamente documentato, soprattutto in team misti Windows / Linux.

Filosofia degli script

Gli script sono progettati per essere stateless e guidati da variabili d'ambiente.

Passaggio parametri inline
Non devi modificare lo script. Passa le variabili prima del comando:

RG=rg-demo VM=vm01 ./scripts/40-compute/az52_vm_enable_monitor_agent.sh


Help integrato
Ogni script include un help per vedere quali variabili sono richieste:

./scripts/00-core/az02_create_rg.sh --help


Controlli di sicurezza
Lo script verifica automaticamente se sei loggato in Azure e se mancano variabili obbligatorie prima di eseguire qualsiasi modifica.

Logging leggibile
Output chiaro per capire cosa sta succedendo step-by-step.

Struttura del repository

scripts/
├── 00-core                Operazioni base e Bicep
├── 10-identity            Identity, RBAC, Key Vault
├── 20-network             Networking e Private Endpoint
├── 30-security            Security baseline e Policy
├── 40-compute             Virtual Machines
├── 50-storage             Storage Account e dati
├── 60-databases           Database e licensing
├── 70-app                 App Service, AKS, integrazioni
├── 80-observability       Monitor, alert, Log Analytics
└── 90-governance-finops   Governance e Cost Management


Esempi di utilizzo per area

00-core

./scripts/00-core/az01_set_subscription.sh
RG=rg-demo LOC=italynorth ./scripts/00-core/az02_create_rg.sh
./scripts/00-core/az06_whatif_bicep.sh


10-identity

RG=rg-demo ID_NAME=uami-demo ./scripts/10-identity/az10_create_uami.sh
RG=rg-demo PRINCIPAL_ID=<id> ROLE=Reader ./scripts/10-identity/az11_assign_role_rg.sh


20-network

RG=rg-net LOC=italynorth VNET=vnet-demo CIDR=10.0.0.0/16 ./scripts/20-network/az20_create_vnet_subnets.sh


30-security

./scripts/30-security/az35_defender_enable_subscription.sh
./scripts/30-security/az36_pim_checklist.sh


40-compute

RG=rg-demo VM=vm01 ./scripts/40-compute/az50_vm_enable_backup.sh
RG=rg-demo VM=vm01 ./scripts/40-compute/az52_vm_enable_monitor_agent.sh


50-storage

RG=rg-demo LOC=italynorth SA=stprod12345 ./scripts/50-storage/az55_storage_create.sh
SA=stprod12345 CONTAINER=data ./scripts/50-storage/az56_storage_container_create.sh


60-databases

RG=rg-db VM=sqlvm01 ./scripts/60-databases/az65_sqlvm_register.sh
RG=rg-db VM=sqlvm01 ./scripts/60-databases/az66_sqlvm_set_license_model_payg.sh


70-app

RG=rg-app LOC=italynorth PLAN=asp-demo ./scripts/70-app/az75_appservice_plan_create.sh
RG=rg-app APP=webdemo ./scripts/70-app/az77_webapp_deploy_zip.sh


80-observability

RG=rg-mon LOC=italynorth ./scripts/80-observability/az90_law_create.sh
RG=rg-app APP=webdemo ./scripts/80-observability/az94_alert_app_http5xx_create.sh


90-governance-finops

./scripts/90-governance-finops/gf00_policy_list_assignments.sh
TAGS="Owner,CostCenter,Env" ./scripts/90-governance-finops/gf08_tags_report_missing.sh
SUBSCRIPTION_ID=<id> ./scripts/90-governance-finops/gf14_cost_query_month_to_date.sh


Avvertenze

Gli script creano, modificano o eliminano risorse Azure.
Usarli solo se:

Si conosce la subscription attiva.

Si comprende lo scope.

Si è consapevoli dell’impatto delle operazioni.

Best practice iniziale:

./scripts/00-core/az01_set_subscription.sh


Licenza

Vedi file LICENSE.