# D1 Database Setup Guide

## O que é D1?

D1 é o banco de dados SQLite gerenciado da Cloudflare, executado na edge para baixa latência global.

## Passo 1: Criar D1 Database

Execute no terminal (na raiz do projeto):

```bash
cd workers
pnpm wrangler d1 create tomasa-db
```

**Saída esperada:**
```
✅ Successfully created DB 'tomasa-db'!

[[d1_databases]]
binding = "DB"
database_name = "tomasa-db"
database_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
```

**IMPORTANTE:** Copie o `database_id` gerado (você vai precisar dele no próximo passo).

## Passo 2: Configurar Binding no wrangler.toml

Abra o arquivo `workers/wrangler.toml` e descomente/atualize a seção D1:

```toml
[[d1_databases]]
binding = "db_binding"
database_name = "tomasa-db"
database_id = "SEU-DATABASE-ID-AQUI"  # Cole o ID do passo anterior
```

## Passo 3: Atualizar .env.local

Adicione o database_id ao `.env.local`:

```bash
DATABASE_URL=tomasa-db
D1_DATABASE_ID=seu-database-id-aqui
```

## Passo 4: Validar Conexão

Execute o script de validação:

```bash
# Na raiz do projeto
pnpm validate:d1
```

Ou manualmente:

```bash
cd workers
pnpm wrangler d1 execute tomasa-db --command "SELECT 1 as test"
```

**Saída esperada:**
```
🌀 Executing on tomasa-db (xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx):
┌──────┐
│ test │
├──────┤
│ 1    │
└──────┘
```

## Comandos Úteis

```bash
# Listar todos os databases D1
pnpm wrangler d1 list

# Ver informações do database
pnpm wrangler d1 info tomasa-db

# Executar query SQL
pnpm wrangler d1 execute tomasa-db --command "SELECT sqlite_version()"

# Executar arquivo SQL
pnpm wrangler d1 execute tomasa-db --file=./migrations/001_create_tables.sql
```

## Troubleshooting

### Erro: "You need to log in"
- Execute: `pnpm wrangler login`
- Ou verifique se CLOUDFLARE_API_TOKEN está configurado

### Erro: "Database already exists"
- O database já foi criado anteriormente
- Liste os databases: `pnpm wrangler d1 list`
- Use o database_id existente

### Erro: "Permission denied"
- Verifique se o API Token tem permissão "D1 Edit"
- Recrie o token com as permissões corretas

## Próximos Passos

Após provisionar o D1:
- Task 4: Criar tabela products
- Task 5: Criar tabela portfolio
- Task 6: Criar tabela videos
