USE [TrabalhoBD2]
GO

CREATE TABLE [dbo].[ordensReviews](
	[review_id] [nvarchar](50) NOT NULL,
	[order_id] [nvarchar](50) NOT NULL,
	[review_score] [tinyint] NOT NULL,
	[review_comment_title] [nvarchar](50) NULL,
	[review_comment_message] [nvarchar](250) NULL,
	[review_creation_date] [datetime2](7) NOT NULL,
	[review_answer_timestamp] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_ordensReviews] PRIMARY KEY CLUSTERED 
(
	[review_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ordensReviews]  WITH CHECK ADD  CONSTRAINT [FK_ordensReviews_ordensDePagemento] FOREIGN KEY([order_id])
REFERENCES [dbo].[ordensDePagemento] ([order_id])
GO

ALTER TABLE [dbo].[ordensReviews] CHECK CONSTRAINT [FK_ordensReviews_ordensDePagemento]
GO


BULK INSERT dbo.ordensReviews
FROM './olist_order_reviews_dataset.csv'
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
