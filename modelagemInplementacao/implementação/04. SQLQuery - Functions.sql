USE OlistStore;

-- ============================================================================

-- Função que retorna todos os pedidos de um cliente
CREATE FUNCTION fn_PedidosPorCliente (@customer_id VARCHAR(50))
RETURNS TABLE
AS
RETURN
(
    SELECT order_id, order_status, order_purchase_timestamp
    FROM olist_orders_dataset
    WHERE customer_id = @customer_id
);
GO

SELECT * FROM dbo.fn_PedidosPorCliente('000379cdec625522490c315e70c7a9fb');
