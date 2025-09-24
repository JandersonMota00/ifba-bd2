-- ========================================
-- Triggers for dbo.olist_customers_dataset
-- ========================================

CREATE OR ALTER TRIGGER dbo.tr_Olist_Customers_Insert
ON dbo.olist_customers_dataset
AFTER INSERT
AS
BEGIN
  SET NOCOUNT ON;

  INSERT INTO audit.ChangeLog
    (TableName, Operation, PrimaryKeyValue, ColumnName,
     OldValue, NewValue, ChangedBy, ChangedAt)
  SELECT
    'olist_customers_dataset',
    'I',
    i.customer_id,
    'ALL',
    NULL,
    CONCAT(
      'unique_id=',            i.customer_unique_id,           '; ',
      'zip=',                  FORMAT(i.customer_zip_code_prefix,'N0'), '; ',
      'city=',                 i.customer_city,                '; ',
      'state=',                i.customer_state
    ),
    SUSER_SNAME(),
    SYSUTCDATETIME()
  FROM inserted AS i;
END;
GO

CREATE OR ALTER TRIGGER dbo.tr_Olist_Customers_Update
ON dbo.olist_customers_dataset
AFTER UPDATE
AS
BEGIN
  SET NOCOUNT ON;

  INSERT INTO audit.ChangeLog
    (TableName, Operation, PrimaryKeyValue, ColumnName,
     OldValue, NewValue, ChangedBy, ChangedAt)
  SELECT
    'olist_customers_dataset',
    'U',
    i.customer_id,
    v.ColumnName,
    v.OldValue,
    v.NewValue,
    SUSER_SNAME(),
    SYSUTCDATETIME()
  FROM inserted AS i
  JOIN deleted AS d
    ON i.customer_id = d.customer_id
  CROSS APPLY (VALUES
    ('customer_unique_id',
       d.customer_unique_id,
       i.customer_unique_id),
    ('customer_zip_code_prefix',
       CONVERT(NVARCHAR(10), d.customer_zip_code_prefix),
       CONVERT(NVARCHAR(10), i.customer_zip_code_prefix)),
    ('customer_city',
       d.customer_city,
       i.customer_city),
    ('customer_state',
       d.customer_state,
       i.customer_state)
  ) AS v(ColumnName, OldValue, NewValue)
  WHERE v.OldValue IS DISTINCT FROM v.NewValue;
END;
GO

CREATE OR ALTER TRIGGER dbo.tr_Olist_Customers_Delete
ON dbo.olist_customers_dataset
AFTER DELETE
AS
BEGIN
  SET NOCOUNT ON;

  INSERT INTO audit.ChangeLog
    (TableName, Operation, PrimaryKeyValue, ColumnName,
     OldValue, NewValue, ChangedBy, ChangedAt)
  SELECT
    'olist_customers_dataset',
    'D',
    d.customer_id,
    'ALL',
    CONCAT(
      'unique_id=',            d.customer_unique_id,           '; ',
      'zip=',                  FORMAT(d.customer_zip_code_prefix,'N0'), '; ',
      'city=',                 d.customer_city,                '; ',
      'state=',                d.customer_state
    ),
    NULL,
    SUSER_SNAME(),
    SYSUTCDATETIME()
  FROM deleted AS d;
END;
GO
