CREATE TABLE [dbo].[DimChannel](
	[ChannelKey] [int] IDENTITY(1,1) NOT NULL,
	[ChannelLabel] [nvarchar](100) NOT NULL,
	[ChannelName] [nvarchar](20) NULL,
	[ChannelDescription] [nvarchar](50) NULL,
	[ETLLoadID] [int] NULL,
	[LoadDate] [datetime] NULL,
	[UpdateDate] [datetime] NULL,
 CONSTRAINT [PK_DimChannel_ChannelKey] PRIMARY KEY CLUSTERED 
(
	[ChannelKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE TRIGGER [dbo].[Trigger_DimChannel]
    ON [dbo].[DimChannel]
    FOR DELETE, UPDATE
    AS
    BEGIN
        SET NOCOUNT ON;
		INSERT INTO [Audit].[DimChannel] (
			[ChannelKey], 
			[ChannelLabel], 
			[ChannelName], 
			[ChannelDescription], 
			[ETLLoadID], 
			[LoadDate], 
			[UpdateDate])
		SELECT 
			d.[ChannelKey], 
			d.[ChannelLabel], 
			d.[ChannelName], 
			d.[ChannelDescription], 
			d.[ETLLoadID], 
			d.[LoadDate], 
			d.[UpdateDate]
		FROM [Deleted] AS d
    END
GO

ALTER TABLE [dbo].[DimChannel] DISABLE TRIGGER [Trigger_DimChannel]