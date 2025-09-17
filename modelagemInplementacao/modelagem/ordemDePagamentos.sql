USE [TrabalhoBD2]
GO

CREATE TABLE [dbo].[ordensDePagemento](
	[order_id] [nvarchar](50) NOT NULL,
	[payment_sequential] [tinyint] NOT NULL,
	[payment_type] [nvarchar](50) NOT NULL,
	[payment_installments] [tinyint] NOT NULL,
	[payment_value] [float] NOT NULL,
 CONSTRAINT [PK_ordensDePagemento] PRIMARY KEY CLUSTERED 
(
	[order_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


BULK INSERT dbo.ordensDePagemento
FROM './olist_order_payments_dataset.csv'
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