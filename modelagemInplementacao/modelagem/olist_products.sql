USE [TrabalhoBD2]
GO

CREATE TABLE [dbo].[olist_products](
	[product_id] [varchar](50) NOT NULL,
	[product_category_name] [varchar](200) NULL,
	[product_name_length] [int] NULL,
	[product_description_length] [int] NULL,
	[product_photos_qty] [int] NULL,
	[product_weight_g] [float] NULL,
	[product_length_cm] [float] NULL,
	[product_height_cm] [float] NULL,
	[product_width_cm] [float] NULL
) ON [PRIMARY]
GO

BULK INSERT dbo.olist_orders
FROM './datasheet/olist_products.csv'
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
