CREATE TABLE [dbo].[DimEntity](
	[EntityKey] [int] IDENTITY(1,1) NOT NULL,
	[EntityLabel] [nvarchar](100) NULL,
	[ParentEntityKey] [int] NULL,
	[ParentEntityLabel] [nvarchar](100) NULL,
	[EntityName] [nvarchar](50) NULL,
	[EntityDescription] [nvarchar](100) NULL,
	[EntityType] [nvarchar](100) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[Status] [nvarchar](50) NULL,
	[ETLLoadID] [int] NULL,
	[LoadDate] [datetime] NULL,
	[UpdateDate] [datetime] NULL,
 CONSTRAINT [PK_DimEntity_EntityKey] PRIMARY KEY CLUSTERED 
(
	[EntityKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DimEntity] ADD  CONSTRAINT [DF_DimEntity_Status]  DEFAULT (N'Current') FOR [Status]