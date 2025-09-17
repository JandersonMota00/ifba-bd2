USE [TrabalhoBD2]
GO


CREATE TABLE [dbo].[produtos](
	[product_id] [nvarchar](50) NOT NULL,
	[product_category_name] [nvarchar](200) NULL,
	[product_name_length] [int] NULL,
	[product_description_length] [int] NULL,
	[product_photos_qty] [int] NULL,
	[product_weight_g] [float] NULL,
	[product_length_cm] [float] NULL,
	[product_height_cm] [float] NULL,
	[product_width_cm] [float] NULL,
 CONSTRAINT [PK_produtos] PRIMARY KEY CLUSTERED 
(
	[product_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO



BULK INSERT dbo.produtos
FROM './olist_products_dataset.csv'
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
