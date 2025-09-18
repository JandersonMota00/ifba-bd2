-- ========================================
-- Triggers for dbo.ordens
-- ========================================

CREATE OR ALTER TRIGGER dbo.tr_Ordens_Insert
ON dbo.ordens
AFTER INSERT
AS
BEGIN
  SET NOCOUNT ON;

  INSERT INTO audit.ChangeLog
    (TableName, Operation, PrimaryKeyValue, ColumnName,
     OldValue, NewValue, ChangedBy, ChangedAt)
  SELECT
    'ordens',
    'I',
    i.order_id,
    'ALL',
    NULL,
    CONCAT(
      'customer=',               i.customer_id,                        '; ',
      'status=',                 i.order_status,                       '; ',
      'purchase_ts=',            FORMAT(i.order_purchase_timestamp,'yyyy-MM-dd HH:mm:ss'), '; ',
      'approved_at=',            FORMAT(i.order_approved_at,'yyyy-MM-dd HH:mm:ss'),          '; ',
      'delivered_carrier=',      FORMAT(i.order_delivered_carrier_date,'yyyy-MM-dd HH:mm:ss'), '; ',
      'delivered_customer=',     FORMAT(i.order_delivered_customer_date,'yyyy-MM-dd HH:mm:ss'), '; ',
      'estimated_delivery=',     FORMAT(i.order_estimated_delivery_date,'yyyy-MM-dd HH:mm:ss')
    ),
    SUSER_SNAME(),
    SYSUTCDATETIME()
  FROM inserted AS i;
END;
GO

CREATE OR ALTER TRIGGER dbo.tr_Ordens_Update
ON dbo.ordens
AFTER UPDATE
AS
BEGIN
  SET NOCOUNT ON;

  INSERT INTO audit.ChangeLog
    (TableName, Operation, PrimaryKeyValue, ColumnName,
     OldValue, NewValue, ChangedBy, ChangedAt)
  SELECT
    'ordens',
    'U',
    i.order_id,
    v.ColumnName,
    v.OldValue,
    v.NewValue,
    SUSER_SNAME(),
    SYSUTCDATETIME()
  FROM inserted AS i
  JOIN deleted AS d
    ON i.order_id = d.order_id
  CROSS APPLY (VALUES
    ('customer_id',
       d.customer_id,        i.customer_id),
    ('order_status',
       d.order_status,       i.order_status),
    ('order_purchase_timestamp',
       FORMAT(d.order_purchase_timestamp,'yyyy-MM-dd HH:mm:ss'),
       FORMAT(i.order_purchase_timestamp,'yyyy-MM-dd HH:mm:ss')),
    ('order_approved_at',
       FORMAT(d.order_approved_at,'yyyy-MM-dd HH:mm:ss'),
       FORMAT(i.order_approved_at,'yyyy-MM-dd HH:mm:ss')),
    ('order_delivered_carrier_date',
       FORMAT(d.order_delivered_carrier_date,'yyyy-MM-dd HH:mm:ss'),
       FORMAT(i.order_delivered_carrier_date,'yyyy-MM-dd HH:mm:ss')),
    ('order_delivered_customer_date',
       FORMAT(d.order_delivered_customer_date,'yyyy-MM-dd HH:mm:ss'),
       FORMAT(i.order_delivered_customer_date,'yyyy-MM-dd HH:mm:ss')),
    ('order_estimated_delivery_date',
       FORMAT(d.order_estimated_delivery_date,'yyyy-MM-dd HH:mm:ss'),
       FORMAT(i.order_estimated_delivery_date,'yyyy-MM-dd HH:mm:ss'))
  ) AS v(ColumnName, OldValue, NewValue)
  WHERE v.OldValue IS DISTINCT FROM v.NewValue;
END;
GO

CREATE OR ALTER TRIGGER dbo.tr_Ordens_Delete
ON dbo.ordens
AFTER DELETE
AS
BEGIN
  SET NOCOUNT ON;

  INSERT INTO audit.ChangeLog
    (TableName, Operation, PrimaryKeyValue, ColumnName,
     OldValue, NewValue, ChangedBy, ChangedAt)
  SELECT
    'ordens',
    'D',
    d.order_id,
    'ALL',
    CONCAT(
      'customer=',               d.customer_id,                        '; ',
      'status=',                 d.order_status,                       '; ',
      'purchase_ts=',            FORMAT(d.order_purchase_timestamp,'yyyy-MM-dd HH:mm:ss'), '; ',
      'approved_at=',            FORMAT(d.order_approved_at,'yyyy-MM-dd HH:mm:ss'),          '; ',
      'delivered_carrier=',      FORMAT(d.order_delivered_carrier_date,'yyyy-MM-dd HH:mm:ss'), '; ',
      'delivered_customer=',     FORMAT(d.order_delivered_customer_date,'yyyy-MM-dd HH:mm:ss'), '; ',
      'estimated_delivery=',     FORMAT(d.order_estimated_delivery_date,'yyyy-MM-dd HH:mm:ss')
    ),
    NULL,
    SUSER_SNAME(),
    SYSUTCDATETIME()
  FROM deleted AS d;
END;
GO|