-- 1. Faturamento Mensal por Categoria
SELECT 
    t.Ano,
    t.Mes,
    p.Categoria,
    SUM(f.ValorTotal) AS FaturamentoMensal
FROM FatoVendas f
JOIN DimTempo t ON f.IdTempo = t.IdTempo
JOIN DimProduto p ON f.IdProduto = p.IdProduto
GROUP BY t.Ano, t.Mes, p.Categoria
ORDER BY t.Ano, t.Mes, FaturamentoMensal DESC;

-- 2. Tempo Médio de Entrega por Estado
WITH Entregas AS (
    SELECT 
        c.Estado,
        DATEDIFF(DAY, o.order_purchase_timestamp, o.order_delivered_customer_date) AS DiasEntrega
    FROM dbo.olist_orders_dataset o
    JOIN dbo.olist_customers_dataset oc ON o.customer_id = oc.customer_id
    JOIN DimCliente c ON oc.customer_unique_id = c.CustomerUniqueId
    WHERE o.order_delivered_customer_date IS NOT NULL
)
SELECT 
    Estado,
    AVG(DiasEntrega) AS MediaDiasEntrega
FROM Entregas
GROUP BY Estado
ORDER BY MediaDiasEntrega ASC;

-- 3. Top 5 Vendedores por Faturamento Anual
SELECT TOP 5
    v.SellerID,
    t.Ano,
    SUM(f.ValorTotal) AS FaturamentoAnual
FROM FatoVendas f
JOIN DimVendedor v ON f.IdVendedor = v.IdVendedor
JOIN DimTempo t ON f.IdTempo = t.IdTempo
GROUP BY v.SellerID, t.Ano
ORDER BY FaturamentoAnual DESC;
