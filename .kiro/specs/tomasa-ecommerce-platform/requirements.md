# Requirements Document — FASE 1: Infraestrutura

## Introduction

FASE 1 estabelece a base técnica para a plataforma TOMASA. Compreende a configuração do monorepo, provisionamento de recursos Cloudflare (Pages, D1, R2, Workers), criação de esquema de banco de dados e configuração de subdomínios regionalizados.

## Glossary

- **Monorepo**: Repositório único contendo múltiplos projetos (apps/web, apps/admin, workers)
- **Turborepo**: Ferramenta de build para monorepos que otimiza compilação incremental
- **Cloudflare Pages**: Serviço de hosting para aplicações frontend (Next.js)
- **Cloudflare Workers**: Plataforma serverless para executar código na edge
- **Cloudflare D1**: Banco de dados SQLite gerenciado na edge
- **Cloudflare R2**: Armazenamento de objetos compatível com S3
- **Subdomain**: Domínio secundário (ex: br.tomasa.com, uy.tomasa.com)
- **DNS**: Sistema de nomes de domínio para roteamento de tráfego
- **Schema**: Estrutura de tabelas e campos no banco de dados
- **WebP**: Formato de imagem otimizado para web

## Requirements

### Requirement 1: Monorepo Setup

**User Story**: Como desenvolvedor, quero um monorepo estruturado, para que eu possa gerenciar múltiplos projetos de forma centralizada.

#### Acceptance Criteria

1. THE Monorepo SHALL contain three directories: apps/web, apps/admin, and workers
2. THE apps/web directory SHALL contain the public frontend (Next.js 14 App Router)
3. THE apps/admin directory SHALL contain the admin panel (Next.js 14 App Router)
4. THE workers directory SHALL contain the backend API (Cloudflare Workers)
5. WHEN Turborepo is configured, THE build system SHALL optimize incremental builds across all packages
6. THE package manager SHALL be pnpm with workspace configuration
7. WHEN dependencies are installed, THE pnpm-workspace.yaml file SHALL define workspace structure
8. THE turbo.json file SHALL define build pipeline and task dependencies
9. WHEN apps/web or apps/admin are built, THE system SHALL NOT include backend code
10. WHEN workers are built, THE system SHALL NOT include frontend code

### Requirement 2: Cloudflare Account Configuration

**User Story**: Como operador de infraestrutura, quero configurar a conta Cloudflare, para que eu possa provisionar todos os recursos necessários.

#### Acceptance Criteria

1. THE Cloudflare account SHALL have API token configured with appropriate permissions
2. WHEN the API token is created, THE token SHALL allow creation and management of D1, R2, Workers, and Pages resources
3. THE CLOUDFLARE_ACCOUNT_ID environment variable SHALL be set with the account ID
4. THE CLOUDFLARE_API_TOKEN environment variable SHALL be set with the API token

### Requirement 3: D1 Database Provisioning

**User Story**: Como arquiteto de dados, quero provisionar um banco D1, para que eu possa armazenar dados de produtos, portfólio e vídeos.

#### Acceptance Criteria

1. WHEN the D1 database is created, THE database instance SHALL be named tomasa-db
2. THE database SHALL use SQLite as the underlying engine
3. THE database connection string SHALL be stored in DATABASE_URL environment variable
4. WHEN the database is provisioned, THE system SHALL be able to execute SQL queries against it
5. THE D1 database binding SHALL be configured in wrangler.toml with name db_binding for Workers access

### Requirement 4: D1 Schema Creation — Products Table

**User Story**: Como desenvolvedor backend, quero criar a tabela products, para que eu possa armazenar informações de produtos.

#### Acceptance Criteria

1. WHEN the products table is created, THE table SHALL have columns: id, name, slug, description, price_brl, price_uyu, category, sizes, images, featured, active, created_at
2. THE id column SHALL be TEXT PRIMARY KEY
3. THE slug column SHALL be TEXT UNIQUE NOT NULL
4. THE sizes column SHALL store JSON array as TEXT
5. THE images column SHALL store JSON array of R2 URLs as TEXT
6. THE featured and active columns SHALL be INTEGER with DEFAULT 0
7. THE created_at column SHALL be TEXT with DEFAULT (datetime('now'))

### Requirement 5: D1 Schema Creation — Portfolio Table

**User Story**: Como desenvolvedor backend, quero criar a tabela portfolio, para que eu possa armazenar informações de peças entregues.

#### Acceptance Criteria

1. WHEN the portfolio table is created, THE table SHALL have columns: id, title, category, image_url, delivered_at, created_at
2. THE id column SHALL be TEXT PRIMARY KEY
3. THE image_url column SHALL store R2 URL as TEXT
4. THE created_at column SHALL be TEXT with DEFAULT (datetime('now'))

### Requirement 6: D1 Schema Creation — Videos Table

**User Story**: Como desenvolvedor backend, quero criar a tabela videos, para que eu possa armazenar links de vídeos promocionais.

#### Acceptance Criteria

1. WHEN the videos table is created, THE table SHALL have columns: id, title, youtube_url, display_order
2. THE id column SHALL be TEXT PRIMARY KEY
3. THE youtube_url column SHALL be TEXT NOT NULL
4. THE display_order column SHALL be INTEGER with DEFAULT 0

### Requirement 7: R2 Bucket Provisioning

**User Story**: Como operador de infraestrutura, quero provisionar um bucket R2, para que eu possa armazenar imagens de produtos e portfólio.

#### Acceptance Criteria

1. WHEN the R2 bucket is created, THE bucket SHALL be named tomasa-media
2. THE bucket SHALL be configured with public read access for CDN delivery
3. THE R2_BUCKET_NAME environment variable SHALL be set to tomasa-media
4. THE R2_PUBLIC_URL environment variable SHALL be set to https://media.tomasa.com
5. THE R2 bucket binding SHALL be configured in wrangler.toml with name r2_binding for Workers access
6. WHEN the bucket is provisioned, THE system SHALL be able to upload and retrieve objects via Workers API

### Requirement 8: R2 Storage Structure & Signed URL Configuration

**User Story**: Como desenvolvedor backend, quero definir a estrutura de pastas no R2 e configurar signed URLs, para que eu possa fazer upload seguro de imagens via Workers.

#### Acceptance Criteria

1. THE R2 bucket SHALL have directory structure: products/{product-id}/ and portfolio/{portfolio-id}/
2. WHEN product images are uploaded, THE files SHALL be stored in products/{product-id}/foto-{index}.webp
3. WHEN portfolio images are uploaded, THE files SHALL be stored in portfolio/{portfolio-id}/foto.webp
4. THE image format SHALL be WebP for optimal compression
5. WHEN Workers upload endpoint is called, THE system SHALL generate signed URLs with 1-hour expiration for secure uploads
6. THE signed URL generation SHALL use R2 API credentials from environment variables

### Requirement 9: Cloudflare Workers Project Setup & D1 Integration

**User Story**: Como desenvolvedor backend, quero configurar o projeto Workers com bindings para D1 e R2, para que eu possa executar código serverless com acesso aos recursos.

#### Acceptance Criteria

1. WHEN the Workers project is initialized, THE project SHALL be configured in the workers directory
2. THE wrangler.toml file SHALL define Workers configuration with D1 and R2 bindings
3. THE wrangler.toml SHALL include binding: [[d1_databases]] with name db_binding pointing to tomasa-db
4. THE wrangler.toml SHALL include binding: [[r2_buckets]] with name r2_binding pointing to tomasa-media
5. WHEN Workers code executes, THE system SHALL access D1 via env.db_binding.prepare() for SQL queries
6. WHEN Workers code executes, THE system SHALL access R2 via env.r2_binding for object operations
7. WHEN the Workers are deployed, THE system SHALL respond to HTTP requests with database and storage access

### Requirement 10: Cloudflare Pages Configuration — Public Site (apps/web)

**User Story**: Como operador de infraestrutura, quero configurar Pages para o site público, para que eu possa hospedar a aplicação Next.js separada do backend.

#### Acceptance Criteria

1. WHEN Pages is configured for apps/web, THE project SHALL be named tomasa-web
2. THE build command SHALL be npm run build (executed from monorepo root)
3. THE output directory SHALL be apps/web/.next
4. THE Pages project SHALL be connected to the git repository with root directory set to apps/web
5. WHEN the project is deployed, THE system SHALL serve the Next.js application on tomasa.com, br.tomasa.com, uy.tomasa.com
6. THE Pages project SHALL have environment variables configured to call Workers API endpoints

### Requirement 11: Cloudflare Pages Configuration — Admin Panel (apps/admin)

**User Story**: Como operador de infraestrutura, quero configurar Pages para o painel admin, para que eu possa hospedar a aplicação admin separada do site público.

#### Acceptance Criteria

1. WHEN Pages is configured for apps/admin, THE project SHALL be named tomasa-admin
2. THE build command SHALL be npm run build (executed from monorepo root)
3. THE output directory SHALL be apps/admin/.next
4. THE Pages project SHALL be connected to the git repository with root directory set to apps/admin
5. WHEN the project is deployed, THE system SHALL serve the Next.js application on admin.tomasa.com
6. THE Pages project SHALL have environment variables configured to call Workers API endpoints for admin operations

### Requirement 12: Subdomain Configuration — Country Selector

**User Story**: Como operador de infraestrutura, quero configurar o domínio raiz, para que eu possa servir a página de seleção de país.

#### Acceptance Criteria

1. WHEN DNS is configured, THE tomasa.com domain SHALL route to the Pages project tomasa-web
2. THE root domain SHALL serve the country selector page (/)
3. WHEN a user visits tomasa.com, THE system SHALL display the country selection interface

### Requirement 13: Subdomain Configuration — Brazil Region

**User Story**: Como operador de infraestrutura, quero configurar o subdomínio Brasil, para que eu possa servir o site em português.

#### Acceptance Criteria

1. WHEN DNS is configured, THE br.tomasa.com subdomain SHALL route to the Pages project tomasa-web
2. THE subdomain SHALL serve the Brazil-specific version (PT-BR, BRL, Stripe)
3. WHEN a user visits br.tomasa.com, THE system SHALL display the Portuguese interface

### Requirement 14: Subdomain Configuration — Uruguay Region

**User Story**: Como operador de infraestrutura, quero configurar o subdomínio Uruguai, para que eu possa servir o site em espanhol.

#### Acceptance Criteria

1. WHEN DNS is configured, THE uy.tomasa.com subdomain SHALL route to the Pages project tomasa-web
2. THE subdomain SHALL serve the Uruguay-specific version (ES, UYU, MercadoPago)
3. WHEN a user visits uy.tomasa.com, THE system SHALL display the Spanish interface

### Requirement 15: Subdomain Configuration — Admin Panel

**User Story**: Como operador de infraestrutura, quero configurar o subdomínio admin, para que eu possa servir o painel administrativo.

#### Acceptance Criteria

1. WHEN DNS is configured, THE admin.tomasa.com subdomain SHALL route to the Pages project tomasa-admin
2. THE subdomain SHALL serve the admin panel application
3. WHEN a user visits admin.tomasa.com, THE system SHALL display the admin login interface

### Requirement 16: Environment Variables — Development

**User Story**: Como desenvolvedor, quero ter variáveis de ambiente configuradas, para que eu possa executar a aplicação localmente.

#### Acceptance Criteria

1. THE .env.local file SHALL contain REGION, CLOUDFLARE_ACCOUNT_ID, CLOUDFLARE_API_TOKEN
2. THE .env.local file SHALL contain R2_BUCKET_NAME and R2_PUBLIC_URL
3. THE .env.local file SHALL contain RESEND_API_KEY, RESEND_FROM, RESEND_TO
4. WHEN the application starts, THE system SHALL load all environment variables
5. THE DATABASE_URL environment variable SHALL point to the local D1 database

### Requirement 17: Environment Variables — Production

**User Story**: Como operador de infraestrutura, quero ter variáveis de ambiente de produção, para que eu possa executar a aplicação em produção.

#### Acceptance Criteria

1. THE production environment SHALL have all development variables configured
2. THE production environment SHALL have STRIPE_SECRET_KEY and STRIPE_WEBHOOK_SECRET
3. THE production environment SHALL have MERCADOPAGO_ACCESS_TOKEN and MERCADOPAGO_WEBHOOK_SECRET
4. THE production environment SHALL have AIRTABLE_API_KEY, AIRTABLE_BASE_ID, AIRTABLE_TABLE_NAME
5. THE production environment SHALL have NEXTAUTH_SECRET and NEXTAUTH_URL

### Requirement 18: Infrastructure Verification & Integration Testing

**User Story**: Como operador de infraestrutura, quero verificar que toda a infraestrutura está funcionando, para que eu possa prosseguir para a próxima fase.

#### Acceptance Criteria

1. WHEN the monorepo is built, THE build SHALL complete without errors for all packages (apps/web, apps/admin, workers)
2. WHEN the D1 database is queried via Workers, THE system SHALL return results from all three tables (products, portfolio, videos)
3. WHEN a file is uploaded to R2 via Workers signed URL, THE system SHALL store it and return a public URL accessible via https://media.tomasa.com
4. WHEN the Workers are deployed, THE system SHALL respond to HTTP requests with proper D1 and R2 access
5. WHEN the Pages projects are deployed, THE system SHALL serve apps/web on tomasa.com/br.tomasa.com/uy.tomasa.com and apps/admin on admin.tomasa.com
6. WHEN Pages applications call Workers API, THE system SHALL successfully execute cross-origin requests with proper CORS headers
