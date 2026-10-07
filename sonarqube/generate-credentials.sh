#!/bin/bash

# Script para generar credenciales necesarias para GitHub App

echo "🔐 Generador de Credenciales para GitHub App"
echo "=============================================="
echo ""

# Generar Webhook Secret
echo "📝 Generando Webhook Secret..."
WEBHOOK_SECRET=$(openssl rand -hex 32)
echo ""
echo "✅ Webhook Secret generado:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "$WEBHOOK_SECRET"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📋 Copia este valor y úsalo en:"
echo "   1. GitHub App → Webhook secret"
echo "   2. SonarQube → Configuration → Webhook Secret"
echo ""

# Guardar en archivo
CREDENTIALS_FILE="github-app-credentials.txt"
cat > "$CREDENTIALS_FILE" << EOF
GitHub App Credentials
======================
Generated: $(date)

Webhook Secret:
$WEBHOOK_SECRET

Instructions:
-------------
1. Create GitHub App at: https://github.com/settings/apps/new

2. Use these settings:
   - GitHub App name: SonarQube DevOps
   - Homepage URL: http://localhost:9000
   - Webhook URL: http://localhost:9000/api/alm_integration/github/webhook
   - Webhook secret: [Use the secret above]

3. Set Repository Permissions:
   - Checks: Read & write
   - Commit statuses: Read & write
   - Contents: Read-only
   - Issues: Read & write
   - Pull requests: Read & write

4. Subscribe to events:
   - Pull request
   - Push

5. After creating the app, note down:
   - App ID: _______________
   - Client ID: _______________
   - Client Secret: _______________ (generate on GitHub)
   - Private Key: _______________ (download .pem file)

6. Configure in SonarQube:
   Administration → Configuration → ALM Integrations → GitHub

SonarQube Configuration:
------------------------
Configuration name: devops
GitHub API URL: https://api.github.com/
GitHub App ID: [from step 5]
Client ID: [from step 5]
Client Secret: [from step 5]
Private Key: [paste entire .pem file content]
Webhook Secret: $WEBHOOK_SECRET

EOF

echo "💾 Credenciales guardadas en: $CREDENTIALS_FILE"
echo ""
echo "⚠️  IMPORTANTE: Guarda este archivo en un lugar seguro y NO lo subas a Git"
echo ""
echo "📖 Para más detalles, lee: GITHUB_APP_SETUP.md"
