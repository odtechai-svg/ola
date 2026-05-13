#!/bin/sh
# Cron job: chama o endpoint de push notification diário
# Adicionar ao cron do VPS:
#   0 20 * * * /opt/ola/scripts/daily-reminder.sh >> /var/log/ola-cron.log 2>&1

APP_URL="${OLA_APP_URL:-http://localhost:3000}"
CRON_SECRET="${CRON_SECRET:-ola-cron-2026}"

curl -s -X GET "${APP_URL}/api/push/daily-reminder" \
  -H "x-cron-secret: ${CRON_SECRET}" \
  && echo "[$(date)] push enviado com sucesso" \
  || echo "[$(date)] ERRO ao enviar push"
