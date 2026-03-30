#!/bin/bash

# Script para criar D1 Database
# Uso: ./scripts/create-d1.sh

set -e

echo "🗄️  Criando D1 Database..."
echo ""

cd workers

# Criar database
echo "Executando: wrangler d1 create tomasa-db"
echo ""
pnpm wrangler d1 create tomasa-db

echo ""
echo "✅ Database criado com sucesso!"
echo ""
echo "📝 PRÓXIMOS PASSOS:"
echo ""
echo "1. Copie o 'database_id' da saída acima"
echo "2. Abra workers/wrangler.toml"
echo "3. Descomente a seção [[d1_databases]]"
echo "4. Cole o database_id no campo 'database_id'"
echo "5. Execute: pnpm validate:d1"
echo ""
