#!/bin/bash

# Carrega variáveis do .env (caminho relativo ao script)
ENV_FILE="$(dirname "$0")/.env"
if [ -f "$ENV_FILE" ]; then
    source "$ENV_FILE"
else
    echo "Erro: Arquivo .env não encontrado em $(dirname "$0")!" >&2
    exit 1
fi

# Configurações
SITE_URL="$MY_IP"
LOG_FILE="/var/log/monitoramento_site.log"
DISCORD_WEBHOOK="$WEBHOOK"

# garantindo a existência do diretório
mkdir -p "$(dirname "$LOG_FILE")"

# Função para registrar logs
log() {
   echo "[$(date '+%d-%m-%Y %H:%M:%S')] $1" >> "$LOG_FILE"
}

# Função para verificar o site
check_site() {
    local HTTP_STATUS
    HTTP_STATUS=$(curl -o /dev/null -s -w "%{http_code}" "$SITE_URL")
    
    if [[ "$HTTP_STATUS" -eq 200 ]]; then
        log "Site $SITE_URL está ONLINE (Status: $HTTP_STATUS)"
        return 0
    else
        log "ALERTA: Site $SITE_URL OFFLINE (Status: $HTTP_STATUS)"
        send_notification "🔴 Site $SITE_URL está OFFLINE! Status: $HTTP_STATUS"
        exit 1
    fi
}

# Função para enviar notificação
send_notification() {
  if [[ -n "$DISCORD_WEBHOOK" ]]; then
    payload=$(printf '{"content":"%s"}' "$1")
    curl -H "Content-Type: application/json" -d "$payload" "$DISCORD_WEBHOOK" >/dev/null 2>&1
  fi
}

# Execução principal

check_site
