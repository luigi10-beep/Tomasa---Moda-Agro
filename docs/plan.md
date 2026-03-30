Planejamento Técnico — TOMASA
 Identidade Visual
Paleta de cores:
#E8F0DC → Verde sage claro (fundo, seções suaves — cor dominante)
#4A6741 → Verde musgo escuro (cor principal — bordas, ícone, botões)
#2C2C2C → Quase preto (tipografia principal)
#FFFFFF → Branco (fundo limpo)
#F7F9F3 → Verde sage ultra claro (fundo de seções alternadas)
#5C7A52 → Verde musgo médio (hover states, detalhes secundários)
Tipografia:
Display / títulos: Cormorant Garamond
Subtítulos cursivos: Dancing Script
Corpo e UI: Jost
Estética geral: Clean, espaçamento generoso, fotografia grande, poucos elementos por
tela.
 Arquitetura Geral
tomasa.com           
br.tomasa.com        
uy.tomasa.com        
admin.tomasa.com     
Responsabilidade
→ Tela de seleção de país
→ Versão Brasil (PT-BR + Stripe)
→ Versão Uruguai (ES + MercadoPago)
→ Painel administrativo
Tecnologia
Site público + Admin
Next.js 14 — Cloudflare Pages
API / Backend
Cloudflare Workers
Banco de dados (produtos, portfólio, vídeos)
Cloudflare D1 (SQLite)
Armazenamento de imagens
Cloudflare R2
Registro de vendas (para envio)
Airtable
Notificação de venda por e-mail
Resend
Pagamento Brasil
Stripe
Pagamento Uruguai
MercadoPago
 BANCO DE DADOS — Cloudflare D1
Tabela products
CREATE TABLE products (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  description TEXT,
  price_brl REAL,
  price_uyu REAL,
  category TEXT,
  sizes TEXT,           -- JSON array ex: ["P","M","G"]
  images TEXT,          -- JSON array de URLs do R2
  featured INTEGER DEFAULT 0,
  active INTEGER DEFAULT 1,
  created_at TEXT DEFAULT (datetime('now'))
);
Tabela portfolio
CREATE TABLE portfolio (
  id TEXT PRIMARY KEY,
  title TEXT,
  category TEXT,
  image_url TEXT,       -- URL do R2
  delivered_at TEXT,
  created_at TEXT DEFAULT (datetime('now'))
);
Tabela videos
CREATE TABLE videos (
  id TEXT PRIMARY KEY,
  title TEXT,
  youtube_url TEXT NOT NULL,
  display_order INTEGER DEFAULT 0
);
 ARMAZENAMENTO — Cloudflare R2
tomasa-media/
├── products/
│   
└── [product-id]/
│       
│       
├── foto-1.webp
└── foto-2.webp
└── portfolio/
└── [portfolio-id]/
└── foto.webp
Upload via Worker com signed URL
Imagens servidas via CDN do Cloudflare
Formato preferido: .webp
 BACKEND — Cloudflare Workers
GET  /api/products              
GET  /api/products/:slug        
GET  /api/portfolio             
GET  /api/videos                
POST /api/checkout              
POST /api/webhooks/stripe       
→ Lista produtos ativos
→ Produto por slug
→ Lista portfólio
→ Lista vídeos (ordenados)
→ Cria sessão de pagamento (Stripe ou MercadoPago)
→ Webhook pós-pagamento BR
POST /api/webhooks/mercadopago  → Webhook pós-pagamento UY
# Rotas Admin (autenticadas)
GET    /api/admin/products
POST   /api/admin/products
PUT    /api/admin/products/:id
DELETE /api/admin/products/:id
GET    /api/admin/portfolio
POST   /api/admin/portfolio
PUT    /api/admin/portfolio/:id
DELETE /api/admin/portfolio/:id
GET    /api/admin/videos
POST   /api/admin/videos
PUT    /api/admin/videos/:id
DELETE /api/admin/videos/:id
POST   /api/admin/upload        
→ Upload de imagem → R2
 FLUXO DE UMA VENDA
1. Cliente preenche checkout (nome, endereço, produto, tamanho)
2. POST /api/checkout → Worker cria sessão no Stripe ou MercadoPago
3. Cliente finaliza pagamento na plataforma
4. Plataforma dispara webhook para /api/webhooks/stripe ou /api/webhooks/mercadopago
5. Worker valida assinatura do webhook
6. Worker salva registro no Airtable (tabela "Pedidos")
7. Worker dispara e-mail via Resend para Silvana
8. Cliente vê tela de confirmação
 AIRTABLE — Exclusivamente para Pedidos
Silvana acessa o Airtable para ver os dados dos compradores e organizar os envios.
Populado automaticamente pelo webhook — zero inserção manual.
Campo
Tipo
Exemplo
Nome
Texto
João Silva
Email
Email
joao@email.com
WhatsApp
Telefone
+55 11 99999-9999
Endereço Texto longo Rua X, 123, Bairro, SP
CEP / CP Texto 01310-100
Produto Texto Camisa Campo Bordada
Tamanho Texto M
Valor Moeda R$ 290,00
País Seleção Brasil / Uruguai
Pagamento Seleção Stripe / MercadoPago
Status Seleção Aguardando envio / Enviado / Entregue
Data Data 29/03/2026
ID Pagamento Texto pi_3Qx…
 FRONTEND — Site Público (apps/web)
Stack: Next.js 14 (App Router) · Tailwind CSS · Framer Motion · next-intl · Cloudflare Pages
Footer (todas as páginas)
Logo da TOMASA
Links de navegação
Endereço: Uruguay 361, Rivera — UY
Telefone: +598 99 190 581
Redes sociais
/ — Seleção de País
Tela fullscreen com logo centralizada
Dois botões: Brasil e Uruguay
Salva preferência em cookie tomasa_region
/home — Página Inicial
Hero com foto grande + tagline + CTA
Destaques do catálogo (produtos com featured = 1 )
Seção de vídeos — 3 cards embed YouTube
Banner chamando para o portfólio
/catalogo — Catálogo
Grid de produtos (2 col mobile / 4 col desktop)
Filtro por categoria
Página de detalhe /catalogo/[slug] : galeria, descrição, tamanhos, botão comprar
/portfolio — Portfólio
Galeria masonry de peças entregues
Sem preço ou botão de compra
/checkout — Checkout
Formulário: nome, e-mail, WhatsApp, endereço, produto, tamanho
Stripe (BR) ou MercadoPago (UY) conforme subdomínio
Página de confirmação pós-pagamento
 PAINEL ADMINISTRATIVO (apps/admin)
Stack: Next.js 14 · NextAuth.js · Tailwind CSS · Shadcn/ui · Cloudflare Pages
( admin.tomasa.com )
/login              
/dashboard          
/produtos           
/produtos/novo      
/produtos/[id]      
/portfolio          
/portfolio/novo     
/videos             
→ Tela de login
→ Resumo de últimas vendas
→ Lista com editar / excluir
→ Formulário + upload de fotos → R2
→ Edição
→ Lista com editar / excluir
→ Upload foto + dados
→ Gerenciar os 3 links do YouTube
 Variáveis de Ambiente
Agora (modo desenvolvimento/testes)
REGION=BR  # ou UY
CLOUDFLARE_ACCOUNT_ID=
CLOUDFLARE_API_TOKEN=
R2_BUCKET_NAME=tomasa-media
R2_PUBLIC_URL=https://media.tomasa.com
RESEND_API_KEY=re_xxxxxxxxxxxx
RESEND_FROM=onboarding@resend.dev
RESEND_TO=email-da-silvana@gmail.com
Depois (quando domínio e pagamentos estiverem prontos)
RESEND_FROM=notificacoes@tomasa.com
RESEND_TO=silvana@tomasa.com
STRIPE_SECRET_KEY=
STRIPE_WEBHOOK_SECRET=
NEXT_PUBLIC_STRIPE_PUBLIC_KEY=
MERCADOPAGO_ACCESS_TOKEN=
MERCADOPAGO_WEBHOOK_SECRET=
AIRTABLE_API_KEY=
AIRTABLE_BASE_ID=
AIRTABLE_TABLE_NAME=Pedidos
 Ordem de Desenvolvimento
Fase 1 — Infraestrutura
1. Setup do monorepo (Turborepo)
2. Configurar Cloudflare Pages, D1, R2 e Workers
3. Criar tabelas no D1 (products, portfolio, videos)
4. Criar bucket no R2
5. Configurar subdomínios no Cloudflare
Fase 2 — Backend (Workers)
6. CRUD de produtos, portfólio e vídeos via D1
7. Upload de imagens para R2 (signed URL)
Fase 3 — Frontend Público
8. Layout base (Navbar, Footer, tema de cores)
9. Tela de seleção de país
10. Home (hero, destaques, vídeos)
11. Catálogo + detalhe do produto
12. Portfólio
13. i18n PT-BR e ES
Fase 4 — Painel Admin
14. Auth com NextAuth
15. CRUD produtos com upload R2
16. CRUD portfólio
17. Gestão de vídeos
Fase 5 — Resend (testes)
18. Configurar Resend com onboarding@resend.dev
19. Testar envio de e-mail de notificação
Fase 6 — Pagamentos + Airtable (após domínio comprado)
20. Comprar domínio e configurar DNS no Cloudflare
21. Configurar domínio próprio no Resend
22. Integrar Stripe (Brasil) + rota de checkout BR
23. Integrar MercadoPago (Uruguai) + rota de checkout UY
24. Webhooks → salvar pedido no Airtable + disparar Resend
25. Configurar tabela “Pedidos” no Airtable
26. Página de checkout no frontend (BR e UY)
Fase 7 — Finalização
27. Testes de ponta a ponta (compra BR e UY)
28. SEO (meta tags, Open Graph, sitemap)
29. Deploy final e DNS
 Flowchart da Arquitetura
flowchart TB
    classDef user fill:#E8F0DC,stroke:#4A6741,color:#2C2C2C,font-weight:bold
    classDef cloudflare fill:#4A6741,stroke:#2C2C2C,color:#fff,font-weight:bold
    classDef external fill:#5C7A52,stroke:#2C2C2C,color:#fff
    classDef db fill:#2C2C2C,stroke:#4A6741,color:#E8F0DC
    classDef payment fill:#7A9B6F,stroke:#2C2C2C,color:#fff
    classDef notify fill:#F7F9F3,stroke:#4A6741,color:#2C2C2C
    %% 
─── ENTRADA ───────────────────────────────────────────
    VISITOR([" Visitante"]):::user
    VISITOR --> GATE
    subgraph GATE[" tomasa.com — Seleção de País"]
        direction LR
        BTN_BR[" Brasil"]:::user
        BTN_UY[" Uruguay"]:::user
    end
    BTN_BR --> BR_SITE
    BTN_UY --> UY_SITE
    %% 
─── SUBDOMÍNIOS ────────────────────────────────────────
    subgraph BR_SITE["br.tomasa.com — PT-BR"]
        direction TB
        BR_HOME[" Home\nDestaques + Vídeos"]:::cloudflare
        BR_CAT[" Catálogo\nGrid + Filtros"]:::cloudflare
        BR_PROD[" Detalhe do Produto\nGaleria + Tamanhos"]:::cloudflare
        BR_PORT[" Portfólio\nGaleria Masonry"]:::cloudflare
        BR_CHECK[" Checkout\nFormulário + Stripe"]:::cloudflare
        BR_HOME --> BR_CAT
        BR_HOME --> BR_PORT
        BR_CAT --> BR_PROD
        BR_PROD --> BR_CHECK
    end
    subgraph UY_SITE["uy.tomasa.com — ES"]
        direction TB
        UY_HOME[" Home\nDestacados + Videos"]:::cloudflare
        UY_CAT[" Catálogo\nGrilla + Filtros"]:::cloudflare
        UY_PROD[" Detalle del Producto\nGalería + Talles"]:::cloudflare
        UY_PORT[" Portafolio\nGalería Masonry"]:::cloudflare
        UY_CHECK[" Checkout\nFormulario + MercadoPago"]:::cloudflare
        UY_HOME --> UY_CAT
        UY_HOME --> UY_PORT
        UY_CAT --> UY_PROD
        UY_PROD --> UY_CHECK
    end
    %% 
─── FOOTER ─────────────────────────────────────────────
    FOOTER[" Footer — todas as páginas\nUruguay 361, Rivera — UY\n+598 99 190 581"]:::notify
    BR_HOME & UY_HOME -.-> FOOTER
    BR_PORT & UY_PORT -.-> FOOTER
    %% 
─── CLOUDFLARE WORKERS API ─────────────────────────────
    subgraph WORKERS[" Cloudflare Workers — API"]
        direction TB
        W_PROD["GET /api/products\nGET /api/products/:slug"]:::cloudflare
        W_PORT["GET /api/portfolio"]:::cloudflare
        W_VID["GET /api/videos"]:::cloudflare
        W_CHECK["POST /api/checkout"]:::cloudflare
        W_WH_STR["POST /api/webhooks/stripe"]:::cloudflare
        W_WH_MP["POST /api/webhooks/mercadopago"]:::cloudflare
        W_UPLOAD["POST /api/admin/upload → R2"]:::cloudflare
        W_ADMIN["CRUD /api/admin/*\n(products, portfolio, videos)"]:::cloudflare
    end
    BR_CAT & UY_CAT --> W_PROD
    BR_PORT & UY_PORT --> W_PORT
    BR_HOME & UY_HOME --> W_VID
    BR_CHECK --> W_CHECK
    UY_CHECK --> W_CHECK
    %% 
─── BANCO DE DADOS D1 ──────────────────────────────────
    subgraph D1[" Cloudflare D1 — SQLite"]
        direction TB
        T_PROD[("products\nid, name, slug\nprice_brl, price_uyu\ncategory, sizes\nimages, featured")]:::db
    end
        T_PORT[("portfolio\nid, title, category\nimage_url, delivered_at")]:::db
        T_VID[("videos\nid, title\nyoutube_url, display_order")]:::db
    W_PROD <--> T_PROD
    W_PORT <--> T_PORT
    W_VID <--> T_VID
    W_ADMIN <--> T_PROD
    W_ADMIN <--> T_PORT
    W_ADMIN <--> T_VID
    %% 
─── R2 STORAGE ─────────────────────────────────────────
    subgraph R2[" Cloudflare R2 — Media"]
        direction LR
        R2_PROD["products/\n[id]/foto.webp"]:::db
        R2_PORT["portfolio/\n[id]/foto.webp"]:::db
    end
    W_UPLOAD --> R2_PROD
    W_UPLOAD --> R2_PORT
    T_PROD -. "image URLs" .-> R2_PROD
    T_PORT -. "image URLs" .-> R2_PORT
    %% 
─── PAGAMENTOS ─────────────────────────────────────────
    subgraph PAYMENTS[" Pagamentos"]
        STRIPE["Stripe\n Brasil\nCartão + PIX"]:::payment
        MP["MercadoPago\n Uruguai\nCartão + Transferência"]:::payment
    end
    W_CHECK -- "REGION=BR" --> STRIPE
    W_CHECK -- "REGION=UY" --> MP
    STRIPE -- "webhook aprovado" --> W_WH_STR
    MP -- "webhook aprovado" --> W_WH_MP
    %% 
─── PÓS-PAGAMENTO ──────────────────────────────────────
    subgraph POST_PAYMENT[" Pós-Pagamento"]
        direction TB
        AIRTABLE[("Airtable — Pedidos\nNome, Email, WhatsApp\nEndereço, CEP\nProduto, Tamanho\nValor, País, Status\nID Pagamento")]:::db
        RESEND["Resend\nNotificação por e-mail\npara Silvana"]:::notify
        CONFIRM[" Tela de\nConfirmação\npara o cliente"]:::user
    end
    W_WH_STR --> AIRTABLE
    W_WH_MP --> AIRTABLE
    W_WH_STR --> RESEND
    W_WH_MP --> RESEND
    W_WH_STR --> CONFIRM
    W_WH_MP --> CONFIRM
    %% 
─── RESEND MODO TESTE ──────────────────────────────────
    RESEND_DEV[" Modo Teste\nonboarding@resend.dev"]:::notify
    RESEND_PROD[" Modo Produção\nnotificacoes@tomasa.com\n(após domínio comprado)"]:::notify
    RESEND --> RESEND_DEV
    RESEND -.-> RESEND_PROD
    %% 
─── SILVANA (DONA DA LOJA) ─────────────────────────────
    SILVANA([" Silvana\nDona da loja"]):::user
    AIRTABLE -- "visualiza pedidos\natualiza status de envio" --> SILVANA
    RESEND_DEV -- "notificação de venda" --> SILVANA
    RESEND_PROD -. "notificação de venda" .-> SILVANA
    %% 
─── PAINEL ADMIN ───────────────────────────────────────
    subgraph ADMIN[" admin.tomasa.com — Painel Admin"]
        direction TB
        A_LOGIN["Login\nNextAuth.js"]:::cloudflare
        A_DASH["Dashboard\nÚltimas vendas"]:::cloudflare
        A_PROD["Produtos\nAdicionar / Editar / Excluir\n+ Upload fotos → R2"]:::cloudflare
        A_PORT["Portfólio\nAdicionar / Editar / Excluir\n+ Upload fotos → R2"]:::cloudflare
        A_VID["Vídeos\nGerenciar 3 links YouTube"]:::cloudflare
        A_LOGIN --> A_DASH
        A_DASH --> A_PROD
        A_DASH --> A_PORT
        A_DASH --> A_VID
    end
    SILVANA --> A_LOGIN
    A_PROD --> W_ADMIN
    A_PORT --> W_ADMIN
    A_VID --> W_ADMIN
    A_PROD --> W_UPLOAD
    A_PORT --> W_UPLOAD
    %% 
─── KIRO STEERING ──────────────────────────────────────
    subgraph KIRO[".kiro/steering/"]
        direction LR
        K1["product.md\n≤20 linhas"]:::notify
        K2["tech.md\n≤20 linhas"]:::notify
        K3["structure.md\n≤20 linhas"]:::notify
    end