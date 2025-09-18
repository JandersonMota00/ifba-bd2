/* ===========================================================================
   3) Sales Analyst (db_sales_analyst)
   – Leitura de tabelas operacionais para relatórios e insights
   – Nenhum direito de escrita ou exclusão
   =========================================================================== */
-- 1.1 Criar login de servidor
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'salesAnalyst')
  CREATE LOGIN salesAnalyst WITH PASSWORD = 'Sal!3s#2025';
GO

-- 1.2 Criar usuário de banco
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'SalesAnalystUser')
  CREATE USER SalesAnalystUser FOR LOGIN salesAnalyst;
GO

-- 1.3 Criar role de analista
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'db_sales_analyst' AND type = 'R')
  CREATE ROLE db_sales_analyst;
GO

-- 1.4 Associar usuário à role
ALTER ROLE db_sales_analyst ADD MEMBER SalesAnalystUser;
GO

-- 1.5 Conceder SELECT nas tabelas de análise
GRANT SELECT ON dbo.ordens                            TO db_sales_analyst;
GRANT SELECT ON dbo.ordensDePagamento                 TO db_sales_analyst;
GRANT SELECT ON dbo.ordemItem                         TO db_sales_analyst;
GRANT SELECT ON dbo.olist_order_reviews_dataset       TO db_sales_analyst;
GRANT SELECT ON dbo.produtos                          TO db_sales_analyst;
GRANT SELECT ON dbo.vendas                            TO db_sales_analyst;
GRANT SELECT ON dbo.olist_consumo                     TO db_sales_analyst;
GRANT SELECT ON dbo.geolocalizacao                    TO db_sales_analyst;
GRANT SELECT ON dbo.product_category_name_translation TO db_sales_analyst;
GO

-- 1.6 Negar qualquer modificação
DENY INSERT, UPDATE, DELETE ON dbo.ordens                            TO db_sales_analyst;
DENY INSERT, UPDATE, DELETE ON dbo.ordensDePagamento                 TO db_sales_analyst;
DENY INSERT, UPDATE, DELETE ON dbo.ordemItem                         TO db_sales_analyst;
DENY INSERT, UPDATE, DELETE ON dbo.olist_order_reviews_dataset       TO db_sales_analyst;
DENY INSERT, UPDATE, DELETE ON dbo.produtos                          TO db_sales_analyst;
DENY INSERT, UPDATE, DELETE ON dbo.vendas                            TO db_sales_analyst;
DENY INSERT, UPDATE, DELETE ON dbo.olist_consumo                     TO db_sales_analyst;
DENY INSERT, UPDATE, DELETE ON dbo.geolocalizacao                    TO db_sales_analyst;
DENY INSERT, UPDATE, DELETE ON dbo.product_category_name_translation TO db_sales_analyst;
GO
