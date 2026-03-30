# Quick Start Guide - TOMASA

## 1. Instalação

```bash
# Instalar dependências
pnpm install
```

## 2. Configuração Cloudflare

Siga o guia detalhado: [CLOUDFLARE_SETUP.md](./CLOUDFLARE_SETUP.md)

**Resumo:**
1. Obtenha Account ID no Cloudflare Dashboard
2. Crie API Token com permissões D1, R2, Workers, Pages
3. Preencha `.env.local` com as credenciais
4. Valide com: `pnpm validate:cloudflare`

## 3. Validação

```bash
# Windows (PowerShell)
.\scripts\validate-cloudflare.ps1

# Linux/Mac
chmod +x scripts/validate-cloudflare.sh
./scripts/validate-cloudflare.sh
```

## 4. Desenvolvimento

```bash
# Rodar todos os apps em desenvolvimento
pnpm dev

# Rodar apenas o site público (porta 3000)
cd apps/web && pnpm dev

# Rodar apenas o admin (porta 3001)
cd apps/admin && pnpm dev

# Rodar apenas os workers
cd workers && pnpm dev
```

## 5. Build

```bash
# Build de todos os pacotes
pnpm build
```

## Estrutura do Projeto

```
tomasa-monorepo/
├── apps/
│   ├── web/          # Site público (br.tomasa.com, uy.tomasa.com)
│   └── admin/        # Painel admin (admin.tomasa.com)
├── workers/          # Backend API (Cloudflare Workers)
├── docs/             # Documentação
└── scripts/          # Scripts utilitários
```

## Próximos Passos

Após configurar o Cloudflare, siga as tasks em ordem:
- ✅ Task 1: Monorepo Setup
- ✅ Task 2: Cloudflare Configuration
- ⏳ Task 3: D1 Database Provisioning
- ⏳ Task 4-6: D1 Schema Creation
- ⏳ Task 7-8: R2 Bucket Setup
- ⏳ Task 9: Workers Configuration
- ⏳ Task 10-11: Pages Deployment
- ⏳ Task 12-15: DNS Configuration

## Troubleshooting

Consulte [CLOUDFLARE_SETUP.md](./CLOUDFLARE_SETUP.md) para resolver problemas comuns.
