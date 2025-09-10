USE [TrabalhoBD2]
GO


CREATE TABLE [dbo].[olist_order_items_dataset](
	[order_id] [nvarchar](50) NOT NULL,
	[order_item_id] [tinyint] NOT NULL,
	[product_id] [nvarchar](50) NOT NULL,
	[seller_id] [nvarchar](50) NOT NULL,
	[shipping_limit_date] [datetime2](7) NOT NULL,
	[price] [float] NOT NULL,
	[freight_value] [float] NOT NULL
) ON [PRIMARY]
GO

BULK INSERT dbo.olist_order_items_dataset
FROM './datasheet/olist_order_items_dataset.csv'
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
