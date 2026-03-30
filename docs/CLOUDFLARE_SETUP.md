# Cloudflare Account Configuration

## Passo 1: Obter Account ID

1. Acesse [Cloudflare Dashboard](https://dash.cloudflare.com)
2. Faça login na sua conta
3. No menu lateral, clique em qualquer domínio (ou vá para "Workers & Pages")
4. No lado direito da página, você verá **Account ID**
5. Copie o Account ID

## Passo 2: Criar API Token

1. No Cloudflare Dashboard, clique no ícone do seu perfil (canto superior direito)
2. Clique em **"My Profile"**
3. No menu lateral, clique em **"API Tokens"**
4. Clique no botão **"Create Token"**
5. Clique em **"Get started"** no template **"Custom token"**

### Configuração do Token:

**Token name:** `TOMASA Development`

**Permissions:**
- Account | D1 | Edit
- Account | Workers R2 Storage | Edit
- Account | Workers Scripts | Edit
- Account | Cloudflare Pages | Edit
- Account | Account Settings | Read

**Account Resources:**
- Include | [Sua conta] | All accounts

**Client IP Address Filtering:** (deixe em branco)

**TTL:** Start Date: hoje | End Date: (deixe em branco para não expirar)

6. Clique em **"Continue to summary"**
7. Revise as permissões
8. Clique em **"Create Token"**
9. **IMPORTANTE:** Copie o token imediatamente (ele só será mostrado uma vez)

## Passo 3: Configurar .env.local

Abra o arquivo `.env.local` na raiz do projeto e preencha:

```bash
CLOUDFLARE_ACCOUNT_ID=seu-account-id-aqui
CLOUDFLARE_API_TOKEN=seu-api-token-aqui
```

## Passo 4: Validar Configuração

Execute no terminal:

```bash
# Instalar dependências (se ainda não instalou)
pnpm install

# Validar credenciais Cloudflare
cd workers
pnpm wrangler whoami
```

**Resultado esperado:**
```
 ⛅️ wrangler 3.x.x
-------------------
Getting User settings...
👋 You are logged in with an API Token, associated with the email '[seu-email]'!
┌──────────────────────────┬──────────────────────────────────┐
│ Account Name             │ Account ID                        │
├──────────────────────────┼──────────────────────────────────┤
│ [Nome da sua conta]      │ [seu-account-id]                  │
└──────────────────────────┴──────────────────────────────────┘
```

## Troubleshooting

### Erro: "Authentication error"
- Verifique se o API Token foi copiado corretamente
- Certifique-se de que o token tem as permissões corretas
- Tente criar um novo token

### Erro: "Account ID not found"
- Verifique se o Account ID está correto
- Certifique-se de que não há espaços extras

### Erro: "wrangler: command not found"
- Execute `pnpm install` na raiz do projeto
- Ou execute `cd workers && pnpm install`

## Próximos Passos

Após validar as credenciais, você pode prosseguir para:
- Task 3: D1 Database Provisioning
- Task 7: R2 Bucket Provisioning
- Task 9: Workers Project Setup
