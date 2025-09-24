-- Carga das Dimensões
-- DimTempo
INSERT INTO DimTempo (Data, Ano, Mes, Dia)
SELECT DISTINCT
    CAST(order_purchase_timestamp AS DATE),
    YEAR(order_purchase_timestamp),
    MONTH(order_purchase_timestamp),
    DAY(order_purchase_timestamp)
FROM dbo.olist_orders_dataset;

-- DimCliente
INSERT INTO DimCliente (CustomerUniqueId, Estado, Cidade)
SELECT DISTINCT
    customer_unique_id,
    customer_state,
    customer_city
FROM dbo.olist_customers_dataset;

-- DimProduto
INSERT INTO DimProduto (ProductID, Categoria, Preco)
SELECT DISTINCT
    p.product_id,
    p.product_category_name,
    oi.price
FROM dbo.olist_products_dataset p
JOIN dbo.olist_order_items_dataset oi
    ON p.product_id = oi.product_id;

-- DimVendedor
INSERT INTO DimVendedor (SellerID, Estado, Cidade)
SELECT DISTINCT
    s.seller_id,
    s.seller_state,
    s.seller_city
FROM dbo.olist_sellers_dataset s;

-- DimPagamento
INSERT INTO DimPagamento (TipoPagamento, Parcelas)
SELECT DISTINCT
    payment_type,
    payment_installments
FROM dbo.olist_order_payments_dataset;


-- Carga da FatoVendas
INSERT INTO FatoVendas (
    IdTempo, IdCliente, IdProduto, IdVendedor, IdPagamento, Quantidade, ValorTotal
)
SELECT
    t.IdTempo,
    c.IdCliente,
    p.IdProduto,
    v.IdVendedor,
    pg.IdPagamento,
    oi.order_item_id,
    (oi.price + oi.freight_value) AS ValorTotal
FROM dbo.olist_orders_dataset o
JOIN dbo.olist_order_items_dataset oi ON o.order_id = oi.order_id
JOIN DimTempo t ON CAST(o.order_purchase_timestamp AS DATE) = t.Data
JOIN dbo.olist_customers_dataset oc ON o.customer_id = oc.customer_id
JOIN DimCliente c ON oc.customer_unique_id = c.CustomerUniqueId
JOIN dbo.olist_products_dataset pr ON oi.product_id = pr.product_id
JOIN DimProduto p ON pr.product_id = p.ProductID
JOIN dbo.olist_sellers_dataset s ON oi.seller_id = s.seller_id
JOIN DimVendedor v ON s.seller_id = v.SellerID
JOIN dbo.olist_order_payments_dataset op ON o.order_id = op.order_id
JOIN DimPagamento pg ON op.payment_type = pg.TipoPagamento
                     AND op.payment_installments = pg.Parcelas;
