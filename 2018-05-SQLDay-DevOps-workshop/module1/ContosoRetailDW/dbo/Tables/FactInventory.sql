CREATE TABLE [dbo].[FactInventory](
	[InventoryKey] [int] IDENTITY(1,1) NOT NULL,
	[DateKey] [datetime] NOT NULL,
	[StoreKey] [int] NOT NULL,
	[ProductKey] [int] NOT NULL,
	[CurrencyKey] [int] NOT NULL,
	[OnHandQuantity] [int] NOT NULL,
	[OnOrderQuantity] [int] NOT NULL,
	[SafetyStockQuantity] [int] NULL,
	[UnitCost] [money] NOT NULL,
	[DaysInStock] [int] NULL,
	[MinDayInStock] [int] NULL,
	[MaxDayInStock] [int] NULL,
	[Aging] [int] NULL,
	[ETLLoadID] [int] NULL,
	[LoadDate] [datetime] NULL,
	[UpdateDate] [datetime] NULL,
 CONSTRAINT [PK_FactInventory_InventoryKey] PRIMARY KEY CLUSTERED 
(
	[InventoryKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FactInventory]  WITH CHECK ADD  CONSTRAINT [FK_FactInventory_DimCurrency] FOREIGN KEY([CurrencyKey])
REFERENCES [dbo].[DimCurrency] ([CurrencyKey])
GO

ALTER TABLE [dbo].[FactInventory] CHECK CONSTRAINT [FK_FactInventory_DimCurrency]
GO
ALTER TABLE [dbo].[FactInventory]  WITH CHECK ADD  CONSTRAINT [FK_FactInventory_DimDate] FOREIGN KEY([DateKey])
REFERENCES [dbo].[DimDate] ([Datekey])
GO

ALTER TABLE [dbo].[FactInventory] CHECK CONSTRAINT [FK_FactInventory_DimDate]
GO
ALTER TABLE [dbo].[FactInventory]  WITH CHECK ADD  CONSTRAINT [FK_FactInventory_DimProduct] FOREIGN KEY([ProductKey])
REFERENCES [dbo].[DimProduct] ([ProductKey])
GO

ALTER TABLE [dbo].[FactInventory] CHECK CONSTRAINT [FK_FactInventory_DimProduct]
GO
ALTER TABLE [dbo].[FactInventory]  WITH CHECK ADD  CONSTRAINT [FK_FactInventory_DimStore] FOREIGN KEY([StoreKey])
REFERENCES [dbo].[DimStore] ([StoreKey])
GO

ALTER TABLE [dbo].[FactInventory] CHECK CONSTRAINT [FK_FactInventory_DimStore]