-- ========================================
-- Triggers for dbo.olist_sellers_dataset
-- ========================================

CREATE OR ALTER TRIGGER dbo.tr_Olist_Sellers_Insert
ON dbo.olist_sellers_dataset
AFTER INSERT
AS
BEGIN
  SET NOCOUNT ON;

  INSERT INTO audit.ChangeLog
    (TableName, Operation, PrimaryKeyValue, ColumnName,
     OldValue, NewValue, ChangedBy, ChangedAt)
  SELECT
    'olist_sellers_dataset',
    'I',
    i.seller_id,
    'ALL',
    NULL,
    CONCAT(
      'zip=',     FORMAT(i.seller_zip_code_prefix,'N0'), '; ',
      'city=',    i.seller_city,                          '; ',
      'state=',   i.seller_state
    ),
    SUSER_SNAME(),
    SYSUTCDATETIME()
  FROM inserted AS i;
END;
GO

CREATE OR ALTER TRIGGER dbo.tr_Olist_Sellers_Update
ON dbo.olist_sellers_dataset
AFTER UPDATE
AS
BEGIN
  SET NOCOUNT ON;

  INSERT INTO audit.ChangeLog
    (TableName, Operation, PrimaryKeyValue, ColumnName,
     OldValue, NewValue, ChangedBy, ChangedAt)
  SELECT
    'olist_sellers_dataset',
    'U',
    i.seller_id,
    v.ColumnName,
    v.OldValue,
    v.NewValue,
    SUSER_SNAME(),
    SYSUTCDATETIME()
  FROM inserted AS i
  JOIN deleted AS d
    ON i.seller_id = d.seller_id
  CROSS APPLY (VALUES
    ('seller_zip_code_prefix',
       CONVERT(NVARCHAR(10), d.seller_zip_code_prefix),
       CONVERT(NVARCHAR(10), i.seller_zip_code_prefix)),
    ('seller_city',
       d.seller_city,
       i.seller_city),
    ('seller_state',
       d.seller_state,
       i.seller_state)
  ) AS v(ColumnName, OldValue, NewValue)
  WHERE v.OldValue IS DISTINCT FROM v.NewValue;
END;
GO

CREATE OR ALTER TRIGGER dbo.tr_Olist_Sellers_Delete
ON dbo.olist_sellers_dataset
AFTER DELETE
AS
BEGIN
  SET NOCOUNT ON;

  INSERT INTO audit.ChangeLog
    (TableName, Operation, PrimaryKeyValue, ColumnName,
     OldValue, NewValue, ChangedBy, ChangedAt)
  SELECT
    'olist_sellers_dataset',
    'D',
    d.seller_id,
    'ALL',
    CONCAT(
      'zip=',     FORMAT(d.seller_zip_code_prefix,'N0'), '; ',
      'city=',    d.seller_city,                          '; ',
      'state=',   d.seller_state
    ),
    NULL,
    SUSER_SNAME(),
    SYSUTCDATETIME()
  FROM deleted AS d;
END;
GO
