CREATE TABLE [dbo].[FactITMachine](
	[ITMachinekey] [int] IDENTITY(1,1) NOT NULL,
	[MachineKey] [int] NOT NULL,
	[Datekey] [datetime] NOT NULL,
	[CostAmount] [money] NULL,
	[CostType] [nvarchar](200) NOT NULL,
	[ETLLoadID] [int] NULL,
	[LoadDate] [datetime] NULL,
	[UpdateDate] [datetime] NULL,
 CONSTRAINT [PK_FactITMachine] PRIMARY KEY CLUSTERED 
(
	[ITMachinekey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FactITMachine]  WITH CHECK ADD  CONSTRAINT [FK_FactITMachine_DimDate] FOREIGN KEY([Datekey])
REFERENCES [dbo].[DimDate] ([Datekey])
GO

ALTER TABLE [dbo].[FactITMachine] CHECK CONSTRAINT [FK_FactITMachine_DimDate]
GO
ALTER TABLE [dbo].[FactITMachine]  WITH CHECK ADD  CONSTRAINT [FK_FactITMachine_DimMachine] FOREIGN KEY([MachineKey])
REFERENCES [dbo].[DimMachine] ([MachineKey])
GO

ALTER TABLE [dbo].[FactITMachine] CHECK CONSTRAINT [FK_FactITMachine_DimMachine]