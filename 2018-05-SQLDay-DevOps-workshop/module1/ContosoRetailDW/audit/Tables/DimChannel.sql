CREATE TABLE [audit].[DimChannel](
	[AuditId] [int] IDENTITY(1,1) NOT NULL,
	[AuditDate] [datetime] NULL,
	[ChannelKey] [int] NOT NULL,
	[ChannelLabel] [nvarchar](100) NOT NULL,
	[ChannelName] [nvarchar](20) NULL,
	[ChannelDescription] [nvarchar](50) NULL,
	[ETLLoadID] [int] NULL,
	[LoadDate] [datetime] NULL,
	[UpdateDate] [datetime] NULL,
	[IsTrue]  bit null,
 [IsFalse] BIT NULL, 
    CONSTRAINT [PK_DimChannel_Audit] PRIMARY KEY CLUSTERED 
(
	[AuditId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [audit].[DimChannel] ADD  DEFAULT (getdate()) FOR [AuditDate]
GO

CREATE NONCLUSTERED INDEX [IX_DimChannel_ChannelKey] ON [audit].[DimChannel] (ChannelKey)
GO
