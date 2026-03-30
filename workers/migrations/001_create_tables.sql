-- Migration 001: Create all tables for TOMASA e-commerce
-- Created: 2026-03-30
-- Description: Initial schema with products, portfolio, and videos tables

-- ============================================================================
-- TABLE: products
-- Description: Catálogo de produtos com preços regionalizados (BR e UY)
-- ============================================================================
CREATE TABLE IF NOT EXISTS products (
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

-- Índices para otimizar queries
CREATE INDEX IF NOT EXISTS idx_products_slug ON products(slug);
CREATE INDEX IF NOT EXISTS idx_products_category ON products(category);
CREATE INDEX IF NOT EXISTS idx_products_featured ON products(featured);
CREATE INDEX IF NOT EXISTS idx_products_active ON products(active);

-- ============================================================================
-- TABLE: portfolio
-- Description: Galeria de peças entregues (showcase)
-- ============================================================================
CREATE TABLE IF NOT EXISTS portfolio (
  id TEXT PRIMARY KEY,
  title TEXT,
  category TEXT,
  image_url TEXT,       -- URL do R2
  delivered_at TEXT,
  created_at TEXT DEFAULT (datetime('now'))
);

-- Índices para otimizar queries
CREATE INDEX IF NOT EXISTS idx_portfolio_category ON portfolio(category);
CREATE INDEX IF NOT EXISTS idx_portfolio_delivered_at ON portfolio(delivered_at);

-- ============================================================================
-- TABLE: videos
-- Description: Vídeos promocionais do YouTube
-- ============================================================================
CREATE TABLE IF NOT EXISTS videos (
  id TEXT PRIMARY KEY,
  title TEXT,
  youtube_url TEXT NOT NULL,
  display_order INTEGER DEFAULT 0
);

-- Índice para ordenação
CREATE INDEX IF NOT EXISTS idx_videos_display_order ON videos(display_order);
