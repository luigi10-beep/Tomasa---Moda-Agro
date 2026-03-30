-- Migration 002: Seed test data (opcional)
-- Created: 2026-03-30
-- Description: Dados de teste para desenvolvimento

-- ============================================================================
-- TEST DATA: products
-- ============================================================================
INSERT INTO products (id, name, slug, description, price_brl, price_uyu, category, sizes, images, featured, active) VALUES
('prod-001', 'Camisa Campo Bordada', 'camisa-campo-bordada', 'Camisa de algodão com bordado artesanal', 290.00, 1450.00, 'Camisas', '["P","M","G","GG"]', '[]', 1, 1),
('prod-002', 'Chapéu Tradicional', 'chapeu-tradicional', 'Chapéu de couro legítimo', 180.00, 900.00, 'Acessórios', '["Único"]', '[]', 1, 1),
('prod-003', 'Bota Campeira', 'bota-campeira', 'Bota de couro para trabalho no campo', 450.00, 2250.00, 'Calçados', '["38","39","40","41","42","43","44"]', '[]', 0, 1);

-- ============================================================================
-- TEST DATA: portfolio
-- ============================================================================
INSERT INTO portfolio (id, title, category, image_url, delivered_at) VALUES
('port-001', 'Conjunto Festa Junina', 'Festas', '', '2026-06-15'),
('port-002', 'Uniforme Fazenda Santa Rita', 'Corporativo', '', '2026-02-20'),
('port-003', 'Traje Rodeio Profissional', 'Esportivo', '', '2026-01-10');

-- ============================================================================
-- TEST DATA: videos
-- ============================================================================
INSERT INTO videos (id, title, youtube_url, display_order) VALUES
('vid-001', 'Coleção Primavera 2026', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 1),
('vid-002', 'Making Of - Bordados Artesanais', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 2),
('vid-003', 'Depoimentos de Clientes', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 3);
