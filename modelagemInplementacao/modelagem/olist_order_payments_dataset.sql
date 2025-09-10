USE [TrabalhoBD2]
GO

CREATE TABLE [dbo].[olist_order_payments_dataset](
	[order_id] [nvarchar](50) NOT NULL,
	[payment_sequential] [tinyint] NOT NULL,
	[payment_type] [nvarchar](50) NOT NULL,
	[payment_installments] [tinyint] NOT NULL,
	[payment_value] [float] NOT NULL
) ON [PRIMARY]
GO

BULK INSERT dbo.olist_order_payments_dataset
FROM './datasheet/olist_order_payments_dataset.csv'
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

