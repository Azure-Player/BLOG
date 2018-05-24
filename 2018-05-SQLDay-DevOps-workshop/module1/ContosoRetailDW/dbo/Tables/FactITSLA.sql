CREATE TABLE [dbo].[FactITSLA](
	[ITSLAkey] [int] IDENTITY(1,1) NOT NULL,
	[DateKey] [datetime] NOT NULL,
	[StoreKey] [int] NOT NULL,
	[MachineKey] [int] NOT NULL,
	[OutageKey] [int] NOT NULL,
	[OutageStartTime] [datetime] NOT NULL,
	[OutageEndTime] [datetime] NOT NULL,
	[DownTime] [int] NOT NULL,
	[ETLLoadID] [int] NULL,
	[LoadDate] [datetime] NULL,
	[UpdateDate] [datetime] NULL,
 CONSTRAINT [PK_FactITSLA_ITSLAKey] PRIMARY KEY CLUSTERED 
(
	[ITSLAkey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FactITSLA]  WITH CHECK ADD  CONSTRAINT [FK_FactITSLA_DimDate] FOREIGN KEY([DateKey])
REFERENCES [dbo].[DimDate] ([Datekey])
GO

ALTER TABLE [dbo].[FactITSLA] CHECK CONSTRAINT [FK_FactITSLA_DimDate]
GO
ALTER TABLE [dbo].[FactITSLA]  WITH CHECK ADD  CONSTRAINT [FK_FactITSLA_DimMachine] FOREIGN KEY([MachineKey])
REFERENCES [dbo].[DimMachine] ([MachineKey])
GO

ALTER TABLE [dbo].[FactITSLA] CHECK CONSTRAINT [FK_FactITSLA_DimMachine]
GO
ALTER TABLE [dbo].[FactITSLA]  WITH CHECK ADD  CONSTRAINT [FK_FactITSLA_DimOutage] FOREIGN KEY([OutageKey])
REFERENCES [dbo].[DimOutage] ([OutageKey])
GO

ALTER TABLE [dbo].[FactITSLA] CHECK CONSTRAINT [FK_FactITSLA_DimOutage]
GO
ALTER TABLE [dbo].[FactITSLA]  WITH CHECK ADD  CONSTRAINT [FK_FactITSLA_DimStore] FOREIGN KEY([StoreKey])
REFERENCES [dbo].[DimStore] ([StoreKey])
GO

ALTER TABLE [dbo].[FactITSLA] CHECK CONSTRAINT [FK_FactITSLA_DimStore]