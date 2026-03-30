# Script de validação de credenciais Cloudflare (PowerShell)
# Uso: .\scripts\validate-cloudflare.ps1

Write-Host "🔍 Validando configuração Cloudflare..." -ForegroundColor Cyan
Write-Host ""

# Verificar se .env.local existe
if (-not (Test-Path .env.local)) {
    Write-Host "❌ Erro: Arquivo .env.local não encontrado" -ForegroundColor Red
    Write-Host "   Copie .env.example para .env.local e preencha as credenciais" -ForegroundColor Yellow
    exit 1
}

# Carregar variáveis de ambiente
Get-Content .env.local | ForEach-Object {
    if ($_ -match '^([^=]+)=(.*)$') {
        $name = $matches[1].Trim()
        $value = $matches[2].Trim()
        Set-Item -Path "env:$name" -Value $value
    }
}

# Verificar CLOUDFLARE_ACCOUNT_ID
if ([string]::IsNullOrEmpty($env:CLOUDFLARE_ACCOUNT_ID)) {
    Write-Host "❌ Erro: CLOUDFLARE_ACCOUNT_ID não configurado" -ForegroundColor Red
    Write-Host "   Preencha o Account ID no arquivo .env.local" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ CLOUDFLARE_ACCOUNT_ID: $($env:CLOUDFLARE_ACCOUNT_ID.Substring(0, 8))..." -ForegroundColor Green

# Verificar CLOUDFLARE_API_TOKEN
if ([string]::IsNullOrEmpty($env:CLOUDFLARE_API_TOKEN)) {
    Write-Host "❌ Erro: CLOUDFLARE_API_TOKEN não configurado" -ForegroundColor Red
    Write-Host "   Preencha o API Token no arquivo .env.local" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ CLOUDFLARE_API_TOKEN: $($env:CLOUDFLARE_API_TOKEN.Substring(0, 8))..." -ForegroundColor Green
Write-Host ""

# Validar com wrangler
Write-Host "🔐 Validando credenciais com Cloudflare..." -ForegroundColor Cyan
Set-Location workers
pnpm wrangler whoami

Write-Host ""
Write-Host "✅ Configuração Cloudflare validada com sucesso!" -ForegroundColor Green
Write-Host ""
Write-Host "Próximos passos:" -ForegroundColor Cyan
Write-Host "  - Task 3: Provisionar D1 Database"
Write-Host "  - Task 7: Provisionar R2 Bucket"
Write-Host "  - Task 9: Configurar Workers"
