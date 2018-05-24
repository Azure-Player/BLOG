CREATE TABLE [dbo].[DimStore](
	[StoreKey] [int] IDENTITY(1,1) NOT NULL,
	[GeographyKey] [int] NOT NULL,
	[StoreManager] [int] NULL,
	[StoreType] [nvarchar](15) NULL,
	[StoreName] [nvarchar](100) NOT NULL,
	[StoreDescription] [nvarchar](300) NOT NULL,
	[Status] [nvarchar](20) NOT NULL,
	[OpenDate] [datetime] NOT NULL,
	[CloseDate] [datetime] NULL,
	[EntityKey] [int] NULL,
	[ZipCode] [nvarchar](20) NULL,
	[ZipCodeExtension] [nvarchar](10) NULL,
	[StorePhone] [nvarchar](15) NULL,
	[StoreFax] [nvarchar](14) NULL,
	[AddressLine1] [nvarchar](100) NULL,
	[AddressLine2] [nvarchar](100) NULL,
	[CloseReason] [nvarchar](20) NULL,
	[EmployeeCount] [int] NULL,
	[SellingAreaSize] [float] NULL,
	[LastRemodelDate] [datetime] NULL,
	[GeoLocation] [geography] NULL,
	[Geometry] [geometry] NULL,
	[ETLLoadID] [int] NULL,
	[LoadDate] [datetime] NULL,
	[UpdateDate] [datetime] NULL,
 CONSTRAINT [PK_DimStore_StoreKey] PRIMARY KEY CLUSTERED 
(
	[StoreKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[DimStore]  WITH CHECK ADD  CONSTRAINT [FK_DimStore_DimGeography] FOREIGN KEY([GeographyKey])
REFERENCES [dbo].[DimGeography] ([GeographyKey])
GO

ALTER TABLE [dbo].[DimStore] CHECK CONSTRAINT [FK_DimStore_DimGeography]