# TOMASA E-commerce Platform

Multi-regional e-commerce platform for agricultural fashion, operating in Brazil and Uruguay.

## Architecture

- **apps/web**: Public frontend (Next.js 14) - br.tomasa.com, uy.tomasa.com
- **apps/admin**: Admin panel (Next.js 14) - admin.tomasa.com
- **workers**: Backend API (Cloudflare Workers)

## Tech Stack

- **Frontend**: Next.js 14, Tailwind CSS, Framer Motion, next-intl
- **Backend**: Cloudflare Workers
- **Database**: Cloudflare D1 (SQLite)
- **Storage**: Cloudflare R2
- **Payments**: Stripe (Brazil), MercadoPago (Uruguay)
- **Email**: Resend
- **Orders**: Airtable

## Getting Started

### Prerequisites

- Node.js >= 18.0.0
- pnpm >= 8.0.0
- Cloudflare Account (free tier works)

### Installation

```bash
# Install dependencies
pnpm install
```

### Cloudflare Configuration

1. Follow the detailed guide: [docs/CLOUDFLARE_SETUP.md](docs/CLOUDFLARE_SETUP.md)
2. Copy `.env.example` to `.env.local` and fill in your credentials
3. Validate configuration:

```bash
# Validate Cloudflare credentials
pnpm validate:cloudflare
```

See [docs/QUICK_START.md](docs/QUICK_START.md) for complete setup instructions.

### Development

```bash
# Run public site (port 3000)
cd apps/web && pnpm dev

# Run admin panel (port 3001)
cd apps/admin && pnpm dev

# Run workers locally
cd workers && pnpm dev
```

## Project Structure

```
tomasa-monorepo/
├── apps/
│   ├── web/          # Public frontend
│   └── admin/        # Admin panel
├── workers/          # Backend API
├── docs/             # Documentation
├── package.json      # Root package
├── pnpm-workspace.yaml
└── turbo.json        # Turborepo config
```

## License

Private - All rights reserved
