#!/bin/bash

# Script de validação D1 Database
# Uso: ./scripts/validate-d1.sh

set -e

echo "🔍 Validando D1 Database..."
echo ""

cd workers

# Verificar se wrangler.toml tem binding configurado
if ! grep -q "database_id.*=.*\".*\"" wrangler.toml; then
    echo "❌ Erro: database_id não configurado em wrangler.toml"
    echo ""
    echo "Execute primeiro:"
    echo "  1. pnpm wrangler d1 create tomasa-db"
    echo "  2. Copie o database_id gerado"
    echo "  3. Atualize workers/wrangler.toml"
    echo ""
    exit 1
fi

echo "✅ wrangler.toml configurado"
echo ""

# Testar conexão
echo "🔐 Testando conexão com D1..."
pnpm wrangler d1 execute tomasa-db --command "SELECT 1 as test, 'Connection OK' as status"

echo ""
echo "✅ D1 Database validado com sucesso!"
echo ""
echo "Próximos passos:"
echo "  - Task 4: Criar tabela products"
echo "  - Task 5: Criar tabela portfolio"
echo "  - Task 6: Criar tabela videos"
