USE [TrabalhoBD2]
GO

CREATE TABLE [dbo].[product_category_name_translation](
	[column1] [nvarchar](50) NOT NULL,
	[column2] [nvarchar](50) NOT NULL
) ON [PRIMARY]
GO

BULK INSERT dbo.product_category_name_translation
FROM './datasheet/product_category_name_translation.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    KEEPNULLS,
    DATAFILETYPE = 'char',
    CODEPAGE = '65001',
    MAXERRORS = 1,
    BATCHSIZE = 1000
);
GO
