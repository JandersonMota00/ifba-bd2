-- ========================================
-- Triggers for dbo.olist_order_payments_dataset
-- ========================================

CREATE OR ALTER TRIGGER dbo.tr_Olist_OrderPayments_Insert
ON dbo.olist_order_payments_dataset
AFTER INSERT
AS
BEGIN
  SET NOCOUNT ON;

  INSERT INTO audit.ChangeLog
    (TableName, Operation, PrimaryKeyValue, ColumnName,
     OldValue, NewValue, ChangedBy, ChangedAt)
  SELECT
    'olist_order_payments_dataset',
    'I',
    CONCAT(i.order_id, '-', i.payment_sequential),
    'ALL',
    NULL,
    CONCAT(
      'seq=',           i.payment_sequential, '; ',
      'type=',          i.payment_type,        '; ',
      'installments=',  i.payment_installments,'; ',
      'value=',         FORMAT(i.payment_value,'N2')
    ),
    SUSER_SNAME(),
    SYSUTCDATETIME()
  FROM inserted AS i;
END;
GO

CREATE OR ALTER TRIGGER dbo.tr_Olist_OrderPayments_Update
ON dbo.olist_order_payments_dataset
AFTER UPDATE
AS
BEGIN
  SET NOCOUNT ON;

  INSERT INTO audit.ChangeLog
    (TableName, Operation, PrimaryKeyValue, ColumnName,
     OldValue, NewValue, ChangedBy, ChangedAt)
  SELECT
    'olist_order_payments_dataset',
    'U',
    CONCAT(i.order_id, '-', i.payment_sequential),
    v.ColumnName,
    v.OldValue,
    v.NewValue,
    SUSER_SNAME(),
    SYSUTCDATETIME()
  FROM inserted AS i
  JOIN deleted AS d
    ON i.order_id = d.order_id
   AND i.payment_sequential = d.payment_sequential
  CROSS APPLY (VALUES
    ('payment_type',
       d.payment_type,       i.payment_type),
    ('payment_installments',
       CONVERT(NVARCHAR(10), d.payment_installments),
       CONVERT(NVARCHAR(10), i.payment_installments)),
    ('payment_value',
       FORMAT(d.payment_value,'N2'),
       FORMAT(i.payment_value,'N2'))
  ) AS v(ColumnName, OldValue, NewValue)
  WHERE v.OldValue IS DISTINCT FROM v.NewValue;
END;
GO

CREATE OR ALTER TRIGGER dbo.tr_Olist_OrderPayments_Delete
ON dbo.olist_order_payments_dataset
AFTER DELETE
AS
BEGIN
  SET NOCOUNT ON;

  INSERT INTO audit.ChangeLog
    (TableName, Operation, PrimaryKeyValue, ColumnName,
     OldValue, NewValue, ChangedBy, ChangedAt)
  SELECT
    'olist_order_payments_dataset',
    'D',
    CONCAT(d.order_id, '-', d.payment_sequential),
    'ALL',
    CONCAT(
      'seq=',          d.payment_sequential, '; ',
      'type=',         d.payment_type,        '; ',
      'installments=', d.payment_installments,'; ',
      'value=',        FORMAT(d.payment_value,'N2')
    ),
    NULL,
    SUSER_SNAME(),
    SYSUTCDATETIME()
  FROM deleted AS d;
END;
GO
