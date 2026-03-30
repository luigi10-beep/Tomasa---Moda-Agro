#!/bin/bash

# Script de validação de credenciais Cloudflare
# Uso: ./scripts/validate-cloudflare.sh

set -e

echo "🔍 Validando configuração Cloudflare..."
echo ""

# Verificar se .env.local existe
if [ ! -f .env.local ]; then
    echo "❌ Erro: Arquivo .env.local não encontrado"
    echo "   Copie .env.example para .env.local e preencha as credenciais"
    exit 1
fi

# Carregar variáveis de ambiente
source .env.local

# Verificar CLOUDFLARE_ACCOUNT_ID
if [ -z "$CLOUDFLARE_ACCOUNT_ID" ]; then
    echo "❌ Erro: CLOUDFLARE_ACCOUNT_ID não configurado"
    echo "   Preencha o Account ID no arquivo .env.local"
    exit 1
fi

echo "✅ CLOUDFLARE_ACCOUNT_ID: ${CLOUDFLARE_ACCOUNT_ID:0:8}..."

# Verificar CLOUDFLARE_API_TOKEN
if [ -z "$CLOUDFLARE_API_TOKEN" ]; then
    echo "❌ Erro: CLOUDFLARE_API_TOKEN não configurado"
    echo "   Preencha o API Token no arquivo .env.local"
    exit 1
fi

echo "✅ CLOUDFLARE_API_TOKEN: ${CLOUDFLARE_API_TOKEN:0:8}..."
echo ""

# Validar com wrangler
echo "🔐 Validando credenciais com Cloudflare..."
cd workers
pnpm wrangler whoami

echo ""
echo "✅ Configuração Cloudflare validada com sucesso!"
echo ""
echo "Próximos passos:"
echo "  - Task 3: Provisionar D1 Database"
echo "  - Task 7: Provisionar R2 Bucket"
echo "  - Task 9: Configurar Workers"
