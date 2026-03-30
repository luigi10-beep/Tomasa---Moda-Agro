# Implementation Plan: FASE 1 — Infraestrutura

## Overview

Configuração completa da infraestrutura Cloudflare para TOMASA, incluindo monorepo, D1, R2, Workers, Pages e DNS. Cada tarefa é independente e testável, seguindo ordem lógica de setup.

## Tasks

- [x] 1. Monorepo Setup com Turborepo e pnpm
  - Criar estrutura: apps/web, apps/admin, workers
  - Configurar pnpm-workspace.yaml com workspace
  - Criar turbo.json com build pipeline
  - Instalar dependências base (Next.js 14, Wrangler)
  - _Requirements: 1.1-1.10_

- [x] 2. Cloudflare Account Configuration
  - Criar API token com permissões D1, R2, Workers, Pages
  - Configurar CLOUDFLARE_ACCOUNT_ID e CLOUDFLARE_API_TOKEN em .env.local
  - Validar acesso via wrangler login
  - _Requirements: 2.1-2.4_

- [ ] 3. D1 Database Provisioning
  - Criar banco D1 nomeado tomasa-db via wrangler
  - Configurar DATABASE_URL em .env.local
  - Adicionar binding db_binding em wrangler.toml
  - Validar conexão com query de teste
  - _Requirements: 3.1-3.5_

- [ ] 4. D1 Schema — Products Table
  - Executar migration para criar tabela products
  - Colunas: id, name, slug, description, price_brl, price_uyu, category, sizes, images, featured, active, created_at
  - Validar schema com query SELECT * FROM products LIMIT 0
  - _Requirements: 4.1-4.7_

- [ ] 5. D1 Schema — Portfolio Table
  - Executar migration para criar tabela portfolio
  - Colunas: id, title, category, image_url, delivered_at, created_at
  - Validar schema com query SELECT * FROM portfolio LIMIT 0
  - _Requirements: 5.1-5.4_

- [ ] 6. D1 Schema — Videos Table
  - Executar migration para criar tabela videos
  - Colunas: id, title, youtube_url, display_order
  - Validar schema com query SELECT * FROM videos LIMIT 0
  - _Requirements: 6.1-6.4_

- [ ] 7. R2 Bucket Provisioning
  - Criar bucket R2 nomeado tomasa-media via wrangler
  - Configurar acesso público para CDN
  - Adicionar binding r2_binding em wrangler.toml
  - Configurar R2_BUCKET_NAME e R2_PUBLIC_URL em .env.local
  - _Requirements: 7.1-7.6_

- [ ] 8. R2 Storage Structure & Signed URL Configuration
  - Criar estrutura de pastas: products/{product-id}/, portfolio/{portfolio-id}/
  - Implementar função de upload com WebP conversion
  - Implementar geração de signed URLs com 1h expiration
  - Testar upload e acesso via https://media.tomasa.com
  - _Requirements: 8.1-8.6_

- [ ] 9. Cloudflare Workers Project Setup
  - Inicializar projeto Workers em workers/
  - Configurar wrangler.toml com D1 e R2 bindings
  - Criar handler básico para testar bindings
  - Validar acesso a env.db_binding e env.r2_binding
  - _Requirements: 9.1-9.7_

- [ ] 10. Cloudflare Pages — Public Site (apps/web)
  - Conectar apps/web ao Pages como projeto tomasa-web
  - Configurar build command: npm run build
  - Configurar output directory: apps/web/.next
  - Adicionar environment variables para Workers API
  - _Requirements: 10.1-10.6_

- [ ] 11. Cloudflare Pages — Admin Panel (apps/admin)
  - Conectar apps/admin ao Pages como projeto tomasa-admin
  - Configurar build command: npm run build
  - Configurar output directory: apps/admin/.next
  - Adicionar environment variables para Workers API
  - _Requirements: 11.1-11.6_

- [ ] 12. DNS Configuration — Root Domain
  - Configurar tomasa.com para apontar a tomasa-web Pages
  - Validar resolução DNS
  - Testar acesso a tomasa.com
  - _Requirements: 12.1-12.3_

- [ ] 13. DNS Configuration — Brazil Subdomain
  - Configurar br.tomasa.com para apontar a tomasa-web Pages
  - Validar resolução DNS
  - Testar acesso a br.tomasa.com
  - _Requirements: 13.1-13.3_

- [ ] 14. DNS Configuration — Uruguay Subdomain
  - Configurar uy.tomasa.com para apontar a tomasa-web Pages
  - Validar resolução DNS
  - Testar acesso a uy.tomasa.com
  - _Requirements: 14.1-14.3_

- [ ] 15. DNS Configuration — Admin Subdomain
  - Configurar admin.tomasa.com para apontar a tomasa-admin Pages
  - Validar resolução DNS
  - Testar acesso a admin.tomasa.com
  - _Requirements: 15.1-15.3_

- [ ] 16. Environment Variables — Development
  - Criar .env.local com: REGION, CLOUDFLARE_ACCOUNT_ID, CLOUDFLARE_API_TOKEN
  - Adicionar: R2_BUCKET_NAME, R2_PUBLIC_URL
  - Adicionar: RESEND_API_KEY, RESEND_FROM, RESEND_TO
  - Adicionar: DATABASE_URL
  - Validar carregamento de variáveis
  - _Requirements: 16.1-16.5_

- [ ] 17. Environment Variables — Production
  - Configurar em Cloudflare: STRIPE_SECRET_KEY, STRIPE_WEBHOOK_SECRET
  - Configurar: MERCADOPAGO_ACCESS_TOKEN, MERCADOPAGO_WEBHOOK_SECRET
  - Configurar: AIRTABLE_API_KEY, AIRTABLE_BASE_ID, AIRTABLE_TABLE_NAME
  - Configurar: NEXTAUTH_SECRET, NEXTAUTH_URL
  - Validar acesso em Pages e Workers
  - _Requirements: 17.1-17.5_

- [ ] 18. Infrastructure Verification & Integration Testing
  - Executar build completo: pnpm run build
  - Testar query D1 via Workers: SELECT COUNT(*) FROM products
  - Testar upload R2 via Workers signed URL
  - Testar deploy Workers e validar HTTP responses
  - Testar deploy Pages (web + admin) em todos os domínios
  - Testar CORS entre Pages e Workers API
  - _Requirements: 18.1-18.6_

## Notes

- Cada tarefa é independente e pode ser executada sequencialmente
- Validações incluídas em cada tarefa para garantir funcionamento
- Ordem segue lógica: setup → cloud resources → bindings → deployment → DNS → env vars → verificação
- Todas as tarefas focam em execução real e testável
