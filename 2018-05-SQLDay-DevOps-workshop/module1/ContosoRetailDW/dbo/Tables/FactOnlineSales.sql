CREATE TABLE [dbo].[FactOnlineSales](
	[OnlineSalesKey] [int] IDENTITY(1,1) NOT NULL,
	[DateKey] [datetime] NOT NULL,
	[StoreKey] [int] NOT NULL,
	[ProductKey] [int] NOT NULL,
	[PromotionKey] [int] NOT NULL,
	[CurrencyKey] [int] NOT NULL,
	[CustomerKey] [int] NOT NULL,
	[SalesOrderNumber] [nvarchar](20) NOT NULL,
	[SalesOrderLineNumber] [int] NULL,
	[SalesQuantity] [int] NOT NULL,
	[SalesAmount] [money] NOT NULL,
	[ReturnQuantity] [int] NOT NULL,
	[ReturnAmount] [money] NULL,
	[DiscountQuantity] [int] NULL,
	[DiscountAmount] [money] NULL,
	[TotalCost] [money] NOT NULL,
	[UnitCost] [money] NULL,
	[UnitPrice] [money] NULL,
	[ETLLoadID] [int] NULL,
	[LoadDate] [datetime] NULL,
	[UpdateDate] [datetime] NULL,
 CONSTRAINT [PK_FactOnlineSales_SalesKey] PRIMARY KEY CLUSTERED 
(
	[OnlineSalesKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FactOnlineSales]  WITH CHECK ADD  CONSTRAINT [FK_FactOnlineSales_DimCurrency] FOREIGN KEY([CurrencyKey])
REFERENCES [dbo].[DimCurrency] ([CurrencyKey])
GO

ALTER TABLE [dbo].[FactOnlineSales] CHECK CONSTRAINT [FK_FactOnlineSales_DimCurrency]
GO
ALTER TABLE [dbo].[FactOnlineSales]  WITH CHECK ADD  CONSTRAINT [FK_FactOnlineSales_DimCustomer] FOREIGN KEY([CustomerKey])
REFERENCES [dbo].[DimCustomer] ([CustomerKey])
GO

ALTER TABLE [dbo].[FactOnlineSales] CHECK CONSTRAINT [FK_FactOnlineSales_DimCustomer]
GO
ALTER TABLE [dbo].[FactOnlineSales]  WITH CHECK ADD  CONSTRAINT [FK_FactOnlineSales_DimDate] FOREIGN KEY([DateKey])
REFERENCES [dbo].[DimDate] ([Datekey])
GO

ALTER TABLE [dbo].[FactOnlineSales] CHECK CONSTRAINT [FK_FactOnlineSales_DimDate]
GO
ALTER TABLE [dbo].[FactOnlineSales]  WITH CHECK ADD  CONSTRAINT [FK_FactOnlineSales_DimProduct] FOREIGN KEY([ProductKey])
REFERENCES [dbo].[DimProduct] ([ProductKey])
GO

ALTER TABLE [dbo].[FactOnlineSales] CHECK CONSTRAINT [FK_FactOnlineSales_DimProduct]
GO
ALTER TABLE [dbo].[FactOnlineSales]  WITH CHECK ADD  CONSTRAINT [FK_FactOnlineSales_DimPromotion] FOREIGN KEY([PromotionKey])
REFERENCES [dbo].[DimPromotion] ([PromotionKey])
GO

ALTER TABLE [dbo].[FactOnlineSales] CHECK CONSTRAINT [FK_FactOnlineSales_DimPromotion]
GO
ALTER TABLE [dbo].[FactOnlineSales]  WITH CHECK ADD  CONSTRAINT [FK_FactOnlineSales_DimStore] FOREIGN KEY([StoreKey])
REFERENCES [dbo].[DimStore] ([StoreKey])
GO

ALTER TABLE [dbo].[FactOnlineSales] CHECK CONSTRAINT [FK_FactOnlineSales_DimStore]