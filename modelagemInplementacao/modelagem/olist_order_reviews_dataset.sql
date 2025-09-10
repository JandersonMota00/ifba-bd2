USE [TrabalhoBD2]
GO

CREATE TABLE [dbo].[olist_order_reviews_dataset](
	[review_id] [nvarchar](50) NOT NULL,
	[order_id] [nvarchar](50) NOT NULL,
	[review_score] [tinyint] NOT NULL,
	[review_comment_title] [nvarchar](50) NULL,
	[review_comment_message] [nvarchar](250) NULL,
	[review_creation_date] [datetime2](7) NOT NULL,
	[review_answer_timestamp] [datetime2](7) NOT NULL
) ON [PRIMARY]
GO


BULK INSERT dbo.olist_order_reviews_dataset
FROM './datasheet/olist_order_reviews_dataset.csv'
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
