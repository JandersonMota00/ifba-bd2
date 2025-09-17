USE [TrabalhoBD2]
GO

CREATE TABLE [dbo].[geolocalizacao](
	[geolocation_zip_code_prefix] [nvarchar](20) NOT NULL,
	[geolocation_lat] [float] NULL,
	[geolocation_lng] [float] NULL,
	[geolocation_city] [nvarchar](100) NOT NULL,
	[geolocation_state] [char](2) NOT NULL
) ON [PRIMARY]
GO


BULK INSERT dbo.geolocalizacao
FROM './olist_geolocation_dataset.csv'
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

