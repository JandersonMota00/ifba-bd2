
/* ===========================================================================
   2) Logistics Operator (db_logistics_operator)
   – Leitura de pedidos
   – UPDATE nos campos de despacho e entrega em dbo.ordens
   – Sem acesso a tabelas de pagamento ou reviews
   =========================================================================== */
-- 2.1 Criar login de servidor
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'logisticsOperator')
  CREATE LOGIN logisticsOperator WITH PASSWORD = 'Log!st!cs#2025';
GO

-- 2.2 Criar usuário de banco
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'LogisticsOperatorUser')
  CREATE USER LogisticsOperatorUser FOR LOGIN logisticsOperator;
GO

-- 2.3 Criar role de logística
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'db_logistics_operator' AND type = 'R')
  CREATE ROLE db_logistics_operator;
GO

-- 2.4 Associar usuário à role
ALTER ROLE db_logistics_operator ADD MEMBER LogisticsOperatorUser;
GO

-- 2.5 Permissões de leitura
GRANT SELECT ON dbo.olist_orders_dataset      TO db_logistics_operator;
GRANT SELECT ON dbo.olist_order_items_dataset TO db_logistics_operator;
GRANT SELECT ON dbo.olist_products_dataset    TO db_logistics_operator;

-- 2.6 Permissões de atualização apenas em campos de entrega
GRANT UPDATE (order_delivered_carrier_date, order_delivered_customer_date)
  ON dbo.olist_orders_dataset TO db_logistics_operator;
GO

-- 2.7 Negar acesso a tabelas sensíveis
DENY SELECT, INSERT, UPDATE, DELETE ON dbo.olist_order_payments_dataset       TO db_logistics_operator;
DENY SELECT, INSERT, UPDATE, DELETE ON dbo.olist_order_reviews_dataset        TO db_logistics_operator;
DENY SELECT, INSERT, UPDATE, DELETE ON dbo.olist_customers_dataset            TO db_logistics_operator;
DENY SELECT, INSERT, UPDATE, DELETE ON dbo.olist_sellers_dataset              TO db_logistics_operator;
DENY SELECT, INSERT, UPDATE, DELETE ON dbo.olist_geolocation_dataset          TO db_logistics_operator;
DENY SELECT, INSERT, UPDATE, DELETE ON dbo.product_category_name_translation  TO db_logistics_operator;
GO
