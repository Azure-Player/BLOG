CREATE TABLE [dbo].[FactExchangeRate](
	[ExchangeRateKey] [int] IDENTITY(1,1) NOT NULL,
	[CurrencyKey] [int] NOT NULL,
	[DateKey] [datetime] NOT NULL,
	[AverageRate] [float] NOT NULL,
	[EndOfDayRate] [float] NOT NULL,
	[ETLLoadID] [int] NULL,
	[LoadDate] [datetime] NULL,
	[UpdateDate] [datetime] NULL,
 CONSTRAINT [PK_FactExchangeRate_ExchangeRateKey] PRIMARY KEY CLUSTERED 
(
	[ExchangeRateKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FactExchangeRate]  WITH CHECK ADD  CONSTRAINT [FK_FactExchangeRate_DimCurrency] FOREIGN KEY([CurrencyKey])
REFERENCES [dbo].[DimCurrency] ([CurrencyKey])
GO

ALTER TABLE [dbo].[FactExchangeRate] CHECK CONSTRAINT [FK_FactExchangeRate_DimCurrency]
GO
ALTER TABLE [dbo].[FactExchangeRate]  WITH CHECK ADD  CONSTRAINT [FK_FactExchangeRate_DimDate] FOREIGN KEY([DateKey])
REFERENCES [dbo].[DimDate] ([Datekey])
GO

ALTER TABLE [dbo].[FactExchangeRate] CHECK CONSTRAINT [FK_FactExchangeRate_DimDate]