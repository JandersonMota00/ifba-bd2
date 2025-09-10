USE [TrabalhoBD2]
GO


CREATE TABLE [dbo].[olist_orders](
	[order_id] [varchar](50) NOT NULL,
	[customer_id] [varchar](50) NOT NULL,
	[order_status] [varchar](50) NOT NULL,
	[order_purchase_timestamp] [datetime2](3) NOT NULL,
	[order_approved_at] [datetime2](3) NULL,
	[order_delivered_carrier_date] [datetime2](3) NULL,
	[order_delivered_customer_date] [datetime2](3) NULL,
	[order_estimated_delivery_date] [datetime2](3) NOT NULL
) ON [PRIMARY]
GO



BULK INSERT dbo.olist_orders
FROM './datasheet/olist_orders.csv'
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
