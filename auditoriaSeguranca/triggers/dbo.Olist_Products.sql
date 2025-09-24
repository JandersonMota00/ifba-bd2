-- ========================================
-- Triggers for dbo.olist_products_dataset
-- ========================================

CREATE OR ALTER TRIGGER dbo.tr_Olist_Products_Insert
ON dbo.olist_products_dataset
AFTER INSERT
AS
BEGIN
  SET NOCOUNT ON;

  INSERT INTO audit.ChangeLog
    (TableName, Operation, PrimaryKeyValue, ColumnName,
     OldValue, NewValue, ChangedBy, ChangedAt)
  SELECT
    'olist_products_dataset',
    'I',
    i.product_id,
    'ALL',
    NULL,
    CONCAT(
      'category=',           i.product_category_name,      '; ',
      'name_length=',        i.product_name_lenght,        '; ',
      'desc_length=',        i.product_description_lenght, '; ',
      'photos_qty=',         i.product_photos_qty,         '; ',
      'weight_g=',           FORMAT(i.product_weight_g,'N2'), '; ',
      'dimensions=', 
        FORMAT(i.product_length_cm,'N2'),'x',
        FORMAT(i.product_height_cm,'N2'),'x',
        FORMAT(i.product_width_cm,'N2')
    ),
    SUSER_SNAME(),
    SYSUTCDATETIME()
  FROM inserted AS i;
END;
GO

CREATE OR ALTER TRIGGER dbo.tr_Olist_Products_Update
ON dbo.olist_products_dataset
AFTER UPDATE
AS
BEGIN
  SET NOCOUNT ON;

  INSERT INTO audit.ChangeLog
    (TableName, Operation, PrimaryKeyValue, ColumnName,
     OldValue, NewValue, ChangedBy, ChangedAt)
  SELECT
    'olist_products_dataset',
    'U',
    i.product_id,
    v.ColumnName,
    v.OldValue,
    v.NewValue,
    SUSER_SNAME(),
    SYSUTCDATETIME()
  FROM inserted AS i
  JOIN deleted AS d
    ON i.product_id = d.product_id
  CROSS APPLY (VALUES
    ('product_category_name',
       d.product_category_name,
       i.product_category_name),
    ('product_name_lenght',
       CONVERT(NVARCHAR(10), d.product_name_lenght),
       CONVERT(NVARCHAR(10), i.product_name_lenght)),
    ('product_description_lenght',
       CONVERT(NVARCHAR(10), d.product_description_lenght),
       CONVERT(NVARCHAR(10), i.product_description_lenght)),
    ('product_photos_qty',
       CONVERT(NVARCHAR(10), d.product_photos_qty),
       CONVERT(NVARCHAR(10), i.product_photos_qty)),
    ('product_weight_g',
       FORMAT(d.product_weight_g,'N2'),
       FORMAT(i.product_weight_g,'N2')),
    ('product_length_cm',
       FORMAT(d.product_length_cm,'N2'),
       FORMAT(i.product_length_cm,'N2')),
    ('product_height_cm',
       FORMAT(d.product_height_cm,'N2'),
       FORMAT(i.product_height_cm,'N2')),
    ('product_width_cm',
       FORMAT(d.product_width_cm,'N2'),
       FORMAT(i.product_width_cm,'N2'))
  ) AS v(ColumnName, OldValue, NewValue)
  WHERE v.OldValue IS DISTINCT FROM v.NewValue;
END;
GO

CREATE OR ALTER TRIGGER dbo.tr_Olist_Products_Delete
ON dbo.olist_products_dataset
AFTER DELETE
AS
BEGIN
  SET NOCOUNT ON;

  INSERT INTO audit.ChangeLog
    (TableName, Operation, PrimaryKeyValue, ColumnName,
     OldValue, NewValue, ChangedBy, ChangedAt)
  SELECT
    'olist_products_dataset',
    'D',
    d.product_id,
    'ALL',
    CONCAT(
      'category=',           d.product_category_name,      '; ',
      'name_length=',        d.product_name_lenght,        '; ',
      'desc_length=',        d.product_description_lenght, '; ',
      'photos_qty=',         d.product_photos_qty,         '; ',
      'weight_g=',           FORMAT(d.product_weight_g,'N2'), '; ',
      'dimensions=', 
        FORMAT(d.product_length_cm,'N2'),'x',
        FORMAT(d.product_height_cm,'N2'),'x',
        FORMAT(d.product_width_cm,'N2')
    ),
    NULL,
    SUSER_SNAME(),
    SYSUTCDATETIME()
  FROM deleted AS d;
END;
GO
