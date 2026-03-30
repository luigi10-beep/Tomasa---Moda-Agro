# Script para criar D1 Database (PowerShell)
# Uso: .\scripts\create-d1.ps1

Write-Host "🗄️  Criando D1 Database..." -ForegroundColor Cyan
Write-Host ""

Set-Location workers

# Criar database
Write-Host "Executando: wrangler d1 create tomasa-db" -ForegroundColor Yellow
Write-Host ""
pnpm wrangler d1 create tomasa-db

Write-Host ""
Write-Host "✅ Database criado com sucesso!" -ForegroundColor Green
Write-Host ""
Write-Host "📝 PRÓXIMOS PASSOS:" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Copie o 'database_id' da saída acima"
Write-Host "2. Abra workers/wrangler.toml"
Write-Host "3. Descomente a seção [[d1_databases]]"
Write-Host "4. Cole o database_id no campo 'database_id'"
Write-Host "5. Execute: pnpm validate:d1"
Write-Host ""
