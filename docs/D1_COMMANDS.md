# D1 Database - Comandos Rápidos

## Criação e Configuração

```bash
# Criar database
cd workers
pnpm wrangler d1 create tomasa-db

# Listar databases
pnpm wrangler d1 list

# Ver informações do database
pnpm wrangler d1 info tomasa-db
```

## Executar Queries

```bash
# Query simples
pnpm wrangler d1 execute tomasa-db --command "SELECT 1"

# Query com múltiplas linhas
pnpm wrangler d1 execute tomasa-db --command "
  SELECT 
    sqlite_version() as version,
    datetime('now') as current_time
"

# Executar arquivo SQL
pnpm wrangler d1 execute tomasa-db --file=./migrations/001_create_tables.sql

# Executar com output JSON
pnpm wrangler d1 execute tomasa-db --command "SELECT * FROM products" --json
```

## Migrations

```bash
# Criar migration
pnpm wrangler d1 migrations create tomasa-db "create_products_table"

# Listar migrations
pnpm wrangler d1 migrations list tomasa-db

# Aplicar migrations
pnpm wrangler d1 migrations apply tomasa-db

# Aplicar migrations em produção
pnpm wrangler d1 migrations apply tomasa-db --remote
```

## Backup e Restore

```bash
# Exportar database (local)
pnpm wrangler d1 export tomasa-db --output=backup.sql

# Importar database (local)
pnpm wrangler d1 execute tomasa-db --file=backup.sql

# Backup de produção
pnpm wrangler d1 export tomasa-db --remote --output=prod-backup.sql
```

## Desenvolvimento Local

```bash
# Rodar Workers com D1 local
pnpm wrangler dev

# Executar query no D1 local
pnpm wrangler d1 execute tomasa-db --local --command "SELECT * FROM products"
```

## Produção

```bash
# Executar query em produção
pnpm wrangler d1 execute tomasa-db --remote --command "SELECT COUNT(*) FROM products"

# Deploy Workers com D1
pnpm wrangler deploy
```

## Troubleshooting

```bash
# Ver logs do Workers
pnpm wrangler tail

# Ver versão do wrangler
pnpm wrangler --version

# Limpar cache
pnpm wrangler dev --local-protocol=https --persist-to=.wrangler/state
```

## Atalhos no package.json

```bash
# Validar D1
pnpm validate:d1

# Listar databases
pnpm d1:list

# Info do database
pnpm d1:info
```
