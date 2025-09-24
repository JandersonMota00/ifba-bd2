USE OlistStore;

-- ============================================================================

-- 1. Trigger para Log de Novos Pedidos
-- Criação da tabela de log para registrar cada pedido novo.
CREATE TABLE Log_NovosPedidos (
    log_id INT IDENTITY PRIMARY KEY,
    order_id NVARCHAR(50),
    customer_id NVARCHAR(50),
    data_insercao DATETIME DEFAULT GETDATE()
);

-- Trigger
INSERT INTO olist_orders_dataset (order_id, customer_id, order_status, order_purchase_timestamp, order_estimated_delivery_date)
VALUES ('PEDIDO_TESTE_1', '000379cdec625522490c315e70c7a9fb', 'created', GETDATE(), DATEADD(DAY, 10, GETDATE()));

SELECT * FROM Log_NovosPedidos;


-- 2. Trigger para Bloquear Exclusão de Pedidos
-- Nenhum pedido poderá ser deletado diretamente.
CREATE TRIGGER trg_BloquearDeletePedido
ON olist_orders_dataset
INSTEAD OF DELETE
AS
BEGIN
    RAISERROR ('Exclusão de pedidos não é permitida!', 16, 1);
END;

-- Trigger
DELETE FROM olist_orders_dataset WHERE order_id = 'PEDIDO_TESTE_1';
-- Vai gerar erro e impedir exclusão


-- 3. Trigger para Log de Mudança no Status do Pedido
-- Criaremos uma tabela de log:
CREATE TABLE Log_StatusPedido (
    log_id INT IDENTITY PRIMARY KEY,
    order_id NVARCHAR(50),
    status_antigo NVARCHAR(50),
    status_novo NVARCHAR(50),
    data_alteracao DATETIME DEFAULT GETDATE()
);

-- Trigger
CREATE TRIGGER trg_LogAlteracaoStatus
ON olist_orders_dataset
AFTER UPDATE
AS
BEGIN
    INSERT INTO Log_StatusPedido (order_id, status_antigo, status_novo)
    SELECT d.order_id, d.order_status, i.order_status
    FROM DELETED d
    JOIN INSERTED i ON d.order_id = i.order_id
    WHERE d.order_status <> i.order_status;
END;

-- Teste
UPDATE olist_orders_dataset
SET order_status = 'shipped'
WHERE order_id = 'PEDIDO_TESTE_1';

SELECT * FROM Log_StatusPedido;


-- 4. Trigger para Garantir que a Data de Entrega Não Seja Antes da Data de Compra
CREATE TRIGGER trg_ValidarDataEntrega
ON olist_orders_dataset
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM INSERTED
        WHERE order_delivered_customer_date < order_purchase_timestamp
    )
    BEGIN
        RAISERROR ('A data de entrega não pode ser antes da data de compra!', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
