# Script de validação D1 Database (PowerShell)
# Uso: .\scripts\validate-d1.ps1

Write-Host "🔍 Validando D1 Database..." -ForegroundColor Cyan
Write-Host ""

Set-Location workers

# Verificar se wrangler.toml tem binding configurado
$wranglerContent = Get-Content wrangler.toml -Raw
if ($wranglerContent -notmatch 'database_id\s*=\s*"[^"]+"') {
    Write-Host "❌ Erro: database_id não configurado em wrangler.toml" -ForegroundColor Red
    Write-Host ""
    Write-Host "Execute primeiro:" -ForegroundColor Yellow
    Write-Host "  1. pnpm wrangler d1 create tomasa-db"
    Write-Host "  2. Copie o database_id gerado"
    Write-Host "  3. Atualize workers/wrangler.toml"
    Write-Host ""
    exit 1
}

Write-Host "✅ wrangler.toml configurado" -ForegroundColor Green
Write-Host ""

# Testar conexão
Write-Host "🔐 Testando conexão com D1..." -ForegroundColor Cyan
pnpm wrangler d1 execute tomasa-db --command "SELECT 1 as test, 'Connection OK' as status"

Write-Host ""
Write-Host "✅ D1 Database validado com sucesso!" -ForegroundColor Green
Write-Host ""
Write-Host "Próximos passos:" -ForegroundColor Cyan
Write-Host "  - Task 4: Criar tabela products"
Write-Host "  - Task 5: Criar tabela portfolio"
Write-Host "  - Task 6: Criar tabela videos"
