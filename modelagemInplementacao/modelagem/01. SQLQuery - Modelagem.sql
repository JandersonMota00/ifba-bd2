CREATE DATABASE teste;

USE OlistStore;

SELECT * FROM olist_orders_dataset;

-- ALTERAR O TYPE DAS TABELAS
-- Garantir que order_id em olist_orders_dataset seja NOT NULL
ALTER TABLE olist_orders_dataset
ALTER COLUMN order_id VARCHAR(50) NOT NULL;

ALTER TABLE olist_orders_dataset
ALTER COLUMN customer_id NVARCHAR(50) NOT NULL;

ALTER TABLE olist_orders_dataset
ALTER COLUMN order_id NVARCHAR(50) NOT NULL;

ALTER TABLE olist_order_items_dataset
ALTER COLUMN order_item_id NVARCHAR(50) NOT NULL;

-- Criar PK
-- encontra os registros inválidos
SELECT r.order_id
FROM olist_order_reviews_dataset r
LEFT JOIN olist_orders_dataset o
    ON r.order_id = o.order_id
WHERE o.order_id IS NULL;

-- script que automaticamente limpe os órfãos e depois crie a FK
-- 1. Remover registros órfãos
DELETE r
FROM olist_order_reviews_dataset r
LEFT JOIN olist_orders_dataset o 
    ON r.order_id = o.order_id
WHERE o.order_id IS NULL;

-- 2. Criar a Foreign Key
ALTER TABLE olist_order_reviews_dataset
ADD CONSTRAINT FK_Orders_Reviews
FOREIGN KEY (order_id)
REFERENCES olist_orders_dataset(order_id);

-- Criar FK ligando
-- Verifica se a constraint já existe
IF NOT EXISTS (
    SELECT 1
    FROM sys.foreign_keys
    WHERE name = 'FK_Orders_Reviews'
)
BEGIN
    ALTER TABLE olist_order_reviews_dataset
    ADD CONSTRAINT FK_Orders_Reviews
    FOREIGN KEY (order_id)
    REFERENCES olist_orders_dataset(order_id);
END


ALTER TABLE olist_order_items_dataset
ADD CONSTRAINT FK_Sellers
FOREIGN KEY (seller_id)
REFERENCES olist_sellers_dataset(seller_id);

ALTER TABLE olist_order_items_dataset
ALTER COLUMN product_id VARCHAR(50) NOT NULL;

-- ==========================================================================

SELECT i.product_id
FROM olist_order_items_dataset i
LEFT JOIN olist_products_dataset p
    ON i.product_id = p.product_id
WHERE p.product_id IS NULL;

-- 1. Criar tabela de backup (se não existir)
IF OBJECT_ID('dbo.olist_order_items_orfaos', 'U') IS NULL
BEGIN
    SELECT i.*
    INTO dbo.olist_order_items_orfaos
    FROM olist_order_items_dataset i
    WHERE 1 = 0; -- cria estrutura sem dados
END

-- 2. Copiar órfãos para o backup
INSERT INTO dbo.olist_order_items_orfaos
SELECT i.*
FROM olist_order_items_dataset i
LEFT JOIN olist_products_dataset p ON i.product_id = p.product_id
WHERE p.product_id IS NULL;

-- 3. Remover órfãos da tabela principal
DELETE i
FROM olist_order_items_dataset i
LEFT JOIN olist_products_dataset p ON i.product_id = p.product_id
WHERE p.product_id IS NULL;

-- 4. Criar FK com segurança
IF NOT EXISTS (
    SELECT 1
    FROM sys.foreign_keys
    WHERE name = 'FK_Product'
)
BEGIN
    ALTER TABLE olist_order_items_dataset
    ADD CONSTRAINT FK_Product
    FOREIGN KEY (product_id)
    REFERENCES olist_products_dataset(product_id);
END

-- ===================================================================

SELECT p.order_id
FROM olist_order_payments_dataset p
LEFT JOIN olist_orders_dataset o
    ON p.order_id = o.order_id
WHERE o.order_id IS NULL;

-- 1. Criar tabela de backup (se ainda não existir)
IF OBJECT_ID('dbo.olist_order_payments_orfaos', 'U') IS NULL
BEGIN
    SELECT p.*
    INTO dbo.olist_order_payments_orfaos
    FROM olist_order_payments_dataset p
    WHERE 1 = 0; -- cria a estrutura sem dados
END

-- 2. Mover registros órfãos para o backup
INSERT INTO dbo.olist_order_payments_orfaos
SELECT p.*
FROM olist_order_payments_dataset p
LEFT JOIN olist_orders_dataset o ON p.order_id = o.order_id
WHERE o.order_id IS NULL;

-- 3. Remover órfãos da tabela principal
DELETE p
FROM olist_order_payments_dataset p
LEFT JOIN olist_orders_dataset o ON p.order_id = o.order_id
WHERE o.order_id IS NULL;

-- 4. Criar FK com segurança (se não existir)
IF NOT EXISTS (
    SELECT 1
    FROM sys.foreign_keys
    WHERE name = 'FK_Payments'
)
BEGIN
    ALTER TABLE olist_order_payments_dataset
    ADD CONSTRAINT FK_Payments
    FOREIGN KEY (order_id)
    REFERENCES olist_orders_dataset(order_id);
END

-- ===================================================================

-- 1. Backup dos pedidos órfãos
IF OBJECT_ID('dbo.olist_orders_orfaos', 'U') IS NULL
BEGIN
    SELECT o.*
    INTO dbo.olist_orders_orfaos
    FROM olist_orders_dataset o
    WHERE 1=0;
END

INSERT INTO dbo.olist_orders_orfaos
SELECT o.*
FROM olist_orders_dataset o
LEFT JOIN olist_customers_dataset c ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- 2. Backup e remoção dos filhos (payments)
IF OBJECT_ID('dbo.olist_order_payments_orfaos', 'U') IS NULL
BEGIN
    SELECT p.* INTO dbo.olist_order_payments_orfaos
    FROM olist_order_payments_dataset p WHERE 1=0;
END

INSERT INTO dbo.olist_order_payments_orfaos
SELECT p.* 
FROM olist_order_payments_dataset p
JOIN olist_orders_orfaos o ON p.order_id = o.order_id;

DELETE p
FROM olist_order_payments_dataset p
JOIN olist_orders_orfaos o ON p.order_id = o.order_id;


-- 2b. Backup e remoção dos filhos (items)
IF OBJECT_ID('dbo.olist_order_items_orfaos', 'U') IS NULL
BEGIN
    SELECT i.* INTO dbo.olist_order_items_orfaos
    FROM olist_order_items_dataset i WHERE 1=0;
END

INSERT INTO dbo.olist_order_items_orfaos
SELECT i.* 
FROM olist_order_items_dataset i
JOIN olist_orders_orfaos o ON i.order_id = o.order_id;

DELETE i
FROM olist_order_items_dataset i
JOIN olist_orders_orfaos o ON i.order_id = o.order_id;

-- 3. Agora sim remover os pedidos órfãos
DELETE o
FROM olist_orders_dataset o
LEFT JOIN olist_customers_dataset c ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- 4. Criar FK Customer
IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Customer'
)
BEGIN
    ALTER TABLE olist_orders_dataset
    ADD CONSTRAINT FK_Customer
    FOREIGN KEY (customer_id)
    REFERENCES olist_customers_dataset(customer_id);
END

-- ===================================================================

-- 1. Criar backup dos itens órfãos
IF OBJECT_ID('dbo.olist_order_items_orfaos2', 'U') IS NULL
BEGIN
    SELECT i.* 
    INTO dbo.olist_order_items_orfaos2
    FROM olist_order_items_dataset i WHERE 1=0;
END

-- 2. Inserir os órfãos no backup
INSERT INTO dbo.olist_order_items_orfaos2
SELECT i.*
FROM olist_order_items_dataset i
LEFT JOIN olist_orders_dataset o ON i.order_id = o.order_id
WHERE o.order_id IS NULL;

-- 3. Remover os órfãos
DELETE i
FROM olist_order_items_dataset i
LEFT JOIN olist_orders_dataset o ON i.order_id = o.order_id
WHERE o.order_id IS NULL;

-- 4. Criar a FK
ALTER TABLE olist_order_items_dataset
ADD CONSTRAINT FK_Order
FOREIGN KEY (order_id)
REFERENCES olist_orders_dataset(order_id);
