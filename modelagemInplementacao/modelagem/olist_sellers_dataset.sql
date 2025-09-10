USE [TrabalhoBD2]
GO

CREATE TABLE [dbo].[olist_sellers_dataset](
	[seller_id] [nvarchar](50) NOT NULL,
	[seller_zip_code_prefix] [int] NOT NULL,
	[seller_city] [nvarchar](50) NOT NULL,
	[seller_state] [nvarchar](50) NOT NULL
) ON [PRIMARY]
GO

BULK INSERT dbo.olist_sellers_dataset
FROM './datasheet/olist_sellers_dataset.csv'
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


