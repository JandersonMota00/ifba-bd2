
-- ========================================
-- Triggers for dbo.produtos
-- ========================================

CREATE OR ALTER TRIGGER dbo.tr_Produtos_Insert
ON dbo.produtos
AFTER INSERT
AS
BEGIN
  SET NOCOUNT ON;

  INSERT INTO audit.ChangeLog
    (TableName, Operation, PrimaryKeyValue, ColumnName,
     OldValue, NewValue, ChangedBy, ChangedAt)
  SELECT
    'produtos',
    'I',
    i.product_id,
    'ALL',
    NULL,
    CONCAT(
      'category=',           i.product_category_name,      '; ',
      'name_length=',        i.product_name_length,        '; ',
      'desc_length=',        i.product_description_length, '; ',
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

CREATE OR ALTER TRIGGER dbo.tr_Produtos_Update
ON dbo.produtos
AFTER UPDATE
AS
BEGIN
  SET NOCOUNT ON;

  INSERT INTO audit.ChangeLog
    (TableName, Operation, PrimaryKeyValue, ColumnName,
     OldValue, NewValue, ChangedBy, ChangedAt)
  SELECT
    'produtos',
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
    ('product_name_length',
       CONVERT(NVARCHAR(10), d.product_name_length),
       CONVERT(NVARCHAR(10), i.product_name_length)),
    ('product_description_length',
       CONVERT(NVARCHAR(10), d.product_description_length),
       CONVERT(NVARCHAR(10), i.product_description_length)),
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

CREATE OR ALTER TRIGGER dbo.tr_Produtos_Delete
ON dbo.produtos
AFTER DELETE
AS
BEGIN
  SET NOCOUNT ON;

  INSERT INTO audit.ChangeLog
    (TableName, Operation, PrimaryKeyValue, ColumnName,
     OldValue, NewValue, ChangedBy, ChangedAt)
  SELECT
    'produtos',
    'D',
    d.product_id,
    'ALL',
    CONCAT(
      'category=',           d.product_category_name,      '; ',
      'name_length=',        d.product_name_length,        '; ',
      'desc_length=',        d.product_description_length, '; ',
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