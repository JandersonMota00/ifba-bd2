USE OlistStore;

-- ============================================================================

-- Inserir pedido e pagamento juntos: Se o pedido falhar, o pagamento também não entra.
BEGIN TRANSACTION;

BEGIN TRY
    -- Inserindo pedido
    INSERT INTO olist_orders_dataset (
        order_id, customer_id, order_status,
        order_purchase_timestamp, order_estimated_delivery_date
    )
    VALUES (
        'PEDIDO_TX1', '000379cdec625522490c315e70c7a9fb',
        'created', GETDATE(), DATEADD(DAY, 10, GETDATE())
    );

    -- Inserindo pagamento (incluindo installments)
    INSERT INTO olist_order_payments_dataset (
        order_id, payment_sequential, payment_type, payment_installments, payment_value
    )
    VALUES (
        'PEDIDO_TX1', 1, 'credit_card', 1, 250.00
    );

    -- Confirma as duas operações
    COMMIT TRANSACTION;
    PRINT 'Transação concluída com sucesso!';
END TRY
BEGIN CATCH
    -- Se der erro em qualquer uma, desfaz tudo
    ROLLBACK TRANSACTION;
    PRINT 'Erro: ' + ERROR_MESSAGE();
END CATCH;
